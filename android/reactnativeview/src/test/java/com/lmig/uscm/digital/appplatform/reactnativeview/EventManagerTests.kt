package com.lmig.uscm.digital.appplatform.reactnativeview

import com.facebook.react.bridge.JavaOnlyMap
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.lmig.uscm.digital.appplatform.appmanager.CommonEventManager
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.*
import kotlin.test.assertEquals

/**
 * EventManager Tests
 */
class EventManagerTests {

    private var eventMan: EventManager? = null
    private var mockCommonEventMan: CommonEventManager? = null

    @Before
    fun setUp() {
        val mockReactAppContext = mock(ReactApplicationContext::class.java)
        mockCommonEventMan = mock(CommonEventManager::class.java, RETURNS_DEEP_STUBS)
        `when`(mockCommonEventMan?.app?.appConfig?.buildType).thenReturn("debug")
        mockCommonEventMan?.let { mockCommonEventMan ->
            eventMan = EventManager(reactContext = mockReactAppContext, eventMan = mockCommonEventMan)
        }
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testGetName() {
        assertEquals("EventManager", eventMan?.name)
    }

    @Test
    fun testNavigateFromReactNative() {
        val featureName = "TestFeatureName"
        val testMap = JavaOnlyMap()
        eventMan?.navigateFromReactNative(featureName = featureName, options = testMap)

        verify(mockCommonEventMan)?.navigateFromReactNative(featureName = anyString(), options = anyMap())
    }

    @Test
    fun testGetBuildType() {
        class TestPromise: Promise {
            override fun resolve(value: Any?) {
                val result = value as String
                result?.let{
                    assertEquals("debug", it)
                }
            }
            override fun reject(code: String?, message: String?) {}
            override fun reject(code: String?, e: Throwable?) {}
            override fun reject(code: String?, message: String?, e: Throwable?) {}
            override fun reject(message: String?) {}
            override fun reject(reason: Throwable?) {}

        }
        val testProm = TestPromise()
        eventMan?.getBuildType(promise = testProm)
    }
}