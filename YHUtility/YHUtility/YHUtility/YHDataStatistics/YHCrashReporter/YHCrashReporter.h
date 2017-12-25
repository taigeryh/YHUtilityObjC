//
//  YHCrashReporter.h
//  YHUtility
//
//  Created by taiyh on 19/12/2017.
//  Copyright © 2017 taiyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHCrashReporter : NSObject


/**
 异常handler，
 使用方式，在程序启动时， NSSetUncaughtExceptionHandler(&yh_uncaughtExceptionHandler);

 @param exception exception
 */
void yh_uncaughtExceptionHandler(NSException *exception);


/**
 向服务器提交崩溃日志
 */
- (void)yh_report;

@end
