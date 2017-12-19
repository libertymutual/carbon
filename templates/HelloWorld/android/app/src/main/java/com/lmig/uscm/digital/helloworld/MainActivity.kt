package com.lmig.uscm.digital.helloworld

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import com.lmig.uscm.digital.appplatform.appmanager.AppPlatformApplication

/**
 * Main Activity
 *
 * This is the default Activity loaded by the app. It has no purpose and is destroyed as soon
 * as it is created and a new Activity is launched by the [MainApplication] class
 */
class MainActivity : AppCompatActivity() {

    /**
     * Overridden implementation of the Android [AppCompatActivity.onCreate] function
     *
     * @param [savedInstanceState] The saved instance [Bundle]
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Launch the default feature
        // Note: This is done in this activity rather than in the MainApplication class so that the
        // default feature will be relaunched on AppResume
        (application as AppPlatformApplication).appManager?.navigationManager?.startDefaultFeature()

        // Close this launch activity as it serves no other purpose than launching the default feature
        finish()
    }
}
