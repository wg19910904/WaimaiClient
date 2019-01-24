//
//  EncryptionTools.h
//  JHCash
//
//  Created by ijianghu on 16/12/7.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

//
//  EncryptionTools.h
//

#import <Foundation/Foundation.h>

@interface EncryptionTools : NSObject

+ (instancetype)sharedEncryptionTools;

@property (nonatomic, assign) uint32_t algorithm;

- (NSString *)encryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv;

- (NSString *)decryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData *)iv;

@end
