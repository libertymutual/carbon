package com.lmig.uscm.digital.helloworld

import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.doNothing
import org.mockito.Mockito.spy
import kotlin.test.assertEquals
import kotlin.test.assertTrue

/**
 * MainApplication Tests
 */
class MainApplicationTests {

    var ma: MainApplication? = null

    @Before
    fun setUp() {
        ma = spy(MainApplication::class.java)
        doNothing().`when`(ma as MainApplication).initializeAppPlatform()
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        assertTrue(ma is MainApplication)

        // Test Default Feature
        assertEquals("Default", ma?.defaultFeature)

        // Test appConfigFilename
        assertEquals("app.json", ma?.appConfigFilename)

        // Test appConfigFilename
        assertTrue(ma?.eventManager is AppEventManager)
    }

    @Test
    fun testOnCreate() {
        ma?.onCreate()

        assertEquals(2, ma?.featuresList?.size)
    }
}
