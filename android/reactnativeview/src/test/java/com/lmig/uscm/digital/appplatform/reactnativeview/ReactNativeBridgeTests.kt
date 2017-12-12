package com.lmig.uscm.digital.appplatform.reactnativeview

import com.facebook.react.bridge.ReactApplicationContext
import com.lmig.uscm.digital.appplatform.appmanager.CommonEventManager
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.mock
import kotlin.test.assertEquals
import kotlin.test.assertTrue

/**
 * ReactNativeBridge Tests
 */
class ReactNativeBridgeTests {

    private var rnb: ReactNativeBridge? = null

    @Before
    fun setUp() {
        rnb = ReactNativeBridge(eventMan = mock(CommonEventManager::class.java))
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testCreateNativeModules() {
        rnb?.let { rnb ->
            val nativeModules = rnb.createNativeModules(reactContext = mock(ReactApplicationContext::class.java))

            // Check that exactly 2 native module has been created
            assertEquals(3, nativeModules.size)

            // Check that the first item is an instance of EventManager
            assertTrue(nativeModules[0] is EventManager)

            // Check that the second item is an instance of AuthModule
            assertTrue(nativeModules[1] is AuthModule)

            // Check that the second item is an instance of BiometricModule
            assertTrue(nativeModules[2] is BiometricModule)
        }
    }

    @Test
    fun createViewManagers() {
        rnb?.let { rnb ->
            val viewManagers = rnb.createViewManagers(reactContext = mock(ReactApplicationContext::class.java))

            // Check that exactly 0 view managers have been created
            assertEquals(0, viewManagers.size)
        }
    }
}