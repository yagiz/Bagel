package com.simformsolutions.bagelandroid.remote

import retrofit2.Response
import retrofit2.http.GET

interface NetworkService {

    @GET("https://api.sampleapis.com/coffee/hot")
    suspend fun getHotCoffee(): Unit
}