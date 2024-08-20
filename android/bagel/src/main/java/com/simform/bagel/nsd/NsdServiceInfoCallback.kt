package com.simform.bagel.nsd

import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.os.Build
import androidx.annotation.RequiresApi
import com.simform.bagel.Bagel.TAG
import timber.log.Timber

@RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
internal interface NsdServiceInfoCallback : NsdManager.ServiceInfoCallback {
    override fun onServiceInfoCallbackRegistrationFailed(errorCode: Int) {
        Timber.tag(TAG).d("onServiceInfoCallbackRegistrationFailed with errorCode $errorCode")
    }

    override fun onServiceUpdated(serviceInfo: NsdServiceInfo) {
        Timber.tag(TAG).d("onServiceUpdated for $serviceInfo")
    }

    override fun onServiceLost() {
        Timber.tag(TAG).d("onServiceLost")
    }

    override fun onServiceInfoCallbackUnregistered() {
        Timber.tag(TAG).d("onServiceInfoCallbackUnregistered")
    }
}