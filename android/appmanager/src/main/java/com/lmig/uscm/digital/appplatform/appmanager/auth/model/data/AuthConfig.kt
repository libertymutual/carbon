package com.lmig.uscm.digital.appplatform.appmanager.auth.model.data

/**
 * Created on 10/25/17.
 */
data class AuthConfig constructor(
        val name: String,
        val authURL: String,
        val clientId: String,
        val clientSecret: String,
        val validatorId: String)
