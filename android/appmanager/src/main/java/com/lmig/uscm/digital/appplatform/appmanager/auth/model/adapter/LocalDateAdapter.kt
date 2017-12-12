package com.lmig.uscm.digital.appplatform.auth.model.adapter

import android.support.annotation.Keep
import com.squareup.moshi.FromJson
import com.squareup.moshi.ToJson
import org.threeten.bp.LocalDate
import com.lmig.uscm.digital.appplatform.appmanager.auth.utils.Formatters


@Keep
class LocalDateAdapter {
    @ToJson
    fun toJson(date: LocalDate): String {
        return date.format(Formatters.iso8601DateFormatter())
    }

    @FromJson
    fun fromJson(json: String): LocalDate {
        return LocalDate.parse(json, Formatters.iso8601DateFormatter())
    }
}