package com.simformsolutions.bagelandroid.domain.repository

import com.simformsolutions.bagelandroid.remote.NetworkService
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import retrofit2.Response
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class NetworkRepositoryImpl @Inject constructor(
    private val networkService: NetworkService
) : NetworkRepository {
    override suspend fun getHotCoffee() {
        withContext(Dispatchers.IO) {
            networkService.getHotCoffee()
        }
    }
}