package com.simform.bagel.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import java.util.UUID

@Serializable
internal data class Packet(
    @SerialName("device")
    val device: Device = Device.getInstance(),
    @SerialName("packetId")
    val packetId: String = UUID.randomUUID().toString(),
    @SerialName("requestInfo")
    val requestInfo: RequestInfo,
    @SerialName("project")
    val project: Project = Project.getInstance()
)
