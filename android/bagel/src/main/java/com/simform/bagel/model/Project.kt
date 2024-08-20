package com.simform.bagel.model

import android.content.Context
import com.simform.bagel.config.BagelConfiguration
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class Project(
    @SerialName("projectName")
    val projectName: String
) {
    internal companion object {
        @Volatile
        private var INSTANCE: Project? = null

        @Synchronized
        fun initialize(context: Context, bagelConfiguration: BagelConfiguration) {
            INSTANCE = Project(projectName = bagelConfiguration.projectName)
        }

        @Synchronized
        fun getInstance(): Project = INSTANCE!!
    }
}
