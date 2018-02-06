//
//  YHSessionManager.h
//  YHUtility
//
//  Created by taiyh on 2017/12/5.
//  Copyright © 2017年 taiyh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHSessionManager : NSObject

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)sessionConfiguration NS_DESIGNATED_INITIALIZER;


//- (nullable NSURLSessionTask *)GET:(NSString *)URLString
//                        parameters:(nullable NSDictionary *)parameters
//                           success:(nullable void (^)(NSURLSessionTask *task, id _Nullable responseObject))success
//                           failure:(nullable void (^)(NSURLSessionTask * _Nullable task, NSError *error))failure;


- (nullable NSURLSessionTask *)POST:(NSString *)URLString
                         parameters:(nullable NSDictionary *)parameters
                            success:(nullable void (^)(NSURLSessionTask *task, id _Nullable responseObject))success
                            failure:(nullable void (^)(NSURLSessionTask * _Nullable task, NSError *error))failure;


NS_ASSUME_NONNULL_END

@end
