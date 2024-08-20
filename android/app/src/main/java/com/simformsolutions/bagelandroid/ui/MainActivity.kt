package com.simformsolutions.bagelandroid.ui

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.simformsolutions.bagelandroid.ui.main.MainRoute
import com.simformsolutions.bagelandroid.ui.main.MainScreen
import com.simformsolutions.bagelandroid.ui.theme.BagelAndroidTheme
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            BagelAndroidTheme {
                Scaffold(
                    modifier = Modifier.fillMaxSize()
                ) { innerPadding ->
                    MainApp(
                        modifier = Modifier
                            .padding(innerPadding),
                    )
                }
            }
        }
    }
}

@Composable
private fun MainApp(
    modifier: Modifier = Modifier,
) {
    MainRoute(
        modifier = modifier
    )
}
