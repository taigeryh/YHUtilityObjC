//
//  YHMediator.m
//  YHUtility
//
//  Created by taiyh on 2017/11/24.
//  Copyright © 2017年 taiyh. All rights reserved.
//

#import "YHMediator.h"
#import <CoreGraphics/CGBase.h>
#import <objc/runtime.h>

static NSString * const YH_TARGET_PREFIX = @"Target_";
static NSString * const YH_ACTION_PREFIX = @"action_";

@interface YHMediator()
@property (strong, nonatomic) NSMutableDictionary *cachedTargets;
@end

@implementation YHMediator

static YHMediator *mediator;

+ (YHMediator *)sharedMediator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[YHMediator alloc] init];
    });
    return mediator;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSMutableDictionary *)cachedTargets {
    if (!_cachedTargets) {
        _cachedTargets = [[NSMutableDictionary alloc] init];
    }
    return _cachedTargets;
}


/*
 scheme://[target]/[action]?[params]
 
 url sample:
 aaa://targetA/actionB?id=1234
 */

- (id)yh_performActionWithURL:(NSURL *)URL completion:(void (^)(NSDictionary *))completion {
    NSMutableDictionary *parameters = @[].mutableCopy;
    NSString *parametersString = [URL query];
    for (NSString * parameter in [parametersString componentsSeparatedByString:@"&"]) {
        NSArray * element = [parameter componentsSeparatedByString:@"="];
        if (element.count < 2) {
            continue;
        }
        [parameters setObject:element.lastObject forKey:element.firstObject];
    }
    
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *actionName = [URL.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result= [self yh_performAction:actionName onTarget:URL.host parameters:parameters shouldCacheTarget:NO];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}


- (id)yh_performAction:(NSString *)actionName
              onTarget:(NSString *)targetName
            parameters:(NSDictionary *)parameters
     shouldCacheTarget:(BOOL)shouldCacheTarget
{
    NSString *targetClassString = [NSString stringWithFormat:@"%@%@",YH_TARGET_PREFIX,targetName];
    NSString *actionString = [NSString stringWithFormat:@"%@%@",YH_ACTION_PREFIX,actionName];
    Class targetClass;
    
    // 从缓存中读取 target
    NSObject *target = self.cachedTargets[targetClassString];
    if (nil == target) {
        targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }
    
    SEL action = NSSelectorFromString(actionString);
    
    if (nil == target) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedTargets[targetClassString] = target;
    }
    
    if ([target respondsToSelector:action]) {
        return [self yh_safelyPerformSelector:action onTarget:target withParameters:parameters];
    } else {
        // 有可能target是Swift对象
        actionString = [NSString stringWithFormat:@"action_%@WithParams:", actionName];
        action = NSSelectorFromString(actionString);
        if ([target respondsToSelector:action]) {
            return [self yh_safelyPerformSelector:action onTarget:target withParameters:parameters];
        } else {
            // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
            SEL action = NSSelectorFromString(@"notFound:");
            if ([target respondsToSelector:action]) {
                return [self yh_safelyPerformSelector:action onTarget:target withParameters:parameters];
            } else {
                // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
                [self.cachedTargets removeObjectForKey:targetClassString];
                
                return nil;

            }
        }
    }
    
}


/**
 对返回值增加判断

 @param aSelector SEL
 @param target target
 @param parameters 参数
 @return 调用的模块类
 */
- (id)yh_safelyPerformSelector:(SEL)aSelector onTarget:(NSObject *)target withParameters:(NSDictionary *)parameters {
    NSMethodSignature * methodSignature = [target methodSignatureForSelector:aSelector];
    if (nil == methodSignature) {
        return nil;
    }
    const char *methodReturnType = [methodSignature methodReturnType];
    
    if (0 == strcmp(methodReturnType, @encode(void))) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setSelector:aSelector];
        [invocation setTarget:target];
        [invocation setArgument:&parameters atIndex:2];
        [invocation invoke];
        return nil;
    }
    
    if (0 == strcmp(methodReturnType, @encode(NSInteger))) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setSelector:aSelector];
        [invocation setTarget:target];
        [invocation setArgument:&parameters atIndex:2];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (0 == strcmp(methodReturnType, @encode(NSUInteger))) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setSelector:aSelector];
        [invocation setTarget:target];
        [invocation setArgument:&parameters atIndex:2];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (0 == strcmp(methodReturnType, @encode(BOOL))) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setSelector:aSelector];
        [invocation setTarget:target];
        [invocation setArgument:&parameters atIndex:2];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (0 == strcmp(methodReturnType, @encode(CGFloat))) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setSelector:aSelector];
        [invocation setTarget:target];
        [invocation setArgument:&parameters atIndex:2];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    // 使用忽略警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:aSelector withObject:parameters];
#pragma clang diagnostic pop
    
}

- (void)releaseCachedTargetWithName:(NSString *)targetName {
    NSString *targetClassString = [NSString stringWithFormat:@"%@%@",YH_TARGET_PREFIX, targetName];
    [self.cachedTargets removeObjectForKey:targetClassString];
}


@end
