package com.simformsolutions.bagelandroid.domain.repository

import retrofit2.Response

interface NetworkRepository {

    suspend fun getHotCoffee()
}