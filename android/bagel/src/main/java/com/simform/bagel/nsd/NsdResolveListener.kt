package com.simform.bagel.nsd

import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import com.simform.bagel.Bagel.TAG
import timber.log.Timber

internal interface NsdResolveListener : NsdManager.ResolveListener {
    override fun onResolveFailed(serviceInfo: NsdServiceInfo?, errorCode: Int) {
        Timber.tag(TAG).d("onResolveFailed for $serviceInfo with errorCode $errorCode")
    }

    override fun onServiceResolved(serviceInfo: NsdServiceInfo?) {
        Timber.tag(TAG).d("onServiceResolved for $serviceInfo")
    }
}