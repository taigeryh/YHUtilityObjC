//
//  Target_Test.m
//  YHDemo
//
//  Created by taiyh on 2017/11/25.
//  Copyright © 2017年 taiyh. All rights reserved.
//

#import "Target_Test.h"
#import "TestViewController.h"


@implementation Target_Test

- (TestViewController *)action_nativeFetchDetailViewController:(NSDictionary *)params {
    TestViewController *viewController = [[TestViewController alloc] init];
    NSLog(@"params:%@",params);
    return viewController;
}


@end
