package com.lmig.uscm.digital.appplatform.appmanager.auth.utils

import org.threeten.bp.format.DateTimeFormatter
import java.text.SimpleDateFormat
import java.util.*

class Formatters private constructor() {
    companion object {
        private val SIMPLE_DATE_FORMAT_ISO_8601_DATE_TIME = SimpleDateFormat(ISO_8601_FORMAT_DATE_TIME, Locale.getDefault())

        /**
         * SimpleDateFormat with the pattern: yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
         */
        fun iso8601DateTimeSimpleDateFormat(): SimpleDateFormat = SIMPLE_DATE_FORMAT_ISO_8601_DATE_TIME

        private val SIMPLE_DATE_FORMAT_ISO_8601_DATE = SimpleDateFormat(ISO_8601_FORMAT_DATE, Locale.getDefault())

        /**
         * SimpleDateFormat with the pattern: yyyy-MM-dd
         */
        fun iso8601DateSimpleDateFormat(): SimpleDateFormat = SIMPLE_DATE_FORMAT_ISO_8601_DATE

        private val DATE_TIME_FORMATTER_ISO_8601_DATE_TIME = DateTimeFormatter.ofPattern(ISO_8601_FORMAT_DATE_TIME)

        /**
         * DateTimeFormatter with the pattern: yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
         */
        fun iso8601DateTimeFormatter(): DateTimeFormatter = DATE_TIME_FORMATTER_ISO_8601_DATE_TIME

        private val DATE_TIME_FORMATTER_ISO_8601_DATE = DateTimeFormatter.ofPattern(ISO_8601_FORMAT_DATE)

        /**
         * DateTimeFormatter with the pattern: yyyy-MM-dd
         */
        fun iso8601DateFormatter(): DateTimeFormatter = DATE_TIME_FORMATTER_ISO_8601_DATE

        private val DATE_OF_BIRTH_FORMAT = SimpleDateFormat(MM_DD_YYYY_FORMAT, Locale.getDefault())

        /**
         * SimpleDateFormat with pattern: MM/dd/yyyy
         */
        fun getDateOfBirthFormat(): SimpleDateFormat = DATE_OF_BIRTH_FORMAT

        private val HEADER_DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("EEEE, MMM dd, yyyy")

        fun getHeaderDateTimeFormatter(): DateTimeFormatter = HEADER_DATE_TIME_FORMATTER
    }
}