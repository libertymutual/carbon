package com.lmig.uscm.digital.appplatform.appmanager.auth.model.data

import com.squareup.moshi.Json

data class Token(@field:Json(name = ACCESS_TOKEN) val encodedToken: String,
                 @field:Json(name = REFRESH_TOKEN) val refreshToken: String?,
                 @field:Json(name = TOKEN_TYPE) val tokenType: String) {

    companion object {
        const val ACCESS_TOKEN = "access_token"
        const val REFRESH_TOKEN = "refresh_token"
        const val TOKEN_TYPE = "token_type"
    }
}
