package com.lmig.uscm.digital.appplatform.reactnativeview

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.lmig.uscm.digital.appplatform.appmanager.auth.model.data.AuthConfig
import com.lmig.uscm.digital.appplatform.appmanager.auth.network.AuthService

/**
 * Created on 10/19/17.
 */
class AuthModule (internal var reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "Auth"
    }

    @ReactMethod
    fun configure(name: String, authUrl: String, clientId: String, clientSecret: String, validatorID: String, promise: Promise) {
        val config = AuthConfig(
                name = name,
                authURL = authUrl,
                clientId = clientId,
                clientSecret = clientSecret,
                validatorId = validatorID
        )

        AuthService.configure(config = config)
        promise.resolve(null)
    }

    @ReactMethod
    fun configureWithEnvironmentKey(environmentKey: String, promise: Promise) {
        val successCallback: () -> Unit = {
            promise.resolve(null)
        }
        val errorCallback: (Throwable) -> Unit = { error ->
            promise.reject(error)
        }

        AuthService.configureWithEnvironmentKey(environmentKey = environmentKey, context = reactContext, successCallback = successCallback, errorCallback = errorCallback)
    }

    @ReactMethod
    fun isAuthenticated(promise: Promise) {
        promise.resolve(AuthService.isAuthenticated())
    }

    @ReactMethod
    fun login(username: String, password: String, promise: Promise) {
        val successCallback: (Boolean) -> Unit = { success ->
            promise.resolve(success)
        }
        val errorCallback: (Throwable) -> Unit = { error ->
            promise.reject(error)
        }

        AuthService.login(username = username, password = password, successCallback = successCallback, errorCallback = errorCallback)
    }

    @ReactMethod
    fun logout(promise: Promise) {
        AuthService.logout()
        promise.resolve(null)
    }

    @ReactMethod
    fun getAccessToken(promise: Promise) {
        val successCallback: (String) -> Unit = { tokenString ->
            promise.resolve(tokenString)
        }
        val errorCallback: (Throwable) -> Unit = { error ->
            promise.reject(error)
        }
        AuthService.getAccessToken(successCallback = successCallback, errorCallback = errorCallback)
    }

    @ReactMethod
    fun getEmail(promise: Promise) {
        promise.resolve(AuthService.getEmail())
    }

    @ReactMethod
    fun getUsername(promise: Promise) {
        promise.resolve(AuthService.getUsername())
    }

    @ReactMethod
    fun getExpiresIn(promise: Promise) {
        promise.resolve(AuthService.getExpiresIn())
    }

}