//
//  TouchIdPlugin.h
//  
//
//  Created on 4/9/15.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "NSData+TouchLoginEncryption.h"
#import "A0SimpleKeychain.h"


@interface TouchIdPlugin : CDVPlugin

@property A0SimpleKeychain *keychain;

- (void)supportsTouchID:(CDVInvokedUrlCommand *)command;
- (void)getCredentialsFromKeychain:(CDVInvokedUrlCommand *)command;
- (void)setCredentialsInKeychain:(CDVInvokedUrlCommand *)command;
- (void)deleteCredentialsInKeychain:(CDVInvokedUrlCommand *)command;

@end
