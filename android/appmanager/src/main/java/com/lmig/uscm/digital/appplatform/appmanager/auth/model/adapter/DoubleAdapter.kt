package com.lmig.uscm.digital.appplatform.appmanager.auth.model.adapter

import android.support.annotation.Keep
import com.squareup.moshi.FromJson
import com.squareup.moshi.ToJson

@Keep
class DoubleAdapter {
    @ToJson
    fun toJson(double: Double?): String? {
        return double.toString()
    }

    @FromJson
    fun fromJson(json: String?): Double? {
        return json?.toDouble()
    }
}