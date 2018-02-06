//
//  YHMediator.h
//  YHUtility
//
//  Created by taiyh on 2017/11/24.
//  Copyright © 2017年 taiyh. All rights reserved.
//
/*
 简书
 http://www.jianshu.com/p/afb9b52143d4
 casa原文地址
 https://casatwy.com/iOS-Modulization.html
 https://casatwy.com/modulization_in_action.html
 */

#import <Foundation/Foundation.h>

@interface YHMediator : NSObject

/**
 返回单例
 */
@property (strong, readonly, class) YHMediator * sharedMediator;


/**
 外部URL调用

 @param URL URL（ aaa://targetA/actionB?id=1234）
 @param completion block
 @return return value
 */
- (id)yh_performActionWithURL:(NSURL *)URL completion:(void (^)(NSDictionary *))completion;


/**
 内部调用 target-action

 @param actionName actionName
 @param targetName targetName
 @param parameters parameters
 @param shouldCacheTarget shouldCacheTarget
 @return return value
 */
- (id)yh_performAction:(NSString *)actionName
              onTarget:(NSString *)targetName
            parameters:(NSDictionary *)parameters
     shouldCacheTarget:(BOOL)shouldCacheTarget;



/**
 释放缓存的 target

 @param targetName targetName
 */
- (void)releaseCachedTargetWithName:(NSString *)targetName;



@end
