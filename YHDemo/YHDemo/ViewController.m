//
//  ViewController.m
//  YHDemo
//
//  Created by taiyh on 2017/11/24.
//  Copyright © 2017年 taiyh. All rights reserved.
//

#import "ViewController.h"
#import <YHUtility/YHUtility.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

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
- (IBAction)store:(id)sender {
    YHKeychainWrapper * wrapper = [[YHKeychainWrapper alloc] init];
    NSString * uuid = [[NSUUID UUID] UUIDString];
    NSLog(@"store uuid:%@",uuid); //kSecAttrAccount
    [wrapper mySetObject:uuid forKey:(id)kSecValueData];
}

- (IBAction)get:(id)sender {
    YHKeychainWrapper * wrapper = [[YHKeychainWrapper alloc] init];
    NSString * uuid = [wrapper myObjectForKey:(id)kSecValueData];
    NSLog(@"get uuid:%@",uuid);

}

@end
