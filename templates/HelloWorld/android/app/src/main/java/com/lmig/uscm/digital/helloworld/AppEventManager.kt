package com.lmig.uscm.digital.helloworld

import com.lmig.uscm.digital.appplatform.appmanager.AppPlatformApplication
import com.lmig.uscm.digital.appplatform.appmanager.CommonEventManager

/**
 * App Event Manager
 *
 * This is the main application class used for orchestrating all other activities & components
 *
 * @param [app] A reference to the [MainApplication] as an [AppPlatformApplication]
 */
class AppEventManager(override val app: AppPlatformApplication) : CommonEventManager {

}