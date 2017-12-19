package com.lmig.uscm.digital.appplatform.appmanager

import java.io.Serializable

/**
 * Navigation
 *
 * Class representing a Navigation object
 *
 * @param [featureName] The name of the feature
 * @param [data] A [NavType] object representing the Navigation Type
 */
data class Navigation(val featureName: String, val data: NavType) : Serializable