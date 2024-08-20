package com.simformsolutions.bagelandroid.ui.main

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.simformsolutions.bagelandroid.domain.repository.NetworkRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class MainViewModel @Inject constructor(
    private val networkRepository: NetworkRepository
) : ViewModel() {

    private val _resetCommand = MutableSharedFlow<Unit>()
    val resetCommand = _resetCommand.asSharedFlow()

    fun getHotCoffee() {
        viewModelScope.launch(Dispatchers.Default) {
            networkRepository.getHotCoffee()
        }
    }

    fun resetAndRestart() {
        viewModelScope.launch {
            _resetCommand.emit(Unit)
        }
    }
}