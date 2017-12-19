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
 * FeatureConfig Tests
 */
class FeatureConfigTests {

    private var featureConfig: FeatureConfig? = null

    private val mockOptionsJson = "{\"name\":\"Test\",\"viewConfig\":{\"name\":\"Test\",\"config\":{\"name\":\"Test\"}},\"platform\":\"android\"}"
    private val typeOfHashMap: Type = object : TypeToken<Map<String, Any>>() {}.type
    private val gson: Gson = GsonBuilder().serializeNulls().create()
    private val options: Map<String, Any> = gson.fromJson(mockOptionsJson, typeOfHashMap)

    @Before
    fun setUp() {
        featureConfig = FeatureConfig(attributes = options)
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        featureConfig?.let {
            // Test Name is populated correctly
            assertEquals("Test", it.name)

            // Test viewConfig is populated correctly
            assertTrue(it.viewConfig is ViewConfig)

            // Test Platform is populated correctly
            assertEquals("android", it.platform)
        }
    }

    @Test
    fun testEquality() {
        val secondFeatureConfig = FeatureConfig(attributes = options)
        assertEquals(secondFeatureConfig, featureConfig)

    }
}