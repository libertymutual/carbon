package com.lmig.uscm.digital.appplatform.appmanager

import org.junit.After
import org.junit.Before
import org.junit.Test
import kotlin.test.assertNotNull

/**
 * Navigation Tests
 */
class NavigationTests {

    class NavTypeTest : NavType

    @Before
    fun setUp() {
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        val nav = Navigation(featureName = "TEST", data = NavTypeTest())
        assertNotNull(nav)
        assertNotNull(nav.featureName)
        assertNotNull(nav.featureName)

    }
}