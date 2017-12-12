//
//  LMIGWebViewUIDelegate.swift
//  Liberty Mutual WKWebView plugin for Cordova
//
//  Copyright © 2016 Liberty Mutual. All rights reserved.
//

import WebKit
import UIKit

@objc(LMIGWebViewUIDelegate)
class LMIGWebViewUIDelegate : NSObject, WKUIDelegate {
    var title:String = ""
    init(title:String!) {
        super.init()
        if title != nil {
            self.title = title
        }
    }
    
    // Javascript alert
    func webView(_ webView:WKWebView, runJavaScriptAlertPanelWithMessage message:String, initiatedByFrame frame:WKFrameInfo, completionHandler: @escaping ()->Void) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)

        let ok = UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .default,
            handler:{
                (action:UIAlertAction!) in completionHandler()
                alert.dismiss(animated: true, completion:nil)
        }
        )

        alert.addAction(ok)

        if let rootController = UIApplication.shared.delegate?.window??.rootViewController {
            rootController.present(alert, animated:true, completion:nil)
        }
    }

    // Javascript confirm panel
    func webView(_ webView:WKWebView, runJavaScriptConfirmPanelWithMessage message:String, initiatedByFrame frame:WKFrameInfo, completionHandler: @escaping (Bool)->Void) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)

        let ok = UIAlertAction(
            title: "OK",
            style: .default,
            handler: {
                (action:UIAlertAction!) in completionHandler(true)
                alert.dismiss(animated: true, completion:nil)
        }
        )
        alert.addAction(ok)

        let cancel = UIAlertAction(
            title: "Cancel",
            style: .default,
            handler: {
                (action:UIAlertAction!) in completionHandler(false)
                alert.dismiss(animated: true, completion:nil)
        }
        )
        alert.addAction(cancel)

        if let rootController = UIApplication.shared.delegate?.window??.rootViewController {
            rootController.present(alert, animated:true, completion:nil)
        }
    }

    // Javascript text input prompt
    func webView(_ webView:WKWebView, runJavaScriptTextInputPanelWithPrompt prompt:String, defaultText:String?, initiatedByFrame frame:WKFrameInfo, completionHandler: @escaping (String?)->Void) {
        let alert:UIAlertController! = UIAlertController(title: prompt, message:"", preferredStyle:.alert)

        let ok = UIAlertAction(
            title: "OK",
            style: .default,
            handler: {
                (action:UIAlertAction!) in completionHandler((alert.textFields![0]).text)
                alert.dismiss(animated: true, completion:nil)
        }
        )
        alert.addAction(ok)

        let cancel = UIAlertAction(
            title: "Cancel",
            style: .default,
            handler: {
                (action:UIAlertAction!) in completionHandler(nil)
                alert.dismiss(animated: true, completion:nil)
        }
        )
        alert.addAction(cancel)

        alert.addTextField(configurationHandler: {
            (textField:UITextField!) in textField.text = defaultText
        })

        if let rootController = UIApplication.shared.delegate?.window??.rootViewController {
            rootController.present(alert, animated:true, completion:nil)
        }
    }

    // If we see a request to open a new window via target=_blank, extract the request
    // and load it within the same view
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
