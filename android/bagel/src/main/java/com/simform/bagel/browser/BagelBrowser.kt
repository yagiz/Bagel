package com.simform.bagel.browser

import android.content.Context
import com.simform.bagel.config.BagelConfiguration
import com.simform.bagel.model.RequestInfo

internal interface BagelBrowser {

    fun sendPacket(requestInfo: RequestInfo)

    companion object {
        @Volatile
        private var INSTANCE: BagelBrowser? = null

        @Synchronized
        fun initialize(context: Context, bagelConfiguration: BagelConfiguration) {
            INSTANCE = INSTANCE ?: BagelBrowserImpl.getInstance(
                context = context,
                bagelConfiguration = bagelConfiguration
            )
        }

        @Synchronized
        fun getInstance(): BagelBrowser =
            INSTANCE!!
    }
}
