package com.lmig.uscm.digital.appplatform.appmanager.auth.utils

import com.lmig.uscm.digital.appplatform.appmanager.auth.model.adapter.BigDecimalAdapter
import com.lmig.uscm.digital.appplatform.appmanager.auth.model.adapter.DoubleAdapter
import com.lmig.uscm.digital.appplatform.appmanager.auth.network.AuthApi
import com.lmig.uscm.digital.appplatform.appmanager.auth.network.ErrorInterceptor
import com.squareup.moshi.Moshi
import com.squareup.moshi.Rfc3339DateJsonAdapter

import io.reactivex.schedulers.Schedulers
import okhttp3.HttpUrl
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.converter.moshi.MoshiConverterFactory
import java.util.*

import com.lmig.uscm.digital.appplatform.auth.model.adapter.*

object NetworkUtils {

    fun errorInterceptor(): Interceptor = ErrorInterceptor()

    fun okHttpClient(logging: Interceptor, error: Interceptor): OkHttpClient {
        return OkHttpClient.Builder()
                .addInterceptor(logging)
                .addInterceptor(error)
                .build()
    }

    fun loggingInterceptor(level: HttpLoggingInterceptor.Level): Interceptor {
        return HttpLoggingInterceptor().apply {
            this.level = level
        }
    }

    fun moshi(): Moshi {
        return Moshi.Builder()
                .add(LocalDateAdapter())
                .add(LocalDateTimeAdapter())
                .add(BigDecimalAdapter())
                .add(DoubleAdapter())
                .add(Date::class.java, Rfc3339DateJsonAdapter().nullSafe())
                .build()
    }

    fun retrofit(client: OkHttpClient, moshi: Moshi): Retrofit {
        return Retrofit.Builder()
                .client(client)
                .baseUrl("http://localhost/")
                .addConverterFactory(MoshiConverterFactory.create(moshi))
                .addCallAdapterFactory(RxJava2CallAdapterFactory
                        .createWithScheduler(Schedulers.io()))
                .build()
    }

    fun authApi(retrofit: Retrofit): AuthApi = retrofit.create(AuthApi::class.java)
}