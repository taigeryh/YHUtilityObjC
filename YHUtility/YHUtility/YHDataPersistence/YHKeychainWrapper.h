//
//  YHKeychainWrapper.h
//  YHUtility
//
//  Created by taiyh on 21/12/2017.
//  Copyright © 2017 taiyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>



/**
 用法：
 YHKeychainWrapper * wrapper = [[YHKeychainWrapper alloc] init];
 NSString * uuidin = [[NSUUID UUID] UUIDString];
 // 写入
 [wrapper mySetObject:uuidin forKey:(id)kSecValueData];
 // 读取
 NSString * uuidout = [wrapper myObjectForKey:(id)kSecValueData];

 // key:
 kSecAttrAccount , kSecValueData
 
 // 官方文档
 https://developer.apple.com/library/content/documentation/Security/Conceptual/keychainServConcepts/iPhoneTasks/iPhoneTasks.html#//apple_ref/doc/uid/TP30000897-CH208-SW3
 */
@interface YHKeychainWrapper : NSObject

- (void)mySetObject:(id)inObject forKey:(id)key;
- (id)myObjectForKey:(id)key;
- (void)resetKeychainItem;

@end
