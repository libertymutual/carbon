package com.lmig.uscm.digital.appplatform.appmanager

import android.content.Intent
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.mock
import kotlin.test.assertEquals
import kotlin.test.assertTrue

/**
 * Feature Tests
 */
class FeatureTests {

    class FeatureTest : Feature {
        override val name = "Test"
        override var config: FeatureConfig? = mock(FeatureConfig::class.java)
        override val intent: Intent = mock(Intent::class.java)

        override fun setup() {}
    }

    @Before
    fun setUp() {
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testFeatureIsInterface() {
        val ft = FeatureTest()
        assertTrue(ft is Feature)
        assertEquals("Test", ft.name)
        assertTrue(ft.config is FeatureConfig)
        assertTrue(ft.intent is Intent)
    }
}