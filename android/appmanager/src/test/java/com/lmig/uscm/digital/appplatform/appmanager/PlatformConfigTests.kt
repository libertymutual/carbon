package com.lmig.uscm.digital.appplatform.appmanager

import org.junit.After
import org.junit.Before
import org.junit.Test
import kotlin.test.assertTrue

/**
 * PlatformConfig Tests
 */
class PlatformConfigTests {

    private val platformConfig = PlatformConfig(attributes = HashMap<String,Any>())

    @Before
    fun setUp() {

    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        assertTrue(platformConfig is PlatformConfig)
    }
}