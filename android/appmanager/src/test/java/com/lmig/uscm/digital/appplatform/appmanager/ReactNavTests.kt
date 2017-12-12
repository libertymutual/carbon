package com.lmig.uscm.digital.appplatform.appmanager

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import org.junit.After
import org.junit.Before
import org.junit.Test
import java.lang.reflect.Type
import kotlin.test.assertEquals

/**
 * ReactNav Tests
 */
class ReactNavTests {

    private var reactNav: ReactNav? = null

    private val mockOptionsJson = "{\"moduleName\":\"TestModule\",\"initialProperties\":{\"initProp1\":\"initProp1Value\"},\"launchOptions\":{\"launchOption1\":\"launchOption1Value\"}}"
    private val typeOfHashMap: Type = object : TypeToken<Map<String, Any>>() {}.type
    private val gson: Gson = GsonBuilder().serializeNulls().create()
    private val options: Map<String, Any> = gson.fromJson(mockOptionsJson, typeOfHashMap)

    @Before
    fun setUp() {
        reactNav = ReactNav(attributes = options)
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        reactNav?.let {
            // Test Module Name is populated correctly
            assertEquals("TestModule", it.moduleName)

            // Test initial properties have been populated correctly
            assertEquals("initProp1Value", it.initialProperties?.get("initProp1"))

            // Test launch options have been populated correctly
            assertEquals("launchOption1Value", it.launchOptions?.get("launchOption1"))
        }
    }

    @Test
    fun testEquality() {
        val secondReactNav = ReactNav(attributes = options)
        assertEquals(secondReactNav, reactNav)

    }
}