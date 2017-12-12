package com.lmig.uscm.digital.helloworld.features.defaultfeature

import android.content.Context
import android.content.Intent
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.*
import kotlin.test.assertEquals
import kotlin.test.assertTrue


/**
 * DefaultFeature Tests
 */
class DefaultFeatureTests {

    var feature: DefaultFeature? = null

    @Before
    fun setUp() {
        feature = DefaultFeature(config = null, context = mock(Context::class.java))
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        // Test Name is populated correctly
        assertEquals("Default", feature?.name)

        // Test Module Name is populated correctly
        assertEquals("DefaultModule", feature?.moduleName)

        // Test Intent is populated correctly
        assertTrue(feature?.intent is Intent)
    }

    @Test
    fun testSetup() {

        class MockIntent : Intent() {

            var flagsVal = 0
            var extrasVal = ""

            override fun setFlags(flags: Int): Intent {
                flagsVal = flags
                return mock(Intent::class.java)
            }

            override fun putExtra(name: String?, value: String?): Intent {
                extrasVal = value as String
                return mock(Intent::class.java)
            }

            override fun getFlags(): Int {
                return flagsVal
            }

            override fun getStringExtra(name: String?): String {
                return extrasVal
            }
        }

        val intent = spy(MockIntent::class.java)

        feature?.intent = intent

        feature?.setup()

        // Test moduleName StringExtra has been populated correctly on the Intent
        assertEquals("DefaultModule", intent?.getStringExtra("moduleName"))
    }
}
