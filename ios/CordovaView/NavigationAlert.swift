//
//  NavigationAlert.swift
//  AppPlatform
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

import UIKit

// TODO: Tech Debt - Rewrite as a native feature and exclude from the platform

/**
 Provides various alerts that need to be displayed based on navigation actions
 */
public class NavigationAlert {
    static let kNetworkAlertTitle = "No Internet Connection"
    static let kNetworkAlertMessage = "This action requires access to the internet. "
        + "Please verify your connection, and/or device settings."
    static let kExitAppTitle = "The selected link will exit the Liberty Mutual application. "
        + "Select \"Continue\" to proceed."

    public init() {}

    /**
     Display an alert to the user with an OK button and a message.
     The alert will dismiss when the user presses the OK button
     
     - parameter title: The title of the alert
     - parameter message: The message to display in the alert
     */
    public func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let ok = UIAlertAction(
            title: CordovaConstants.buttonOkLabel,
            style: .default,
            handler: { (_) in alert.dismiss(animated: true, completion:nil) }
        )
        alert.addAction(ok)

        // TODO: Refactor this so we are not grabbing the root VC. At a minimum we should just pass it in
        if let rootController = UIApplication.shared.delegate?.window??.rootViewController {
            rootController.present(alert, animated:true, completion:nil)
        }
    }

    /**
     Display a dialog box to the user with information about their lack of connectivity
     */
    public func displayNoNetworkConnectionAlert() {
        self.displayAlert(title: NavigationAlert.kNetworkAlertTitle, message: NavigationAlert.kNetworkAlertMessage)
    }

    /**
     Display a message stating that the user is going to exit the app. Displays an OK and Cancel button.
     If the user presses OK, the url is opened in
     the external browser. If they press Cancel, the alert is dismissed.
     
     - parameter exitUrl: the url to open in the external browser if the user presses the OK button
     */
    public func displayExitAlertForURL(exitUrl: URL) {

        let alert: UIAlertController! = UIAlertController(title: NavigationAlert.kExitAppTitle,
                                                          message: "", preferredStyle:.alert)

        let cancel = UIAlertAction(
            title: CordovaConstants.buttonCancelLabel,
            style: .default,
            handler: { (_:UIAlertAction!) in alert.dismiss(animated: true, completion:nil) }
        )
        alert.addAction(cancel)

        let ok = UIAlertAction(
            title: CordovaConstants.buttonContinueLabel,
            style: .default,
            handler: { (_:UIAlertAction!) in
                alert.dismiss(animated: true, completion:nil)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(exitUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(exitUrl)
                }
            }
        )
        alert.addAction(ok)

        if let rootController = UIApplication.shared.delegate?.window??.rootViewController {
            rootController.present(alert, animated:true, completion:nil)
        }
    }

    // Displays page load error alert
    public func displayErrorLoadingAlert() {
        self.displayAlert(title: "Page Load Error",
                          message: "Your request cannot be processed. "
                                 + "Please verify your connection, and/or device settings.")
    }
}
