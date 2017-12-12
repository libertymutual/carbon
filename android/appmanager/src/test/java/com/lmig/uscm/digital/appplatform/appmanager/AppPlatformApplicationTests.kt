package com.lmig.uscm.digital.appplatform.appmanager

import android.content.pm.PackageManager
import android.content.res.AssetManager
import android.support.v4.content.LocalBroadcastManager
import com.lmig.uscm.digital.appplatform.AppPlatform
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.*
import kotlin.test.assertEquals
import kotlin.test.assertTrue

/**
 * AppPlatformApplication Tests
 */
class AppPlatformApplicationTests {

    var app : AppPlatformApplication? = null

    private val mockAppJson = "{\"name\":\"HelloWorld\",\"core\":[\"AppManager\",\"ViewManager\"],\"views\":[{\"name\":\"ReactNative\",\"config\":{\"bundleURL\":\"http://localhost:8081/index.ios.bundle?platform=ios\",\"moduleName\":\"HelloWorld\",\"initialProperties\":null,\"launchOptions\":null}}],\"features\":[{\"name\":\"Default\",\"config\":{\"theme\":\"light\"},\"viewConfig\":{\"name\":\"ReactNative\",\"config\":{\"bundleURL\":\"http://localhost:8081/index.ios.bundle?platform=ios\",\"moduleName\":\"DefaultModule\",\"initialProperties\":{\"hello\":\"I'm an initial property\"},\"launchOptions\":null}}},{\"name\":\"Second\",\"config\":{\"theme\":\"light\"},\"viewConfig\":{\"name\":\"ReactNative\",\"config\":{\"bundleURL\":\"http://localhost:8081/index.ios.bundle?platform=ios\",\"moduleName\":\"SecondModule\",\"initialProperties\":{\"hello\":\"I'm an initial property\"},\"launchOptions\":null}}}],\"platforms\":[]}"
    private val mockAppJsonInputStream = mockAppJson.byteInputStream()

    @Before
    fun setUp() {
        app = spy(AppPlatformApplication())
        app?.let {
            val mockAssetMan = mock(AssetManager::class.java)
            `when`(mockAssetMan.open("app.json")).thenReturn(mockAppJsonInputStream)
            doReturn(mockAssetMan).`when`(it).assets

            val mockBroadcastMan = mock(LocalBroadcastManager::class.java)
            doReturn(mockBroadcastMan).`when`(it).getBroadcastManager()

            val mockPackageMan: PackageManager = mock(PackageManager::class.java, RETURNS_DEEP_STUBS)
            doReturn(mockPackageMan).`when`(it).packageManager
        }
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        app?.let {
            assertEquals("app.json", it.appConfigFilename)
            assertEquals("Default", it.defaultFeature)
            assertTrue(it.appPlatform is AppPlatform)
            assertEquals(0, it.featuresList.size)
        }
    }

    @Test
    fun testInitializeAppPlatform() {
        app?.let {
            it.initializeAppPlatform()
            assertTrue(it.appConfig is AppConfig)
            assertTrue(it.appManager is AppManager)
        }

    }
}
