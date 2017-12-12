package com.lmig.uscm.digital.appplatform.appmanager

import android.content.Context
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import com.lmig.uscm.digital.appplatform.appmanager.auth.network.AuthService

/**
 * App Config
 *
 * Class representing the Application Config
 *
 * @param [filename] The filename of the app config json file
 * @param [context] The current Android [Context]
 *
 * @property [name] The app name
 * @property [appVersion] The app version
 * @property [buildNumber] The build number
 * @property [core] A [MutableList] of [String] objects of core modules being used in the app
 * @property [views] A [MutableList] of [ViewConfig] objects being used in the app
 * @property [features] A [MutableList] of [FeatureConfig] objects being used in the app
 * @property [platforms] A [MutableList] of [PlatformConfig] objects being used in the app
 * @property [buildType] A [String] indicating the current Build Type (e.g. debug, qa, release)
 */
class AppConfig (filename: String, context: Context){

    val context: Context = context
    var name: String = ""
    val appVersion: String
    val buildNumber: Int
    var core: MutableList<String> = ArrayList()
    val views: MutableList<ViewConfig> = ArrayList()
    val features: MutableList<FeatureConfig> = ArrayList()
    val platforms: MutableList<PlatformConfig> = ArrayList()
    val buildType: String
        get() = BuildConfig.BUILD_TYPE

    /**
     * Initializes the App Config
     */
    init {
        val config = readAppConfig(filename = filename, context = context)

        config?.let {
            initData(config = it)
        }

        // Populate appVersion & buildNumber from the Android PackageManager
        val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)
        appVersion = if (packageInfo.versionName != null) packageInfo.versionName else "1.0.0"
        buildNumber = if (packageInfo.versionCode != null) packageInfo.versionCode else 1
    }

    /**
     * Takes the app config values read in from the json file and uses them to initialize
     * the various App Config components
     *
     * @param [config] A [Map] of <String, Any> objects representing the contents of the App Config json file
     */
    private fun initData(config: Map<String, Any>) {
        try {
            name = config.get(key = "name") as String

            core = config.get(key = "core") as ArrayList<String>

            val viewsArray = config.get(key = "views") as ArrayList<Any>
            initViews(viewsArray = viewsArray)

            val featuresArray = config.get(key = "features") as ArrayList<Any>
            initFeatures(featuresArray = featuresArray)

            //Initialize any app modules
            val modulesArray =  config.get(key = "modules") as List<Any>
            if (modulesArray != null) {
                initModules(modulesList = modulesArray)
            }

            //TODO: add platform
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
    }

    /**
     * Reads the contents of the App Config json file
     *
     * @param [filename] The filename of the app config json file
     * @param [context] The current Android [Context]
     *
     * @return A [Map] of <String, Any> objects representing the contents of the App Config json file
     */
    private fun readAppConfig(filename: String, context: Context): Map<String, Any>? {
        try {
            val content = context.assets.open(filename)
            val size = content.available()
            val buffer = ByteArray(size)
            content.read(buffer)
            content.close()
            val contentString = String(buffer, Charsets.UTF_8)

            val typeOfHashMap = object : TypeToken<Map<String, Any>>() {}.type
            val gson = GsonBuilder().serializeNulls().create()
            return gson.fromJson(contentString, typeOfHashMap)
        } catch (ex: Exception) {
            ex.printStackTrace()
        }

        return null
    }

    /**
     * Initializes a [MutableList] of [ViewConfig] objects from the app config json file
     *
     * @param [viewsArray] A [MutableList] of view objects being used in the app read from the app config json file
     */
    private fun initViews(viewsArray: MutableList<Any>) {
        viewsArray.mapTo(views) { ViewConfig(attributes = it as Map<String, Any>) }
    }

    /**
     * Initializes a [MutableList] of [FeatureConfig] objects from the app config json file
     *
     * @param [featuresArray] A [MutableList] of feature config objects being used in the app read from the app config json file
     */
    private fun initFeatures(featuresArray: MutableList<Any>) {
        featuresArray.mapTo(features) { FeatureConfig(attributes = it as Map<String, Any>) }
    }

    /**
     * Initializes any modules that are declared in the app config json file
     *
     * @param [modulesList] A [List] of modules being used in the app read from the app config json file
     */
    private fun initModules(modulesList: List<Any>) {
        for (module in modulesList) {
            val moduleMap = module as Map<String, Any>
            if (moduleMap["name"] == "Auth") {

                // TODO: This value should come from the app.json file or from the app's build configuration
                val configName = "DEV_A"

                val successCallback: () -> Unit = { }
                val errorCallback: (Throwable) -> Unit = { error ->
                    print("ERROR: " + error.localizedMessage)
                }

                AuthService.configureWithEnvironmentKey(environmentKey = configName, context = context, successCallback = successCallback, errorCallback = errorCallback)
            }
        }
    }

    /**
     * Overridden implementation of the equals function
     *
     * Used to test comparison of two [AppConfig] objects
     *
     * @param [other] The item to be tested for equality. Usually another [AppConfig] (but not necessarily)
     *
     * @return A [Boolean] indicating if the two [AppConfig] objects are equal
     */
    override fun equals(other: Any?): Boolean{
        if (this === other) return true
        if (other?.javaClass != javaClass) return false

        other as AppConfig

        //TODO: add platform
        return name == other.name && appVersion == other.appVersion && buildNumber == other.buildNumber && core == other.core && views == other.views && features == other.features && buildType == other.buildType
    }
}
