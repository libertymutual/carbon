package com.lmig.uscm.digital.appplatform.appmanager

import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.*
import kotlin.test.assertTrue

/**
 * CommonEventManager Tests
 */
class CommonEventManagerTests {

    class CommonEventManagerTest : CommonEventManager {
        override val app: AppPlatformApplication = mock(AppPlatformApplication::class.java, RETURNS_DEEP_STUBS)
        init {
            `when`(app.appManager?.featureManager?.getFeatureByName(name = anyString())?.config?.viewConfig?.name).thenReturn("ReactNative")

            `when`(app.appManager?.navigationManager).thenReturn(mock(NavigationManager::class.java, RETURNS_DEEP_STUBS))
        }
    }

    var cem: CommonEventManager? = null

    @Before
    fun setUp() {
        cem = CommonEventManagerTest()
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testIsInterface() {
        assertTrue(cem is CommonEventManager)
    }

    @Test
    fun testNavigateFromReactNative() {
        val mockOptionsJson = "{\"moduleName\":\"DefaultModule\",\"initialProperties\":{\"hello\":\"world\"}}"
        val typeOfHashMap = object : TypeToken<Map<String, Any>>() {}.type
        val gson = GsonBuilder().serializeNulls().create()
        val options: Map<String, Any> = gson.fromJson(mockOptionsJson, typeOfHashMap)

        cem?.navigateFromReactNative(featureName = "Default", options = options)

        val reactNav = ReactNav(attributes = options)
        val mockNav = Navigation(featureName = "Default", data = reactNav)

        verify(cem?.app?.appManager?.navigationManager)?.navigate(nav = mockNav)
    }
}