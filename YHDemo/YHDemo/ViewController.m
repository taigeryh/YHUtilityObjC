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


}
- (IBAction)clicked:(id)sender {
    UIViewController * vc = [YHMediator.sharedMediator viewControllerForTest];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
