//
//  YHURLSchemesCommunicationWrapper.h
//  YHUtility
//
//  Created by taiyh on 22/12/2017.
//  Copyright © 2017 taiyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString * _Nonnull const YHURLSchemesBuildInMail;


@interface YHURLSchemesCommunicationWrapper : NSObject

#pragma mark - built-in Apps
/*
 mailto:haorooms@126.com?cc=name2@rapidtables.com&bcc=name3@rapidtables.com
 &subject=The%20subject%20of%20the%20email
 &body=The%20body%20of%20the%20email
 */


/**
 使用系统邮件App发送邮件
 mailto:taiyuanhong@rskj99.com?cc=taiyuanhong@rskj99.com&bcc=taiyuanhong@rskj99.com&subject=主题&body=HelloWorld
 @param recipient 收件人数组
 @param cc 抄送人数组
 @param bcc 密送人数组
 @param subject 主题
 @param body 内容
 */
- (void)yh_mailto:(nullable NSArray<NSString *> *)recipient cc:(nullable NSArray<NSString *> *)cc bcc:(nullable NSArray<NSString *> *)bcc subject:(nullable NSString *)subject body:(nullable NSString *)body ;


/**
 电话App打电话
 tel:188😁7488
 iOS11 不会跳出应用
 @param tel 电话号码
 */
- (void)yh_tel:(nullable NSString *)tel;


/**
 FaceTime 视频
 facetime://14085551234
 facetime://user@example.com
 @param somebody 手机号或者邮箱
 */
- (void)yh_facetimeVideo:(nullable NSString *)somebody;


/**
 FaceTime 语音 iOS only
 facetime-audio://14085551234
 facetime-audio://user@example.com
 @param somebody 手机号或者邮箱
 */
- (void)yh_facetimeAudio:(nullable NSString *)somebody;


/**
 SMS 短信

 @param phone 手机号
 */
- (void)yh_sms:(nullable NSString *)phone API_AVAILABLE(ios(1.0));



#pragma mark - URLScheme Communication

/**
 打开scheme
 youyu://?key1=1&key2=98
 
 @param scheme scheme
 @param host 需要传参时，query，需要输入host不为空，
 @param query 参数列表
 */
- (void)yh_openScheme:(nonnull NSString *)scheme host:(nullable NSString *)host query:(nullable NSString *)query ;

@end
