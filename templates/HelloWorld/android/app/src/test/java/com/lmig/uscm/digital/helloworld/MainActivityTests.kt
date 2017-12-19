package com.lmig.uscm.digital.helloworld

import org.junit.After
import org.junit.Before
import org.junit.Test
import kotlin.test.assertTrue

/**
 * MainActivity Tests
 */
class MainActivityTests {

    @Before
    fun setUp() {
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        val ma = MainActivity()
        assertTrue(ma is MainActivity)
    }
}
