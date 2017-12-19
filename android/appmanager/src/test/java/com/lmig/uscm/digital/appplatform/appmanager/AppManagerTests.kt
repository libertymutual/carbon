package com.lmig.uscm.digital.appplatform.appmanager

import android.support.v4.content.LocalBroadcastManager
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.*
import kotlin.test.assertNotNull

/**
 * AppManager Tests
 */
class AppManagerTests {

    private var appMan: AppManager? = null

    @Before
    fun setUp() {
        val mockFeatureManager = mock(FeatureManager::class.java, RETURNS_DEEP_STUBS)
        `when`(mockFeatureManager.getDefaultFeature()).thenReturn(mock(Feature::class.java))
        val mockAppConfig = mock(AppConfig::class.java, RETURNS_DEEP_STUBS)
        val mockBroadcastManager = mock(LocalBroadcastManager::class.java)
        appMan = AppManager(featureManager = mockFeatureManager, config = mockAppConfig, broadcastManager = mockBroadcastManager)
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        assertNotNull(appMan?.navigationManager)
    }
}