//
//  YHMediator+Test.m
//  YHDemo
//
//  Created by taiyh on 2017/11/25.
//  Copyright © 2017年 taiyh. All rights reserved.
//

#import "YHMediator+Test.h"

@implementation YHMediator (Test)

- (UIViewController *)viewControllerForTest
{
    NSDictionary * dict = @{
                            @"key1":@"value",
                            @"key2":@(2),
                            };
    // nativeFetchDetailViewController:
    UIViewController *viewController = [self yh_performAction:@"nativeFetchDetailViewController:" onTarget:@"Test" parameters:dict shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

@end
