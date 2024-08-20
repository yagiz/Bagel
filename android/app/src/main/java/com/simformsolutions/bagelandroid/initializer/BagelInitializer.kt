package com.simformsolutions.bagelandroid.initializer

import android.content.Context
import androidx.startup.Initializer
import com.simform.bagel.Bagel
import com.simform.bagel.config.BagelConfiguration

class BagelInitializer : Initializer<Unit> {
    override fun create(context: Context) {
        Bagel.start(context, BagelConfiguration.getDefault(context).copy(projectName = "Bagel"))
    }

    override fun dependencies(): MutableList<Class<out Initializer<*>>> =
        mutableListOf(TimberInitializer::class.java)
}