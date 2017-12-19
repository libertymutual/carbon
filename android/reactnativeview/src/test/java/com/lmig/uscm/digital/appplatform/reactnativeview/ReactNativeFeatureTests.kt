package com.lmig.uscm.digital.appplatform.reactnativeview

import android.content.Context
import android.content.Intent
import com.lmig.uscm.digital.appplatform.appmanager.FeatureConfig
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.mock
import kotlin.test.assertTrue

/**
 * ReactNativeFeature Tests
 */
class ReactNativeFeatureTests {

    class ReactNativeFeatureTest : ReactNativeFeature {
        var setupCalled = false
        override val name = "TestRNFName"
        override val context: Context = mock(Context::class.java)
        override val moduleName = "TestRNFModuleName"
        override val intent: Intent = mock(Intent::class.java)

        override var config: FeatureConfig? = mock(FeatureConfig::class.java)

        override fun setup() {
            setupCalled = true
        }
    }

    var reactNativeFeature: ReactNativeFeatureTest? = null

    @Before
    fun setUp() {
        reactNativeFeature = ReactNativeFeatureTest()
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testIsInterface() {
        assertTrue(reactNativeFeature is ReactNativeFeatureTest)
    }

    @Test
    fun testSetup() {
        reactNativeFeature?.let { reactNativeFeature ->
            reactNativeFeature.setup()
            assertTrue(reactNativeFeature.setupCalled)
        }
    }
}