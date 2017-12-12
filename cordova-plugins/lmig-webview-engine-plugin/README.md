

Cordova WKWebView Engine - LMIG edition
======

**This plugin is made in Swift - work in progress. README will be updated.**


This plugin makes `Cordova` use the `WKWebView` component instead of the default `UIWebView` component, and is installable only on a system with the iOS 8.0 SDK and above. 

In iOS 9, Apple has fixed the [issue](http://www.openradar.me/18039024) present through iOS 8 where you cannot load locale files using file://, and must resort to using a local webserver. **However, you are still not able to use XHR from the file:// protocol without [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS) enabled on your server.**

Installation
-----------


Notes
------

On an iOS 8 system, Apache Cordova during runtime will switch to using the UIWebView engine instead of using this plugin. If you want to use WKWebView on both iOS 8 and iOS 9 platforms, you will have to resort to using a local webserver.

We have an [experimental plugin](https://github.com/apache/cordova-plugins/tree/master/wkwebview-engine-localhost) that does this. You would use that plugin instead of this one.

Application Transport Security (ATS) in iOS 9
-----------

The next released version of the [cordova-cli 5.4.0](https://www.npmjs.com/package/cordova) will support automatic conversion of the [&lt;access&gt;](http://cordova.apache.org/docs/en/edge/guide/appdev/whitelist/index.html) tags in config.xml to Application Transport Security [ATS](https://developer.apple.com/library/prerelease/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33) directives. Upgrade to the version 5.4.0 to use this new functionality.

Limitations
--------

If you are upgrading from UIWebView, please note the limitations of using WKWebView as outlined in our [issue tracker](https://issues.apache.org/jira/issues/?jql=project%20%3D%20CB%20AND%20labels%20%3D%20wkwebview-known-issues).

Apple Issues
-------

The `AllowInlineMediaPlayback` preference will not work because of this [Apple bug](http://openradar.appspot.com/radar?id=6673091526656000). 

Permissions
-----------

#### config.xml

        <feature name="CDVWKWebViewEngine">
            <param name="ios-package" value="CDVWKWebViewEngine" />
        </feature>

        <preference name="CordovaWebViewEngine" value="CDVWKWebViewEngine" />

Supported Platforms
-------------------

- iOS
