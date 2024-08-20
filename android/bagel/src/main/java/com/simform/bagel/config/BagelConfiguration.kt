package com.simform.bagel.config

import android.content.Context

data class BagelConfiguration(
    val projectName: String,
    val netServiceType: String = SERVICE_TYPE,
) {
    companion object {
        private const val SERVICE_TYPE = "_Bagel._tcp"

        @JvmStatic
        fun getDefault(context: Context): BagelConfiguration = BagelConfiguration(
            projectName = context.packageManager.getApplicationLabel(context.applicationInfo).toString()
        )
    }
}
