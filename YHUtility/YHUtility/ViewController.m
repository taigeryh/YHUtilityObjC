//
//  ViewController.m
//  YHUtility
//
//  Created by taiyh on 25/12/2017.
//  Copyright © 2017 taiyh. All rights reserved.
//

#import "ViewController.h"
#import "YHUtility.h"

@interface ViewController ()

@end

@implementation ViewController


- (IBAction)btn1:(id)sender {
    YHURLSchemesCommunicationWrapper * wrapper = [[YHURLSchemesCommunicationWrapper alloc] init];
    // mailto
//    NSArray * reci = @[@"itut20@163.com",@"itut21@163.com"];
//    NSArray * cc = @[@"cc@rskj99.com",@"cc1@rskj99.com"];
////    NSArray *bcc = @[@"bcc@rskj99.com",@"bcc2@rskj99.com"];
//    NSString *subj = @"主题";
//    NSString *body = @"Hello World";
//    [wrapper yh_mailto:reci cc:nil bcc:nil subject:nil body:nil];
    // tel
//    [wrapper yh_tel:@"18810287488"];
    [wrapper yh_facetimeAudio:@"tai.yuanhong@etao.cn"];
}



@end
