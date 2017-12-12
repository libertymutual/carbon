package com.lmig.uscm.digital.appplatform.auth.model.adapter

import android.support.annotation.Keep
import com.squareup.moshi.FromJson
import com.squareup.moshi.ToJson
import org.threeten.bp.LocalDateTime
import com.lmig.uscm.digital.appplatform.appmanager.auth.utils.Formatters

@Keep
class LocalDateTimeAdapter {
    @ToJson
    fun toJson(localDateTime: LocalDateTime): String {
        return Formatters.iso8601DateTimeFormatter().format(localDateTime)
    }

    @FromJson
    fun fromJson(json: String): LocalDateTime {
        return LocalDateTime.parse(json, Formatters.iso8601DateTimeFormatter())
    }
}