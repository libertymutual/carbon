package com.lmig.uscm.digital.appplatform.appmanager.auth.network

import io.reactivex.Observable
import com.lmig.uscm.digital.appplatform.appmanager.auth.model.data.Token
import retrofit2.http.*

/**
 * All API calls for Authentication
 * NOTE: for each call the entire URL is specified: the auth url is dynamic
 */
interface AuthApi {
    @FormUrlEncoded
    @POST
    fun getAccessToken(
            @Url url: String,
            @Field("client_id") clientId: String,
            @Field("client_secret") clientSecret: String,
            @Field("password") password: String,
            @Field("username") username: String,
            @Field("validator_id") validatorId: String,
            @Field("grant_type") grantType: String = "password"
    ): Observable<Token>

    @FormUrlEncoded
    @POST
    fun getAnonymousAccessToken(
            @Url url: String,
            @Field("client_id") clientId: String,
            @Field("client_secret") clientSecret: String,
            @Field("validator_id") validatorId: String,
            @Field("grant_type") grantType: String = "client_credentials"
    ): Observable<Token>

    @FormUrlEncoded
    @POST
    fun refreshToken(
            @Url url: String,
            @Field("client_id") clientId: String,
            @Field("client_secret") clientSecret: String,
            @Field("refresh_token") refreshToken: String,
            @Field("validator_id") validatorId: String, @Field("grant_type") grantType: String = "refresh_token"
    ): Observable<Token>
}