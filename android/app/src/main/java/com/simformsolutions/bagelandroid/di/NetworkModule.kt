package com.simformsolutions.bagelandroid.di

import com.jakewharton.retrofit2.converter.kotlinx.serialization.asConverterFactory
import com.simform.bagel.intercept.BagelInterceptor
import com.simformsolutions.bagelandroid.remote.NetworkService
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.Json
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.create
import java.util.concurrent.TimeUnit
import javax.inject.Singleton

private const val CONNECT_TIMEOUT_SECONDS = 10L
private const val READ_TIMEOUT_SECONDS = 5L
private const val WRITE_TIMEOUT_SECONDS = 5L

@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {

    @OptIn(ExperimentalSerializationApi::class)
    @Provides
    @Singleton
    fun providesNetworkJson(): Json = Json {
        ignoreUnknownKeys = true
        explicitNulls = false
        coerceInputValues = false
        prettyPrint = true
        encodeDefaults = true
    }

    @Provides
    @Singleton
    fun provideLoggerInterceptor(): HttpLoggingInterceptor = HttpLoggingInterceptor().apply {
        level = HttpLoggingInterceptor.Level.BODY
    }

    @Provides
    @Singleton
    fun provideBagelInterceptor(): BagelInterceptor =
        BagelInterceptor.getInstance()

    @Provides
    @Singleton
    fun provideApiClient(
        logger: HttpLoggingInterceptor,
        bagelInterceptor: BagelInterceptor
    ): OkHttpClient =
        OkHttpClient.Builder()
            .addInterceptor(bagelInterceptor)
            .addInterceptor(logger)
            .connectTimeout(CONNECT_TIMEOUT_SECONDS, TimeUnit.SECONDS)
            .readTimeout(READ_TIMEOUT_SECONDS, TimeUnit.SECONDS)
            .writeTimeout(WRITE_TIMEOUT_SECONDS, TimeUnit.SECONDS)
            .build()

    @Provides
    @Singleton
    fun provideRetrofit(networkJson: Json, client: OkHttpClient): Retrofit = Retrofit.Builder()
        .baseUrl("https://google.com")
        .client(client)
        .addConverterFactory(networkJson.asConverterFactory("application/json".toMediaType()))
        .build()

    @Provides
    @Singleton
    fun provideNetworkService(retrofit: Retrofit): NetworkService = retrofit.create()
}