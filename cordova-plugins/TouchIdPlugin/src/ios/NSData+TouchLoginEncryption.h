//
//  NSData+TouchLoginEncryption.h
//  PersonalInsuranceSalesAndServiceApplicationIphone
//
//  Created on 9/23/15.
//
//

#import <Foundation/Foundation.h>

@interface NSData (TouchLoginEncryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
