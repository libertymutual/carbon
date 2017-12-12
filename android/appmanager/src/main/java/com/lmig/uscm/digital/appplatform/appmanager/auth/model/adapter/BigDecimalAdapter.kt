package com.lmig.uscm.digital.appplatform.appmanager.auth.model.adapter

import android.support.annotation.Keep
import com.squareup.moshi.FromJson
import com.squareup.moshi.ToJson
import java.math.BigDecimal

@Keep
class BigDecimalAdapter {
    @ToJson
    fun toJson(bigDecimal: BigDecimal): String {
        val raw = bigDecimal.toDouble()
        return raw.toString()
    }

    @FromJson
    fun fromJson(json: String): BigDecimal {
        val raw = json.toDouble()
        return BigDecimal(raw)
    }
}