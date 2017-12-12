package com.lmig.uscm.digital.appplatform.appmanager.auth.network

import android.content.Context
import com.lmig.uscm.digital.appplatform.appmanager.auth.model.data.AuthConfig
import com.lmig.uscm.digital.appplatform.appmanager.auth.model.data.Token
import com.lmig.uscm.digital.appplatform.appmanager.auth.utils.NetworkUtils
import io.reactivex.schedulers.Schedulers
import io.reactivex.android.schedulers.AndroidSchedulers
import com.auth0.android.jwt.JWT
import com.squareup.moshi.Moshi
import okhttp3.logging.HttpLoggingInterceptor

/**
 * The service object will be exposed for use by other platforms.
 * @constructor creates a new AuthApi
 * @property authConfigsFile constant json filename where authconfigs will reside
 * @property decodedToken JWT decoded token
 * @property token encoded token obtained from API response
 * @property userEmail: custom claim decoded from JWT token
 * @property userName: custom claim decoded from JWT token
 */
object AuthService {

    private const val authConfigsFile = "authConfigs.json"

    private var api: AuthApi? = null
    private var authConfig: AuthConfig? = null
    private var decodedToken: JWT? = null
    private var token: Token? = null
    private var userEmail: String? = null
    private var userName: String? = null

    /**
     * Configures the auth api
     * @property config AuthConfig with client credentials
      */
    fun configure(config: AuthConfig) {
        authConfig = config
        val moshi = NetworkUtils.moshi()
        val loggingInterceptor = NetworkUtils.loggingInterceptor(level = HttpLoggingInterceptor.Level.BODY)
        val errorInterceptor = NetworkUtils.errorInterceptor()
        val client = NetworkUtils.okHttpClient(logging = loggingInterceptor, error = errorInterceptor)
        val retrofit = NetworkUtils.retrofit(client = client, moshi = moshi)
        api = NetworkUtils.authApi(retrofit = retrofit)
    }

    /**
     * Configure the auth module with a key
     * The key will be matched to the names of configs in the AuthConfigs.json file in assets.
     * The user will also  be logged out
     * @property environmentKey: The key to match to the name of the AuthConfig
     * @property context: application context where the file is located
     * @property successCallback return true on success
     * @property errorCallback returns [Throwable] on failure
     */
    fun configureWithEnvironmentKey(environmentKey: String, context: Context, successCallback: () -> Unit, errorCallback:(Throwable) -> Unit) {
        try {
            clearUserInfo()

            val content = context.assets.open(authConfigsFile)
            val size = content.available()
            val buffer = ByteArray(size)
            content.read(buffer)
            content.close()

            val jsonString = String(buffer, Charsets.UTF_8)
            val moshi = Moshi.Builder().build()
            val jsonAdapter = moshi.adapter<Array<AuthConfig>>(Array<AuthConfig>::class.java)
            var configs: Array<AuthConfig>? = null

            try {
                configs = jsonAdapter.fromJson(jsonString)
                if (configs != null && configs.count() > 0) {
                    selectAuthConfig(key = environmentKey, configs = configs, successCallback = successCallback, errorCallback = errorCallback)
                } else {
                    errorCallback(Throwable("No auth configs were found in the " + authConfigsFile +  "file"))
                }
            } catch (e: Exception) {
                errorCallback(Throwable(e.message))
            }
        } catch (e: Exception) {
            errorCallback(Throwable(e.message))
        }
    }

    /**
     * Logs a user in & fetch the access token
     * @property username
     * @property password
     * @property successCallback return true on success
     * @property errorCallback returns [Throwable] on failure
     */
    fun login(username: String, password: String, successCallback: (Boolean) -> Unit, errorCallback:(Throwable) -> Unit ) {
        val api = api
        val config = authConfig
        if (api != null && config != null) {
            api.getAccessToken(
                    url = config.authURL,
                    clientId = config.clientId,
                    clientSecret = config.clientSecret,
                    password = password,
                    username = username,
                    validatorId = config.validatorId)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe({ result ->
                        processToken(result)
                        successCallback(true)
                    }, { error -> errorCallback(error) })
        }
    }

    /**
     * Logs the user out: this just means that the service's token info is set to null
     */
    fun logout() {
        clearUserInfo()
    }

    /**
     * Checks if a token exists & is not expired & a username exists
     */
    fun isAuthenticated(): Boolean {
        val decodedToken = decodedToken
        if (userName != null && decodedToken != null && !decodedToken.isExpired(0))
            return true
        return false
    }

    /**
     * Retrieves the token if one exists & returns the access string.
     * If a token exists but has expired, then a refresh attempt is made.
     * If no token is found, get an anonymous one
     * @property successCallback return the obtained token on success
     * @property errorCallback returns [Throwable] on failure
     */
    fun getAccessToken(successCallback: (String) -> Unit, errorCallback:(Throwable) -> Unit) {
        val decodedToken = decodedToken
        val token = token

        if (decodedToken != null && token != null) {
            if (decodedToken.isExpired(15)) {
                if (token.refreshToken != null) {
                    getAccessTokenFromRefreshToken(refreshToken = token.refreshToken, successCallback = successCallback, errorCallback = errorCallback)
                } else {
                    getAnonymousToken(successCallback = successCallback, errorCallback = errorCallback)
                }
            } else {
                successCallback(token.encodedToken)
            }
        } else {
            getAnonymousToken(successCallback = successCallback, errorCallback = errorCallback)
        }
    }

    /**
     * Return email obtained from decoded JWT object
     */
    fun getEmail(): String? {
        return userEmail
    }

    fun getUsername(): String? {
        return userName
    }

    /**
     * Returns the amount of seconds in which the token expires or 0 if null
     */
    fun getExpiresIn(): Int {
        val expiry = decodedToken?.expiresAt?.time
        if (expiry != null ) {
            val diffInMs = expiry - System.currentTimeMillis()
            return (diffInMs / 1000).toInt()
        }
        return 0
    }

    /**
     * Clear info stored w/a successful login
     */
    private fun clearUserInfo() {
        token = null
        decodedToken = null
        userName = null
        userEmail = null
    }

    /**
     * Decode the retrieved token as a JWT object
     * Note: Current expiration time is being passed back from the server in seconds
     *
     * @property unprocessedToken token obtained from auth api call @see[login]
     */
    private fun processToken(unprocessedToken: Token) {
        val decodedToken = JWT(unprocessedToken.encodedToken)
        if (decodedToken != null) {
            this.decodedToken = decodedToken
            token = unprocessedToken.copy()
            userEmail = decodedToken.getClaim("email").asString()
            userName = decodedToken.getClaim("username").asString()
        } else {
            token = null
            userEmail = null
            userName = null
        }
    }

    /**
     * Perform a refresh & return the new access token.
     * @property refreshToken
     * @property successCallback returns the new encoded token on success
     * @property errorCallback returns [Throwable] on failure
     */
    private fun getAccessTokenFromRefreshToken(refreshToken: String, successCallback: (String) -> Unit, errorCallback:(Throwable) -> Unit) {
        val api = api
        val config = authConfig
        if (api != null && config != null) {
            api.refreshToken(
                    url = config.authURL,
                    clientId = config.clientId,
                    clientSecret = config.clientSecret,
                    refreshToken = refreshToken,
                    validatorId = config.validatorId)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe({ result ->
                        processToken(result)
                        val encodedToken = token?.encodedToken
                        if (encodedToken != null) {
                            successCallback(encodedToken)
                        } else {
                            errorCallback(Throwable("unable to process token after refresh"))
                        }
                    }, { error -> errorCallback(error) })
        }
    }

    /**
     * Match a key to a given array of AuthConfigs. Logout user & Reconfigure AuthService if successful
     * @property key: the key to match to the authConfig's name
     * @property configs: an array of AuthConfigs, read from the [authConfigsFile]
     * @property successCallback pass [Boolean] on success
     * @property errorCallback pass [Throwable] on failure
     */
    private fun selectAuthConfig(key:String, configs: Array<AuthConfig>, successCallback: () -> Unit, errorCallback:(Throwable) -> Unit) {
        val selectedConfig = configs.firstOrNull { it.name == key }
        if (selectedConfig != null) {
            configure(config = selectedConfig)
            successCallback()
        } else {
            errorCallback(Throwable("Unable to find config named '" + key + "' in " + authConfigsFile))
        }
    }

    /**
     * Get an anonymous token using clientSecret, clientId & validatorId from config
     * @property successCallback pass [Boolean] on success
     * @property errorCallback pass [Throwable] on failure
     */
    private fun getAnonymousToken(successCallback: (String) -> Unit, errorCallback: (Throwable) -> Unit) {
        val config = authConfig
        val api = api

        if (api == null || config == null) {
            errorCallback(Throwable("getAnonymousToken called without having an API CONFIG or API"))
        } else {
            api.getAnonymousAccessToken(
                    url = config.authURL,
                    clientId = config.clientId,
                    clientSecret = config.clientSecret,
                    validatorId = config.validatorId)
                    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe({ result ->
                        processToken(result)
                        successCallback(result.encodedToken)
                    }, { error -> errorCallback(error) })
        }
    }
}

