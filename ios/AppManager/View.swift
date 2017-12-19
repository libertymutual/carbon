//
//  Module.swift
//  AppManager
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

/// View protocol - used to implement concrete views
public protocol View: class {
    var name: String { get set }
    // swiftlint:disable
    var viewController: UIViewController? { get set }

    init()

    func loadViewController(config: ViewConfig) -> UIViewController
}

/// Extension of the View protocol adds default implementation for all the views
extension View {

    /**
     Initialization method for View protocol
     
     - parameter name: Sets name to the instance
     - parameter config: Uses `ViewConfig` for view controller load

     */
    public init (config: ViewConfig) {
        self.init()

        self.viewController = self.loadViewController(config: config)
    }

}
