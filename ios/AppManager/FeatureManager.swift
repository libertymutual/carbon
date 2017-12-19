//
//  ModuleManager.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

//// Manages all app features
open class FeatureManager {
    weak var appDelegate: UIApplicationDelegate?

    public var features: [Feature]
    public var defaultFeature: String
    public var currentFeatureName: String

    /**
     Initializer for app with multiple features
     
     - parameter features: Array of Features
     - parameter defaultFeature: Name of the feature that should be default
     */
    public init (features: [Feature], defaultFeature: String) {
        self.appDelegate = UIApplication.shared.delegate
        self.features = features
        self.defaultFeature = defaultFeature
        self.currentFeatureName = defaultFeature
    }

    /**
     Initializer for app with single feature
     
     - parameter feature: Single feature */
    public init (feature: Feature) {
        self.appDelegate = UIApplication.shared.delegate
        self.features = []
        self.features.append(feature)
        self.defaultFeature = feature.name
        self.currentFeatureName = feature.name
    }

    /**
     Updates feature with new navigational params
     
     - parameter feature: `Feature` to be updated
     - parameter nav: `Navigation` object used for updating Feature's view config
     */
    public func updateFeature(feature: Feature, nav: Navigation) {
        if feature.config?.viewConfig?.config is ReactNativeViewConfig {
            if var conf = feature.config?.viewConfig?.config as? ReactNativeViewConfig,
                let navData = nav.data as? ReactNav {
                conf.moduleName = navData.moduleName
                conf.initialProperties = navData.initialProperties
                conf.launchOptions = navData.launchOptions

                feature.config?.viewConfig?.config = conf
                feature.navigate()
            }
        }

        if feature.config?.viewConfig?.config is CordovaViewConfig {
            if var conf = feature.config?.viewConfig?.config as? CordovaViewConfig,
                let navData = nav.data as? CordovaNav {
                if let urlString = navData.url {
                    if let url = URL(string: urlString) {
                        conf.url = url
                        feature.config?.viewConfig?.config  = conf
                        feature.navigate()
                    }
                }
            }
        }
    }

    /**
     Takes the view controller from passed feature and displays it via app delegate
     
     - parameter feature: Feature to be displayed
     */
    public func display(feature: Feature) {
        self.appDelegate?.window??.rootViewController = feature.view?.viewController
        self.appDelegate?.window??.makeKeyAndVisible()
        self.currentFeatureName = feature.name
    }

    // TODO: Implement animation types
    public func displayWithAnimation(feature: Feature, animation: String?) {
        guard let window = self.appDelegate?.window else {
            return
        }

        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window!.rootViewController = feature.view?.viewController
        }, completion: { _ in })

        self.currentFeatureName = feature.name
    }

    /**
     Merges the `[FeatureConfig]` with the local instance
     
     - parameter featureConfig: [FeatureConfig] for merging
     */
    public func mergeConfig(featureConfig: [FeatureConfig]) {
        for feature in self.features where feature.config == nil {
            feature.config = featureConfig.first(where: { $0.name == feature.name })
        }
    }

    /**
     Setups the `ViewConfig` for all features. Uses the name to match the config.
     Initializes the `View` for the feature
     
     - parameter viewConfig: [ViewConfig] used for setting up to all views
     */
    public func setupViews(viewConfig: [ViewConfig]) {
        for feature in self.features {
            if let vc = feature.config?.viewConfig {
                if vc.config == nil {
                    feature.config?.viewConfig = viewConfig.first(where: { $0.name == feature.config?.name })
                }
            }

            do {
                try feature.setup()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    /**
     Gets the default `Feature` from the instance
     
     - returns: Feature if found
     */
    public func getDefaultFeature() -> Feature? {
        for feature in self.features where feature.name == self.defaultFeature {
            return feature
        }
        return nil
    }

    /**
     Gets the `Feature` for given name
     
     - parameter name: Feature name string
     - returns: Feature if found
     */
    public func getFeatureByName(name: String) -> Feature? {
        for feature in self.features where feature.name == name {
            return feature
        }
        return nil
    }
}
