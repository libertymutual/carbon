//
//  LMIGWebViewCacheBearer.swift
//  
//
//  Created on 8/12/16.
//
//

/**
 
 WKWebViews can share caches across one or more webviews. This is carried out
 by multiple WKWebView instances sharing a single WKProcessPool. The class that
 initializes and holds the WKProcessPool is called the Cache Bearer. In a single
 application, one class will implement this protocol. Said class will hold the 
 cache, and _n_ WKWebViews will all access this common cache.
 
 */

import WebKit

@objc public protocol LMIGWebViewCacheBearer
{
    /**
 		Retrieve single instance of process pool to enable cache sharing
 	*/
    func getProcessPool() -> WKProcessPool?
}

