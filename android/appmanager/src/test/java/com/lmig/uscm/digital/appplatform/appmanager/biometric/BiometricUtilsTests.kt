package com.lmig.uscm.digital.appplatform.appmanager.biometric

import android.content.Context
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito
import kotlin.test.assertEquals
import kotlin.test.assertFalse

/**
 * BiometricUtils Tests
 */
class BiometricUtilsTests {

    private val mockContext: Context = Mockito.mock(Context::class.java, Mockito.RETURNS_DEEP_STUBS)

    @Before
    fun setUp() {
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testIsSupported() {
        assertFalse(BiometricUtils.isSupported(context = mockContext))
    }

    @Test
    fun testGetBiometricType() {
        assertEquals("fingerprint", BiometricUtils.getBiometricType())
    }
    // Has Credentials & Delete Credentials cannot be easily tested as they
    // require interaction with User Defaults
}
