package com.lmig.uscm.digital.appplatform.appmanager.auth.utils

import com.lmig.uscm.digital.appplatform.appmanager.auth.network.ApiException

fun getErrorMessage(e: Throwable): String {
    return if (e is ApiException) {
        e.body ?: e.statusMessage
    } else {
        e.message!!
    }
}