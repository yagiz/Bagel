package com.simformsolutions.bagelandroid.di

import com.simformsolutions.bagelandroid.domain.repository.NetworkRepository
import com.simformsolutions.bagelandroid.domain.repository.NetworkRepositoryImpl
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
interface RepositoryModule {
    @Singleton
    @Binds
    fun bindNetworkRepository(impl: NetworkRepositoryImpl): NetworkRepository
}