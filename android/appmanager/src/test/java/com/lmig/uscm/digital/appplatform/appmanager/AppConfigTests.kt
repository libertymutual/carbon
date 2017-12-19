package com.lmig.uscm.digital.appplatform.appmanager

import android.content.Context
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.*
import kotlin.test.assertEquals

/**
 * AppConfig Tests
 */
class AppConfigTests {

    var config: AppConfig? = null

    private val mockContext: Context = mock(Context::class.java, RETURNS_DEEP_STUBS)

    private val mockAppJson = "{\"name\":\"HelloWorld\",\"core\":[\"AppManager\",\"ViewManager\"],\"views\":[{\"name\":\"ReactNative\",\"config\":{\"bundleURL\":\"http://localhost:8081/index.ios.bundle?platform=ios\",\"moduleName\":\"HelloWorld\",\"initialProperties\":null,\"launchOptions\":null}}],\"features\":[{\"name\":\"Default\",\"config\":{\"theme\":\"light\"},\"viewConfig\":{\"name\":\"ReactNative\",\"config\":{\"bundleURL\":\"http://localhost:8081/index.ios.bundle?platform=ios\",\"moduleName\":\"DefaultModule\",\"initialProperties\":{\"hello\":\"I'm an initial property\"},\"launchOptions\":null}}},{\"name\":\"Second\",\"config\":{\"theme\":\"light\"},\"viewConfig\":{\"name\":\"ReactNative\",\"config\":{\"bundleURL\":\"http://localhost:8081/index.ios.bundle?platform=ios\",\"moduleName\":\"SecondModule\",\"initialProperties\":{\"hello\":\"I'm an initial property\"},\"launchOptions\":null}}}],\"platforms\":[]}"
    private val mockAppJsonInputStream = mockAppJson.byteInputStream()

    @Before
    fun setUp() {
        `when`(mockContext.assets.open("app.json")).thenReturn(mockAppJsonInputStream)
        config = AppConfig(filename = "app.json", context = mockContext)
        mockAppJsonInputStream.reset()
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        config?.let {
            // Test Name is populated correctly
            assertEquals("HelloWorld", it.name)

            // Test App Version is populated correctly
            assertEquals("1.0.0", it.appVersion)

            // Test Build Number is populated correctly
            assertEquals(0, it.buildNumber)

            // Test Core Modules array is populated correctly
            assertEquals(2, it.core.size)

            // Test ViewConfig array is populated correctly
            assertEquals(1, it.views.size)

            // Test Features array is populated correctly
            assertEquals(2, it.features.size)

            // Test Platforms array is populated correctly
            assertEquals(0, it.platforms.size)

            // Test Build Type is populated correctly
            assertEquals(BuildConfig.BUILD_TYPE, it.buildType)
        }
    }

    @Test
    fun testEquality() {
        val secondConfig = AppConfig(filename = "app.json", context = mockContext)
        assertEquals(secondConfig, config)

    }
}
