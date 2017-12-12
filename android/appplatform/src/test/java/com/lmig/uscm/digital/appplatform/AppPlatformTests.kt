package com.lmig.uscm.digital.appplatform

import org.junit.After
import org.junit.Before
import org.junit.Test
import kotlin.test.assertTrue

/**
 * AppPlatform Tests
 */
class AppPlatformTests {

    private var appPlatform: AppPlatform? = null

    @Before
    fun setUp() {
        appPlatform = AppPlatform()
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        appPlatform?.let { appPlatform ->
            assertTrue(appPlatform is AppPlatform)
        }
    }
}