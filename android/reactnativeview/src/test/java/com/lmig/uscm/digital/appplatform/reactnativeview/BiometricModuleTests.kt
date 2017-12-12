package com.lmig.uscm.digital.appplatform.reactnativeview

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito
import kotlin.test.assertEquals

/**
 * BiometricModule Tests
 */
class BiometricModuleTests {

    private var biometricModule: BiometricModule? = null

    @Before
    fun setUp() {
        val mockReactAppContext = Mockito.mock(ReactApplicationContext::class.java)
        biometricModule = BiometricModule(reactContext = mockReactAppContext)
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testGetName() {
        assertEquals("Biometric", biometricModule?.name)
    }

    @Test
    fun testIsSupported() {
        class TestPromise: Promise {
            override fun resolve(value: Any?) {
                val result = value as Boolean
                result?.let{
                    // Should be false as we are running against a mock Context
                    assertEquals(false, it)
                }
            }
            override fun reject(code: String?, message: String?) {}
            override fun reject(code: String?, e: Throwable?) {}
            override fun reject(code: String?, message: String?, e: Throwable?) {}
            override fun reject(message: String?) {}
            override fun reject(reason: Throwable?) {}

        }
        val testProm = TestPromise()
        biometricModule?.isSupported(promise = testProm)
    }

    @Test
    fun testGetBiometricType() {
        class TestPromise: Promise {
            override fun resolve(value: Any?) {
                val result = value as String
                result?.let{
                    // Should be false as we are running against a mock Context
                    assertEquals("fingerprint", it)
                }
            }
            override fun reject(code: String?, message: String?) {}
            override fun reject(code: String?, e: Throwable?) {}
            override fun reject(code: String?, message: String?, e: Throwable?) {}
            override fun reject(message: String?) {}
            override fun reject(reason: Throwable?) {}

        }
        val testProm = TestPromise()
        biometricModule?.getBiometricType(promise = testProm)
    }

    // Has Credentials, Get Credentials, Save Credentials & Delete Credentials cannot be easily tested as they
    // require interaction with SharedPreferences
}