package com.simform.bagel.nsd

import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import com.simform.bagel.Bagel.TAG
import timber.log.Timber

internal interface NsdDiscoveryListener : NsdManager.DiscoveryListener {
    override fun onStartDiscoveryFailed(serviceType: String?, errorCode: Int) {
        Timber.tag(TAG).d("onStartDiscoveryFailed for $serviceType with errorCode $errorCode")
    }

    override fun onStopDiscoveryFailed(serviceType: String?, errorCode: Int) {
        Timber.tag(TAG).d("onStopDiscoveryFailed for $serviceType with errorCode $errorCode")
    }

    override fun onDiscoveryStarted(serviceType: String?) {
        Timber.tag(TAG).d("onDiscoveryStarted for $serviceType")
    }

    override fun onDiscoveryStopped(serviceType: String?) {
        Timber.tag(TAG).d("onDiscoveryStopped for $serviceType")
    }

    override fun onServiceFound(serviceInfo: NsdServiceInfo?) {
        Timber.tag(TAG).d("onServiceFound for $serviceInfo")
    }

    override fun onServiceLost(serviceInfo: NsdServiceInfo?) {
        Timber.tag(TAG).d("onServiceLost for $serviceInfo")
    }
}