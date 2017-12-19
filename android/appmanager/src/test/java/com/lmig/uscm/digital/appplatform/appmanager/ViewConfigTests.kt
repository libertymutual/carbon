package com.lmig.uscm.digital.appplatform.appmanager

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import org.junit.After
import org.junit.Before
import org.junit.Test
import java.lang.reflect.Type
import kotlin.test.assertEquals
import kotlin.test.assertTrue

/**
 * ViewConfig Tests
 */
class ViewConfigTests {

    private var viewConfig: ViewConfig? = null

    private val mockOptionsJson = "{\"name\":\"ReactNative\",\"config\":{\"moduleName\":\"TestModule\",\"initialProperties\":{\"initProp1\":\"initProp1Value\"},\"launchOptions\":{\"launchOption1\":\"launchOption1Value\"},\"bundleURL\":\"https://www.libertymutual.com\"}}"
    private val typeOfHashMap: Type = object : TypeToken<Map<String, Any>>() {}.type
    private val gson: Gson = GsonBuilder().serializeNulls().create()
    private val options: Map<String, Any> = gson.fromJson(mockOptionsJson, typeOfHashMap)

    @Before
    fun setUp() {
        viewConfig = ViewConfig(attributes = options)
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        viewConfig?.let {
            // Test Name is populated correctly
            assertEquals("ReactNative", it.name)

            // Test config has been populated correctly & is an instance of a ReactNativeViewConfig
            assertTrue(it.config is ReactNativeViewConfig)
        }
    }

    @Test
    fun testEquality() {
        val secondViewConfig = ViewConfig(attributes = options)
        assertEquals(secondViewConfig, viewConfig)

    }
}