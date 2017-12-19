package com.lmig.uscm.digital.appplatform.appmanager.auth.network

class ApiException(val statusCode: Int,
                   val statusMessage: String,
                   val body: String? = null) : RuntimeException()