package com.simformsolutions.bagelandroid.ui.main

import android.content.res.Configuration
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.hilt.navigation.compose.hiltViewModel
import com.simformsolutions.bagelandroid.ui.theme.BagelAndroidTheme

@Composable
fun MainRoute(modifier: Modifier = Modifier) {
    val viewModel = hiltViewModel<MainViewModel>()

    val context = LocalContext.current

    MainScreen(
        modifier = modifier,
        onGetHotCoffee = viewModel::getHotCoffee,
    )
}

@Composable
fun MainScreen(
    modifier: Modifier = Modifier,
    onGetHotCoffee: () -> Unit,
) {
    Scaffold(
        modifier = modifier
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize(),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Button(
                onClick = onGetHotCoffee
            ) {
                Text("Get hot coffee")
            }
        }
    }
}

@Preview(showBackground = true)
@Preview(showBackground = true, uiMode = Configuration.UI_MODE_NIGHT_YES)
@Composable
private fun MainScreenPreview() {
    BagelAndroidTheme {
        MainScreen(
            modifier = Modifier
                .fillMaxSize(),
            onGetHotCoffee = {},
        )
    }
}
