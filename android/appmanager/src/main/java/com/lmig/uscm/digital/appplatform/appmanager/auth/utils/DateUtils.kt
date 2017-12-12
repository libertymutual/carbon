package com.lmig.uscm.digital.appplatform.appmanager.auth.utils

import org.threeten.bp.*
import org.threeten.bp.format.DateTimeFormatter
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*

const val ISO_8601_FORMAT_DATE = "yyyy-MM-dd"
const val ISO_8601_FORMAT_DATE_TIME = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
const val MM_DD_YYYY_FORMAT = "MM/dd/yyyy"

fun Date.toFormattedString(dateFormat: DateFormat): String = dateFormat.format(this)

fun Date.toFormattedString(): String = toFormattedString(SimpleDateFormat.getDateInstance())

fun LocalDate.toFormattedString(): String = format(DateTimeFormatter.ofPattern("MM/dd/yyyy"))

fun Instant.UTC(): Instant {
    val zoned = ZonedDateTime.ofInstant(this, ZoneId.of("UTC"))
    return zoned.toInstant()
}

fun LocalDateTime.toEpochMilli(): Long {
    val zoned = atZone(ZoneId.systemDefault())
    return zoned.toInstant().toEpochMilli()
}

fun fromEpochMilli(epochMilli: Long): LocalDateTime? {
    if (epochMilli < 0) return null
    val instant = Instant.ofEpochMilli(epochMilli)
    return LocalDateTime.ofInstant(instant, ZoneId.systemDefault())
}

fun calendarOf(year: Int, month: Int, date: Int): Calendar {
    return Calendar.getInstance().apply {
        set(year, month, date)
    }
}

fun calendarOf(year: Int, month: Int, date: Int, hourOfDay: Int, minute: Int): Calendar {
    return Calendar.getInstance().apply {
        set(year, month, date, hourOfDay, minute)
    }
}

fun calendarOf(year: Int, month: Int, date: Int, hourOfDay: Int, minute: Int, second: Int): Calendar {
    return Calendar.getInstance().apply {
        set(year, month, date, hourOfDay, minute, second)
    }
}

fun calendarOf(date: Date): Calendar {
    return Calendar.getInstance().apply {
        time = date
    }
}