////
////  ModalWebViewController.swift
////  AppPlatform
////
////  Created by Biscan, Tomislav on 9/11/17.
////  Copyright © 2017 Liberty Mutual. All rights reserved.
////
//
////
////  ModalWebViewController.swift
////
////  Created by Rob Reinold on 5/23/16.
////
////  This class handles displaying a modal web view inside the LM Mobile App. 
////  The eService web server contains certain links
////  that are designed to be opened in a web browser inside the LM Mobile App.
////
////  We internally classify different links using the enum PolicyResponse. When a link is classified as
////  a `PolicyResponse.GO_TO_EXTERNAL_URL_IN_MODAL` link, this class is used to display the webpage.
////
////  Note: This class is instantiated by its Storyboard ID: "ModalWebViewController"
//
//import Foundation
//import WebKit
//import UIKit
//import XCGLogger
//
//// TODO ImplementProtocol(s): UIDocumentInteractionControllerDelegate
//class ModalWebViewController: UIViewController, WKNavigationDelegate, UIWebViewDelegate {
//
//    private let kLogger = XCGLogger.default
//
//    /// The WKWebView object handling our web browser functionality
//    var webView: WKWebView?
//
//    /** Displays the HTML Header
//     Note: WKWebView (unlike UIWebView) autoscales pages. In order to
//     display this header properly, we need to disable autoscaling.
//     This is achieved by adding the following HTML to WebViewHeader.html
//     <meta name="viewport" content="initial-scale=1.0" />
//     This addition has been added, and does not affect previous UIWebView behavior
//     */
//    private var headerView: WKWebView?
//
//    /// The single URL that represents the request made by this web browser
//    var url: URL?
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//    }
//
//    /**
//     
//     Create and load our Header View, and our Web View
//     
//     */
//    override func loadView() {
//        super.loadView()
//
//        let webViewFrame = getDefaultWebViewFrame(parentBounds: view.frame)
//        webView = WKWebView(frame: webViewFrame)
//
//        let headerFrame = getDefaultHeaderViewFrame(parentBounds: view.frame)
//        headerView = WKWebView.init(frame: headerFrame)
//
//        guard let webView = webView, let headerView = headerView else {
//            kLogger.error("WebView or HeaderView not set properly. Unable to load URL requests")
//            return
//        }
//
//        view.addSubview(webView)
//        view.addSubview(headerView)
//
//    }
//
//    /**
//     
//     Load our URL Request here
//     
//     */
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        guard let url = url, let webView = webView else {
//            kLogger.error("URL or Webview not set before initializing ModalWebViewController")
//            return
//        }
//
//        kLogger.info("ModalWebViewController is loading URL: \(url)")
//
//        let req = URLRequest(url: url)
//        webView.load(req)
//
//        loadHeader()
//
//    }
//
//    /**
//     
//     A rotation occurred, let's adjust the width of our webView
//     
//     */
//
//    override func viewWillLayoutSubviews() {
//
//        guard let webView = webView else {
//            return
//        }
//
//        webView.frame = getDefaultWebViewFrame(parentBounds: view.frame)
//
//    }
//
//    /**
//     
//     Loads the Header's HTML File from disk
//     
//     */
//
//    func loadHeader() {
//        guard let headerView = headerView else {
//            kLogger.error("Header View not set up properly, cannot load header resources")
//            return
//        }
//
//        let htmlFileType = "html"
//        let headerURL = CordovaConstants.webServerRoot
//                        + NavigationConstants.LOCALHTMLHEADERRESOURCE + "." + htmlFileType
//        let localRequest = URLRequest(url: URL.init(string: headerURL)!)
//
//        headerView.autoresizingMask = [.flexibleWidth, .flexibleRightMargin]
//        headerView.scrollView.isScrollEnabled = false
//        headerView.navigationDelegate = self
//        headerView.load(localRequest)
//    }
//
//    /**
//     
//     Set default values for our Web View inside a given View
//     
//     - parameter parentBounds: View in which to fit the Web View
//     
//     - returns: Newly Created Web View Frame
//     
//     */
//    func getDefaultWebViewFrame(parentBounds: CGRect) -> CGRect {
//        let height = parentBounds.size.height - CGFloat(NavigationConstants.LMHEADERWEBVIEWHEIGHT)
//        let width = parentBounds.size.width
//        let xCoordinate = CGFloat(0)
//        let yCoordinate = CGFloat(NavigationConstants.LMHEADERWEBVIEWHEIGHT)
//        return CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
//    }
//
//    /**
//     
//     Set default values for our Header View inside a given View
//     
//     - parameter parentBounds: View in which to fit the Header View
//     
//     - returns: Newly Created Header View Frame
//     
//     */
//    func getDefaultHeaderViewFrame(parentBounds: CGRect) -> CGRect {
//        let height = CGFloat(NavigationConstants.LMHEADERWEBVIEWHEIGHT)
//        let width = parentBounds.size.width
//        let xCoordinate = CGFloat(0)
//        let yCoordinate = CGFloat(0)
//        return CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
//    }
//
//    /**
//     
//     Close / Dismiss this Modal View Controller
//     
//     */
//    func close() {
//        dismiss(animated: true, completion: {})
//    }
//
//    /**
//     
//     Move our views vertically, depending upon presence of status bar
//     
//     see #shiftViewsVertically method documentation for details
//     
//     */
//    override func viewDidLayoutSubviews() {
//        //Shift the header down if the status bar is displayed
//        let shiftFromStatusBar: CGFloat = 20
//        let noStatusBar: CGFloat = 0
//
//        let orientation = UIApplication.shared.statusBarOrientation
//        if UIInterfaceOrientationIsPortrait(orientation) {
//            shiftViewsVertically(verticalMovement: shiftFromStatusBar)
//        } else {
//            shiftViewsVertically(verticalMovement: noStatusBar)
//        }
//    }
//
//    /**
//     Shift both headerView and webView up or down
//     to account for presence of status bar.
//     
//     iPhones (Portrait) - Status Bar is present
//     (Landscape) - Status Bar is NOT present
//     
//     iPads     (Portrait) - Status bar is present
//     (Landscape) Status bar is present **
//     
//     ** Production LM App attempts to hide status bar on
//     ALL Landscape orientations, but LandScape iPad
//     Status bar should not be covered.
//     
//     However, iPads do present the status bar on landscape.
//     
//     Will use one of two values
//     >1. 0 - When we want views at their natural y positions
//     >2. 20 - When we want views to shift downwards by 20 to
//     make space for Status Bar
//     
//     - parameter verticalMovement: Number of units to shift views
//     */
//    func shiftViewsVertically(verticalMovement: CGFloat) {
//
//        guard let headerView = headerView, let webView = webView else {
//            return
//        }
//        var bounds: CGRect
//
//        bounds = headerView.bounds
//        bounds.origin.y = verticalMovement
//        headerView.frame = bounds
//
//        bounds = webView.bounds
//        bounds.origin.y = CGFloat(NavigationConstants.LMHEADERWEBVIEWHEIGHT) + verticalMovement
//        webView.frame = bounds
//
//    }
//
//    /**
//     
//     Close up all resources
//     
//     */
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        webView?.stopLoading()
//    }
//
//    // MARK: - WKNavigationDelegate Methods
//
//    /**
//     
//     Handle behavior of this view controller based upon the URL type we are navigating to
//     Ex. #Close upon receiving a `libertymutualmobile://close` URL
//     
//     */
//
//    func webView(_ webView: WKWebView,
//                 decidePolicyFor navigationAction: WKNavigationAction,
//                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        guard let url = navigationAction.request.url else {
//            kLogger.error("Invalid Navigation Request, Unable to obtain URL")
//            return
//        }
//
//        let response = NavigationPolicy.handleModalHttp(url: url)
//
//        // Custom logic based upon response will be kept below
//        switch response {
//        // The only command we support currently is close
//        case .closeModal:
//            close()
//            break
//        default:
//            // No other response requires action
//            break
//        }
//
//        decisionHandler(WKNavigationActionPolicy.allow)
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//
//        if isViewLoaded {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        }
//
//    }
//
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        if isViewLoaded {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }
//    }
//
//    /// TODO Implement UIDocumentInteractionControllerDelegate
//    //    var shouldShowPrintButton : Bool?
//    //    var printButtonView : UIWebView?
//    //    var localDocumentURL : NSURL?
//    //    var urlRequestForDocument : NSURLRequest?
//    //    var UIDocumentInteractionController : UIDocumentInteractionController
//    //    func showPrintDocumentDialogue(){
//    //
//    //    }
//
//    // TODO Have not seen a use case for this
//    //
//    // Contains chained requests, for redirects
//    // var urlsUsedToFulfillRequest : [NSURL]?
//
//}
