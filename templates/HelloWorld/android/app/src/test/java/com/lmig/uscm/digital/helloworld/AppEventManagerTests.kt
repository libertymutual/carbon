package com.lmig.uscm.digital.helloworld

import com.lmig.uscm.digital.appplatform.appmanager.AppPlatformApplication
import org.junit.After
import org.junit.Before
import org.junit.Test
import kotlin.test.assertTrue

/**
 * AppEventManager Tests
 */
class AppEventManagerTests {

    @Before
    fun setUp() {
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        val aem = AppEventManager(app = AppPlatformApplication())
        assertTrue(aem is AppEventManager)
    }
}
