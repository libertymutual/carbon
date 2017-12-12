package com.lmig.uscm.digital.appplatform.appmanager

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.support.v4.content.LocalBroadcastManager

/**
 * Navigation Manager
 *
 * Class representing the Navigation Manager
 *
 * @param [featureManager] An instance of a DSS [FeatureManager] component
 * @param [broadcastManager] An instance of a [LocalBroadcastManager]
 *
 * @property [navigationMessageReceiver] A [BroadcastReceiver] used for listening to app events
 */
class NavigationManager (val featureManager: FeatureManager, val broadcastManager: LocalBroadcastManager) {

    private val navigationMessageReceiver = object : BroadcastReceiver() {

        /**
         * Overridden implementation of the [BroadcastReceiver.onReceive] function
         *
         * Used to handle the receipt of app events
         *
         * @param [context] The application context
         * @param [intent] The [Intent] object sent by the broadcast
         */
        override fun onReceive(context: Context, intent: Intent) {
            // Get extra data included in the Intent
            val nav = intent.getSerializableExtra("nav") as Navigation
            navigate(nav = nav)
        }
    }

    /**
     * Initializes the Navigation Manager
     */
    init {
        broadcastManager.registerReceiver(navigationMessageReceiver,
                IntentFilter("NAVIGATE"))
        // TODO: Subscribe (And unsubscribe) to notification events here
    }

    /**
     * Starts the default feature
     */
    fun startDefaultFeature() {
        (featureManager.getDefaultFeature() as? Feature)?.let { feature ->
            featureManager.display(feature = feature)
        }
    }

    /**
     * Sends a broadcast message to initiate a navigation action
     *
     * @param [nav] A [Navigation] object representing the navigation options
     */
    fun goTo (nav: Navigation) {
        val intent = Intent("NAVIGATE")
        intent.putExtra("nav", nav)
        broadcastManager.sendBroadcast(intent)
    }

    /**
     * Navigates to a new [Feature]
     *
     * @param [nav] A [Navigation] object representing the navigation options
     */
    fun navigate (nav: Navigation) {
        (featureManager.getFeatureByName(name = nav.featureName) as? Feature)?.let { feature ->
            featureManager.updateFeature(feature = feature, nav = nav)
            featureManager.display(feature = feature)
        }
    }

    /**
     * Cleans up the NavigationManager after it has been destroyed
     *
     * In this case, we unregister the navigationMessageReceiver
     */
    fun finalize () {
        broadcastManager.unregisterReceiver(navigationMessageReceiver)
    }
}