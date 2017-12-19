package com.lmig.uscm.digital.appplatform.appmanager.auth.network

import okhttp3.Interceptor
import okhttp3.Response

class ErrorInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val response = chain.proceed(chain.request())

        if (!response.isSuccessful) {
            println("ERROR: ${response.message()} ${response.body()?.string()}")
            throw ApiException(statusCode = response.code(), statusMessage = response.message(), body = response.body()?.string())
        }

        return response
    }
}