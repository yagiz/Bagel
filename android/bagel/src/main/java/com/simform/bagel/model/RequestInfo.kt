package com.simform.bagel.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class RequestInfo(
    @SerialName("url")
    val url: String,
    @SerialName("responseData")
    val responseData: String,
    @SerialName("requestBody")
    val requestBody: String,
    @SerialName("endDate")
    val endDate: Long,
    @SerialName("requestHeaders")
    val requestHeaders: Map<String, String>,
    @SerialName("requestMethod")
    val requestMethod: String,
    @SerialName("statusCode")
    val statusCode: String,
    @SerialName("startDate")
    val startDate: Long
)
