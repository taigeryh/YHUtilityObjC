//
//  ViewController.m
//  YHDemo
//
//  Created by taiyh on 2017/11/24.
//  Copyright © 2017年 taiyh. All rights reserved.
//

#import "ViewController.h"
#import <YHUtility/YHUtility.h>
#import "YHMediator+Test.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"num:%f,str:%s",YHUtilityVersionNumber,YHUtilityVersionString);
    NSLog(@"NSHomeDirectory:%@",NSHomeDirectory());

    NSSetUncaughtExceptionHandler(&yh_uncaughtExceptionHandler);
    YHCrashReporter * reporter = [[YHCrashReporter alloc] init];
    [reporter report];

}
- (IBAction)clicked:(id)sender {
    NSArray * array = @[@"a",@"b"];
    NSLog(@"%@",array[2]);
    
    
    //常见异常1---不存在方法引用
    //    [self performSelector:@selector(thisMthodDoesNotExist) withObject:nil];
    
    //常见异常2---键值对引用nil
    //    [[NSMutableDictionary dictionary] setObject:nil forKey:@"nil"];
    
    //常见异常3---数组越界
    [[NSArray array] objectAtIndex:1];
    
    //常见异常4---memory warning 级别3以上
    //    [self performSelector:@selector(killMemory) withObject:nil];
    
    
}


- (void)tesss1 {
    
    UIViewController * vc = [YHMediator.sharedMediator viewControllerForTest];
    [self presentViewController:vc animated:YES completion:nil];
    
    NSString * getURL = @"http://test.rskj99.com/rskj-core-api/product/getProductList";
    
    YHSessionManager * manager = [[YHSessionManager alloc] init];
    //    [manager GET:getURL parameters:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSLog(@"get res - %@",responseObject);
    //    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"get err - %@",error);
    //    }];
    
    
    NSDictionary *parameters = @{
                                 @"mobilePhone" : @"18810287488",
                                 @"password" : @"q111111"
                                 };
    
    NSString * postString =  @"http://test.rskj99.com/rskj-core-api/member/login";
    
    [manager POST:postString parameters:parameters success:^(NSURLSessionTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"post res - %@",responseObject);
        
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post err - %@",error);
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
