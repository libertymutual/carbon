package com.lmig.uscm.digital.appplatform.appmanager

import org.junit.After
import org.junit.Before
import org.junit.Test
import kotlin.test.assertTrue

/**
 * NavType Tests
 */
class NavTypeTests {

    class NavTypeTest : NavType

    @Before
    fun setUp() {
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testIsInterface() {
        val nt = NavTypeTest()
        assertTrue(nt is NavType)
    }
}