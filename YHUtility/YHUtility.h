//
//  YHUtility.h
//  YHUtility
//
//  Created by taiyh on 2017/11/24.
//  Copyright © 2017年 taiyh. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 以下两个版本号是一致的，再framework/Build Settings/Versioning/Current Project Version/设置 String,number只能有一个点.
 */
//! Project version number for YHUtility.
//FOUNDATION_EXPORT double YHUtilityVersionNumber;

//! Project version string for YHUtility.
//FOUNDATION_EXPORT const unsigned char YHUtilityVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <YHUtility/PublicHeader.h>

// 中间人模式
#import "YHMediator.h"
// networking
#import "YHSessionManager.h"
// 崩溃反馈
#import "YHCrashReporter.h"
// 设备信息
#import "YHDeviceReporter.h"
// 钥匙串访问
#import "YHKeychainWrapper.h"

// URL Scheme
#import "YHURLSchemesCommunicationWrapper.h"



