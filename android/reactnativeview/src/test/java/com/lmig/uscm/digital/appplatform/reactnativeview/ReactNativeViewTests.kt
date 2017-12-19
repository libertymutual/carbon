package com.lmig.uscm.digital.appplatform.reactnativeview

import org.junit.After
import org.junit.Before
import org.junit.Test
import kotlin.test.assertTrue

/**
 * ReactNativeView Tests
 */
class ReactNativeViewTests {

    private var rnv: ReactNativeView? = null

    @Before
    fun setUp() {
        rnv = ReactNativeView()
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        assertTrue(rnv is ReactNativeView)
    }
}