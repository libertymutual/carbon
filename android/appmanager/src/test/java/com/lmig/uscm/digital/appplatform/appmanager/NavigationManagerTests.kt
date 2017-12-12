package com.lmig.uscm.digital.appplatform.appmanager

import android.content.Intent
import android.support.v4.content.LocalBroadcastManager
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.ArgumentMatchers
import org.mockito.Mockito.*
import kotlin.test.assertTrue

/**
 * NavigationManager Tests
 */
class NavigationManagerTests {

    private var navMan: NavigationManager? = null

    private val mockFeature: Feature = mock(Feature::class.java)
    private val mockFeatureManager: FeatureManager = mock(FeatureManager::class.java)
    private val mockBroadcastManager: LocalBroadcastManager = mock(LocalBroadcastManager::class.java)
    private val mockNav: Navigation = mock(Navigation::class.java)

    @Before
    fun setUp() {
        `when`(mockNav.featureName).thenReturn("Test")
        `when`(mockFeatureManager.getDefaultFeature()).thenReturn(mockFeature)
        `when`(mockFeatureManager.getFeatureByName(name = ArgumentMatchers.anyString())).thenReturn(mockFeature)
        navMan = NavigationManager(featureManager = mockFeatureManager, broadcastManager = mockBroadcastManager)
    }

    @After
    fun tearDown() {
    }

    @Test
    fun testInit() {
        navMan?.let {
            assertTrue(it.featureManager is FeatureManager)
            assertTrue(it.broadcastManager is LocalBroadcastManager)
        }
    }

    @Test
    fun testStartDefaultFeature() {
        navMan?.let {
            it.startDefaultFeature()

            verify(mockFeatureManager).display(feature = mockFeature)
        }
    }

    @Test
    fun testGoTo() {
        navMan?.let {
            it.goTo(mock(Navigation::class.java))
            verify(mockBroadcastManager).sendBroadcast(any(Intent::class.java))
        }
    }

    @Test
    fun testNavigate() {
        navMan?.let {
            it.navigate(mockNav)

            verify(mockFeatureManager).updateFeature(feature = mockFeature, nav = mockNav)

            verify(mockFeatureManager).display(feature = mockFeature)
        }
    }
}