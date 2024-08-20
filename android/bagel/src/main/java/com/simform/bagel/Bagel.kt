package com.simform.bagel

import android.content.Context
import com.simform.bagel.browser.BagelBrowser
import com.simform.bagel.config.BagelConfiguration
import com.simform.bagel.model.Device
import com.simform.bagel.model.Project
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch

object Bagel {
    internal const val TAG = "Bagel"

    private val mainScope = MainScope()

    @JvmStatic
    @JvmOverloads
    fun start(
        context: Context,
        bagelConfiguration: BagelConfiguration = BagelConfiguration.getDefault(context)
    ) {
        mainScope.launch(Dispatchers.Default) {
            // Initialize models
            Device.initialize(context = context)
            Project.initialize(context = context, bagelConfiguration = bagelConfiguration)
            // Initialize network browser
            BagelBrowser.initialize(context = context, bagelConfiguration = bagelConfiguration)
        }
    }
}