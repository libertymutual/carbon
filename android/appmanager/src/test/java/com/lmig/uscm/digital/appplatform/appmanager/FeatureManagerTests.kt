package com.lmig.uscm.digital.appplatform.appmanager

import android.content.Context
import android.content.Intent
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.*
import java.lang.reflect.Type
import kotlin.test.assertEquals
import kotlin.test.assertTrue

/**
 * FeatureManager Tests
 */
class FeatureManagerTests {

    private var featureMan: FeatureManager? = null

    var mockContext: Context? = null

    class FeatureTest : Feature {
        var setupCalled = false
        private val mockOptionsJson = "{\"name\":\"Default\",\"config\":{\"theme\":\"light\"},\"viewConfig\":{\"name\":\"ReactNative\",\"config\":{\"bundleURL\":\"http://localhost:8081/index.ios.bundle?platform=ios\",\"moduleName\":\"DefaultModule\",\"initialProperties\":{\"hello\":\"I'm an initial property\"},\"launchOptions\":null}}}"
        private val typeOfHashMap: Type = object : TypeToken<Map<String, Any>>() {}.type
        private val gson: Gson = GsonBuilder().serializeNulls().create()
        private val options: Map<String, Any> = gson.fromJson(mockOptionsJson, typeOfHashMap)

        override val name = "Test"
        override var config: FeatureConfig? = FeatureConfig(options)
        override val intent: Intent = mock(Intent::class.java)

        override fun setup() {
            setupCalled = true
        }
    }

    var feature: FeatureTest? = null

    @Before
    fun setUp() {
        mockContext = mock(Context::class.java, RETURNS_DEEP_STUBS)
        doNothing().`when`(mockContext)?.startActivity(any())
        feature = FeatureTest()
        feature?.let { feature ->
            mockContext?.let { mockContext ->
                featureMan = FeatureManager(features = arrayListOf(feature),defaultFeatureName = "Test", context = mockContext)
            }
        }
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        featureMan?.let { featureMan ->
            assertEquals(1, featureMan.features.size)
            assertEquals("Test", featureMan.defaultFeatureName)
            assertEquals("Test", featureMan.currentFeatureName)
            assertTrue(featureMan.context is Context)
        }
    }

    @Test
    fun testUpdateFeature() {
        featureMan?.let { featureMan ->
            feature?.let { feature ->
                val mockOptionsJson = "{\"moduleName\":\"NewNav\",\"initialProperties\":{\"initProp1\":\"initProp1NewValue\"},\"launchOptions\":{\"launchOption1\":\"launchOption1NewValue\"}}"
                val typeOfHashMap: Type = object : TypeToken<Map<String, Any>>() {}.type
                val gson: Gson = GsonBuilder().serializeNulls().create()
                val options: Map<String, Any> = gson.fromJson(mockOptionsJson, typeOfHashMap)
                val reactNav = ReactNav(attributes = options)
                val nav = Navigation(featureName = "TEST", data = reactNav)

                featureMan.updateFeature(feature = feature, nav = nav)

                val rnvc = feature.config?.viewConfig?.config as ReactNativeViewConfig

                // Test that a ReactNativeViewConfig was created
                assertTrue(feature.config?.viewConfig?.config is ReactNativeViewConfig)

                // Test that view config module name has been populated correctly
                assertEquals("NewNav", rnvc.moduleName)

                // Test that view config initial properties have been populated correctly
                assertEquals("initProp1NewValue", rnvc.initialProperties?.get("initProp1"))

                // Test that view config launch options have been populated correctly
                assertEquals("launchOption1NewValue", rnvc.launchOptions?.get("launchOption1"))

                // Test that the setup() function on the feature has been called
                assertTrue(feature.setupCalled)

            }
        }
    }

    @Test
    fun testDisplay() {
        featureMan?.let { featureMan ->
            feature?.let { feature ->
                featureMan.display(feature = feature)
            }
        }
        verify(mockContext)?.startActivity(any())
    }

    @Test
    fun testDisplayWithAnimation() {
        featureMan?.let { featureMan ->
            feature?.let { feature ->
                featureMan.displayWithAnimation(feature = feature, animation = "Test")
            }
        }
        verify(mockContext)?.startActivity(any())
    }

    @Test
    fun testMergeConfig() {
        featureMan?.let { featureMan ->
            val mockOptionsJson = "{\"name\":\"Test\",\"viewConfig\":{\"name\":\"Test\",\"config\":{\"name\":\"Test\"}}}"
            val typeOfHashMap: Type = object : TypeToken<Map<String, Any>>() {}.type
            val gson: Gson = GsonBuilder().serializeNulls().create()
            val options: Map<String, Any> = gson.fromJson(mockOptionsJson, typeOfHashMap)

            val featureConf = FeatureConfig(attributes = options)
            featureMan.mergeConfig(featureConfig = arrayListOf(featureConf))

            feature?.let { feature ->

                // Test the feature has been updated with the new feature config
                assertEquals(featureConf, feature.config)
            }
        }
    }

    @Test
    fun testSetupViews() {
        featureMan?.let { featureMan ->
            val mockOptionsJson = "{\"name\":\"Default\",\"config\":{\"moduleName\":\"TestModule\",\"initialProperties\":{\"initProp1\":\"initProp1Value\"},\"launchOptions\":{\"launchOption1\":\"launchOption1Value\"},\"bundleURL\":\"https://www.libertymutual.com\"}}"
            val typeOfHashMap: Type = object : TypeToken<Map<String, Any>>() {}.type
            val gson: Gson = GsonBuilder().serializeNulls().create()
            val options: Map<String, Any> = gson.fromJson(mockOptionsJson, typeOfHashMap)

            val viewConf = ViewConfig(attributes = options)
            featureMan.setupViews(viewConfig = arrayListOf(viewConf))

            feature?.let { feature ->
                // Test the feature has been updated with the new view config
                assertEquals(viewConf, feature.config?.viewConfig)
            }
        }
    }

    @Test
    fun testGetDefaultFeature() {
        featureMan?.let{
            assertEquals(feature, it.getDefaultFeature())
        }
    }

    @Test
    fun testGetFeatureByName() {
        featureMan?.let{
            assertEquals(feature, it.getFeatureByName(name = "Test"))
        }
    }
}