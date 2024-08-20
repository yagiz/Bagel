package com.simform.bagel.browser

import android.content.Context
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.os.Build
import androidx.annotation.RequiresApi
import com.simform.bagel.config.BagelConfiguration
import com.simform.bagel.model.Packet
import com.simform.bagel.model.RequestInfo
import com.simform.bagel.nsd.NsdDiscoveryListener
import com.simform.bagel.nsd.NsdResolveListener
import com.simform.bagel.nsd.NsdServiceInfoCallback
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.launch
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import timber.log.Timber
import java.net.Socket
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.Executors

internal class BagelBrowserImpl private constructor(
    private val context: Context,
    private val bagelConfiguration: BagelConfiguration
) : BagelBrowser {

    private val bagelScope = MainScope()

    private val json by lazy {
        Json {
            prettyPrint = false
            ignoreUnknownKeys = true
            encodeDefaults = true
        }
    }

    private val nsdManager by lazy {
        context.getSystemService(Context.NSD_SERVICE) as NsdManager
    }

    private val discoverExecutor by lazy { Executors.newSingleThreadExecutor() }

    private val nsdServices = ConcurrentHashMap<String, NsdServiceInfo>()
    private val socketConnections = ConcurrentHashMap<String, MutableMap<String, Socket>>()

    private val nsdServiceInfoCallback
        get() = @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
        object : NsdServiceInfoCallback {

            private var nsdServiceInfo: NsdServiceInfo? = null

            override fun onServiceUpdated(serviceInfo: NsdServiceInfo) {
                super.onServiceUpdated(serviceInfo)
                nsdServiceInfo = serviceInfo
                onNsdServiceInfoFound(serviceInfo)
            }

            override fun onServiceLost() {
                super.onServiceLost()
                val serviceInfo = nsdServiceInfo ?: return
                onNsdServiceLost(serviceInfo)
            }
        }

    private val nsdResolveListener
        get() = object : NsdResolveListener {

            private var nsdServiceInfo: NsdServiceInfo? = null

            override fun onServiceResolved(serviceInfo: NsdServiceInfo?) {
                super.onServiceResolved(serviceInfo)
                val nsdInfo = nsdServiceInfo
                if (serviceInfo == null && nsdInfo != null) {
                    nsdServices.remove(nsdInfo.serviceName)
                    return
                }
                serviceInfo ?: return
                nsdServiceInfo = serviceInfo
                onNsdServiceInfoFound(serviceInfo)
            }
        }

    private val nsdDiscoveryListener = object : NsdDiscoveryListener {
        override fun onServiceFound(serviceInfo: NsdServiceInfo?) {
            super.onServiceFound(serviceInfo)

            serviceInfo ?: return

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                nsdManager.registerServiceInfoCallback(
                    serviceInfo,
                    Executors.newSingleThreadExecutor(),
                    nsdServiceInfoCallback
                )
            } else {
                nsdManager.resolveService(
                    serviceInfo,
                    nsdResolveListener
                )
            }
        }

        override fun onServiceLost(serviceInfo: NsdServiceInfo?) {
            super.onServiceLost(serviceInfo)
            serviceInfo ?: return
            onNsdServiceLost(serviceInfo)
        }
    }

    override fun sendPacket(requestInfo: RequestInfo) {
        val packet = Packet(requestInfo = requestInfo)
            .let { json.encodeToString(it) }
            .toByteArray()
        val buffer = ByteBuffer.allocate(8 + packet.size)
            .order(ByteOrder.LITTLE_ENDIAN)
            .apply {
                putLong(packet.size.toLong())
                put(packet)
            }
        bagelScope.launch(Dispatchers.IO) {
            socketConnections.values.flatMap { connection ->
                connection.map { (address, socket) ->
                    async {
                        try {
                            if (!socket.isClosed && socket.isConnected) {
                                socket.getOutputStream()
                                    .write(buffer.array())
                            }
                        } catch (e: Exception) {
                            Timber.w(message = "Failed to write data for $address", t = e)
                        }
                    }
                }
            }.awaitAll()
        }
    }

    init {
        start()
    }

    private fun start() = with(nsdManager) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            discoverServices(
                bagelConfiguration.netServiceType,
                NsdManager.PROTOCOL_DNS_SD,
                null,
                discoverExecutor,
                nsdDiscoveryListener
            )
        } else {
            discoverServices(
                bagelConfiguration.netServiceType,
                NsdManager.PROTOCOL_DNS_SD,
                nsdDiscoveryListener
            )
        }
    }

    private fun onNsdServiceInfoFound(nsdServiceInfo: NsdServiceInfo) {
        bagelScope.launch(Dispatchers.IO) {
            val serviceName = nsdServiceInfo.serviceName
            nsdServices[serviceName] = nsdServiceInfo

            val addresses = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                nsdServiceInfo.hostAddresses
            } else {
                listOf(nsdServiceInfo.host)
            }

            val socketConnectionsOfThisService =
                socketConnections.getOrDefault(serviceName, mutableMapOf())
            val updatedConnections = mutableMapOf<String, Socket>()

            addresses.forEach { address ->
                val hostAddress = address.hostAddress
                if (hostAddress != null) {
                    val hostConnectionExists =
                        socketConnectionsOfThisService.containsKey(hostAddress)
                    if (!hostConnectionExists) {
                        try {
                            Timber.d("Connecting to $hostAddress:${nsdServiceInfo.port}")
                            val socket = Socket(hostAddress, nsdServiceInfo.port).apply {
                                keepAlive = true
                            }

                            updatedConnections[hostAddress] = socket

                            if (socket.isConnected) {
                                Timber.d("Connected with $hostAddress:${nsdServiceInfo.port} hostname: $serviceName")
                            }
                        } catch (e: Exception) {
                            Timber.w(e)
                        }
                    } else {
                        // We're sure that it exists so lets copy it over
                        updatedConnections[hostAddress] =
                            socketConnectionsOfThisService[hostAddress]!!
                    }
                }
            }

            socketConnections[serviceName] = updatedConnections

            // Close socket connection with addresses that no longer exist in bagel service
            (socketConnections.keys - updatedConnections.keys)
                .mapNotNull { key -> socketConnectionsOfThisService[key] }
                .forEach { socket ->
                    if (socket.isConnected) {
                        socket.close()
                    }
                }
        }
    }

    private fun onNsdServiceLost(nsdServiceInfo: NsdServiceInfo) {
        val serviceName = nsdServiceInfo.serviceName
        if (!nsdServices.containsKey(serviceName)) {
            return
        }
        socketConnections[serviceName]?.values?.forEach { socket ->
            if (socket.isConnected) {
                socket.close()
            }
        }
        socketConnections.remove(serviceName)
        nsdServices.remove(nsdServiceInfo.serviceName)
    }

    companion object {
        fun getInstance(
            context: Context,
            bagelConfiguration: BagelConfiguration
        ): BagelBrowserImpl = BagelBrowserImpl(
            context = context,
            bagelConfiguration = bagelConfiguration
        )
    }
}
