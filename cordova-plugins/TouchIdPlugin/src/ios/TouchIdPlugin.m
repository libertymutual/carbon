//
//  TouchIdPlugin.m
//  
//
//  Created on 4/9/15.
//
//

#import "TouchIdPlugin.h"
#import "A0SimpleKeychain.h"
#import "NSData+TouchLoginEncryption.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation TouchIdPlugin

- (void)pluginInitialize
{
    NSLog(@"TouchID plugin initialized");
}

/*
 Verify this device supports touch ID, and has a passcode and fingerprint setup already
 */
- (void)supportsTouchID:(CDVInvokedUrlCommand *)command
{
    if ([LAContext class] == NULL) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
        return;
    }
    
    [self.commandDelegate runInBackground:^{
        
        NSError *error = nil;
        LAContext *laContext = [[LAContext alloc] init];
        
        if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK]
                                        callbackId:command.callbackId];
        } else {
            NSArray *errorKeys = @[@"code", @"localizedDescription"];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:[error dictionaryWithValuesForKeys:errorKeys]]
                                        callbackId:command.callbackId];
        }
    }];
}

/* Attempt to load password from keychain */
- (void)getCredentialsFromKeychain:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        NSString *message = NSLocalizedString(@"Please use your fingerprint to login to eService.", @"Prompt TouchID message");
        A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
        NSError *error = nil;
        NSData *creds = [keychain dataForKey:@"eservice-creds" promptMessage:message error:&error];
        
        if(error){
            NSString *errorCode = [NSString stringWithFormat:@"%ld", (long)error.code];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorCode] callbackId:command.callbackId];
        }else if(creds){
            NSDictionary *credsDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:creds];
            
            NSData *username = credsDictionary[@"eservice-username"];
            NSData *password = credsDictionary[@"eservice-password"];
            NSString *key = credsDictionary[@"eservice-key"];
            //NSString *key = @"C5FB67144AE22538E7FE92A6DAD8E";
            
            NSData *decryptedUsername = [username AES256DecryptWithKey:key];
            NSData *decryptedPassword = [password AES256DecryptWithKey:key];
            
            NSString* unString = [[NSString alloc] initWithData:decryptedUsername encoding:NSUTF8StringEncoding];
            NSString* pwString = [[NSString alloc] initWithData:decryptedPassword encoding:NSUTF8StringEncoding];
            
            if(unString && pwString){
                NSDictionary *credentials = @{
                                              @"username" : unString,
                                              @"password" : pwString
                                              };
                
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:credentials] callbackId:command.callbackId];
            }else{
                //the credentails were unable to be decrypted properly.
                NSString *errorCode = [NSString stringWithFormat:@"%ld", (long)A0SimpleKeychainErrorDecode];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorCode] callbackId:command.callbackId];
            }
            
        }else {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
        }
    }];
}

/* Save Credentials to keychain */
- (void)setCredentialsInKeychain:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
        keychain.defaultAccessiblity = A0SimpleKeychainItemAccessibleWhenPasscodeSetThisDeviceOnly;
        keychain.useAccessControl = YES;
        
        NSData *plainUsername = [command.arguments[0][0] dataUsingEncoding:NSUTF8StringEncoding];
        NSData *plainPassword = [command.arguments[0][1] dataUsingEncoding:NSUTF8StringEncoding];
        
        // Create universally unique identifier (object)
        CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
        
        // Get the string representation of CFUUID object.
        NSString *key = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
        CFRelease(uuidObject);
        
        NSData *encodedUsername = [plainUsername AES256EncryptWithKey:key];
        NSData *encodedPassword = [plainPassword AES256EncryptWithKey:key];
        
        NSDictionary *creds = @{@"eservice-username":encodedUsername,@"eservice-password":encodedPassword, @"eservice-key":key};
        NSData *credsData = [NSKeyedArchiver archivedDataWithRootObject:creds];
        BOOL wasSuccessfull = [keychain setData:credsData forKey:@"eservice-creds"];
        if (wasSuccessfull) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
            
        }else{
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
        }
    }];
}

/* Delete Credentials from keychain (for failed login attempts) */
- (void)deleteCredentialsInKeychain:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        A0SimpleKeychain *keychain = [A0SimpleKeychain keychain];
        
        BOOL deleteSuccess = [keychain deleteEntryForKey:@"eservice-creds"];
        if(deleteSuccess){
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
        }else{
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
        }
    }];
}


@end
