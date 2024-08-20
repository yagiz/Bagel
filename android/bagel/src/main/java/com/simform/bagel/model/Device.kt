package com.simform.bagel.model

import android.content.Context
import android.os.Build
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class Device(
    @SerialName("deviceDescription")
    val deviceDescription: String,
    @SerialName("deviceName")
    val deviceName: String,
    @SerialName("deviceId")
    val deviceId: String,
) {
    internal companion object {
        @Volatile
        private var INSTANCE: Device? = null

        @Synchronized
        fun initialize(context: Context) {
            INSTANCE = Device(
                deviceName = Build.MODEL,
                deviceDescription = "Android " + Build.VERSION.RELEASE,
                deviceId = "${Build.MANUFACTURER}-${Build.MODEL}-android-${Build.VERSION.RELEASE}"
            )
        }

        @Synchronized
        fun getInstance(): Device = INSTANCE!!
    }
}
