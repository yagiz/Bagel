package com.simform.bagel.intercept

import com.simform.bagel.browser.BagelBrowser
import com.simform.bagel.model.RequestInfo
import okhttp3.Interceptor
import okhttp3.RequestBody
import okhttp3.Response
import okio.Buffer
import timber.log.Timber
import java.util.Base64

class BagelInterceptor private constructor() : Interceptor {

    private val bagelBrowser by lazy {
        BagelBrowser.getInstance()
    }

    override fun intercept(chain: Interceptor.Chain): Response =
        chain.proceed(chain.request()).also {
            bagelBrowser.sendPacket(requestInfo = it.requestInfo())
        }

    private fun Response.requestInfo(): RequestInfo = RequestInfo(
        url = request.url.toString(),
        requestMethod = request.method,
        requestHeaders = request.headers.toMap(),
        startDate = sentRequestAtMillis / 1000,
        endDate = receivedResponseAtMillis / 1000,
        responseData = responseBase64(),
        requestBody = requestBase64(),
        statusCode = code.toString()
    )

    private fun Response.responseBase64(): String = Base64.getEncoder().encodeToString(
        peekBody(Long.MAX_VALUE).bytes()
    )

    private fun Response.requestBase64(): String = request.body?.toByteArray()?.let {
        Base64.getEncoder().encodeToString(it)
    }.orEmpty()

    private fun RequestBody.toByteArray(): ByteArray? = try {
        val buffer = Buffer().apply {
            writeTo(this)
        }
        buffer.readByteArray()
    } catch (e: Exception) {
        Timber.e(e)
        null
    }

    companion object {
        @Volatile
        private var INSTANCE: BagelInterceptor? = null

        @JvmStatic
        @Synchronized
        fun getInstance(): BagelInterceptor =
            INSTANCE ?: let {
                INSTANCE = BagelInterceptor()
                INSTANCE!!
            }
    }
}