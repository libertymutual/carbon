//
//  NavigationManagerBridge.m
//  HelloWorld
//
//  Copyright © 2017 Liberty Mutual. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <React/RCTBridge.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>

@interface RCT_EXTERN_MODULE(EventManager, NSObject)

RCT_EXTERN_METHOD(navigateFromReactNative:(NSString *)name object:(NSDictionary *)object);

RCT_EXTERN_METHOD(getBuildType:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

@end

@interface RCT_EXTERN_MODULE(Auth, NSObject)

RCT_EXTERN_METHOD(configure:(NSString *)name
                  authURL:(NSString *)authURL
                  clientId:(NSString *)clientId
                  clientSecret:(NSString *)clientSecret
                  validatorId:(NSString *)validatorId
                  resolver:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(configureWithEnvironmentKey:(NSString *)key
                  resolver:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(login:(NSString *)username password:(NSString *)password
                  resolver:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(logout:(RCTPromiseResolveBlock) resolver
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(getExpiresIn:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(getAccessToken:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(getUsername:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(getEmail:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(isAuthenticated:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);
@end

@interface RCT_EXTERN_MODULE(Biometric, NSObject)

RCT_EXTERN_METHOD(saveCredentials:(NSString *)username password:(NSString *)password
                  resolver:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(getCredentials:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(deleteCredentials:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(isSupported:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(getBiometricType:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

RCT_EXTERN_METHOD(hasCredentials:(RCTPromiseResolveBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject);

@end
