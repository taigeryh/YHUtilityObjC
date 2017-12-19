//
//  YHCrashReporter.m
//  YHUtility
//
//  Created by taiyh on 19/12/2017.
//  Copyright © 2017 taiyh. All rights reserved.
//

#import "YHCrashReporter.h"

static NSString * const yhCrashFileName = @"yh_crash.log";

@implementation YHCrashReporter

/*
 exception: name,reason, infoDict,callStackSymbols,callStackReturnAddresses
 App: name, bundle Id, version, build,
 时间：
 */


void yh_uncaughtExceptionHandler(NSException *exception) {
    
    NSTimeInterval now = ([[NSDate date] timeIntervalSince1970])*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", now];
    
    NSLog(@"%@",NSHomeDirectory());
    NSString *appDesc = [[[NSBundle mainBundle] infoDictionary] description];
    /*
    // CFBundleIdentifier
    NSString *bundleIdentifier = infoDictionary[@"CFBundleIdentifier"];
    // BuildMachineOSBuild
    NSString *BuildMachineOSBuild = infoDictionary[@"BuildMachineOSBuild"];
    // CFBundleDevelopmentRegion
    NSString *CFBundleDevelopmentRegion = infoDictionary[@"CFBundleDevelopmentRegion"];
    // CFBundleName当前应用名称
    NSString *CFBundleName = infoDictionary[@"CFBundleName"];
    // CFBundleNumericVersion
    NSString *CFBundleNumericVersion = infoDictionary[@"CFBundleNumericVersion"];
    // CFBundlePackageType
    NSString *CFBundlePackageType = infoDictionary[@"CFBundlePackageType"];
    // CFBundleShortVersionString
    NSString *CFBundleShortVersionString = infoDictionary[@"CFBundleShortVersionString"];
    // CFBundleVersion
    NSString *CFBundleVersion = infoDictionary[@"CFBundleVersion"];
    
    // DTCompiler
    NSString *DTCompiler = infoDictionary[@"DTCompiler"];
    // DTPlatformBuild
    NSString *DTPlatformBuild = infoDictionary[@"DTPlatformBuild"];
    // DTPlatformName
    NSString *DTPlatformName = infoDictionary[@"DTPlatformName"];
    // DTPlatformVersion
    NSString *DTPlatformVersion = infoDictionary[@"DTPlatformVersion"];
    // DTSDKBuild
    NSString *DTSDKBuild = infoDictionary[@"DTSDKBuild"];
    // DTSDKName
    NSString *DTSDKName = infoDictionary[@"DTSDKName"];
    // DTXcode
    NSString *DTXcode = infoDictionary[@"DTXcode"];
    // DTXcodeBuild
    NSString *DTXcodeBuild = infoDictionary[@"DTXcodeBuild"];
    // LSRequiresIPhoneOS
    NSString *LSRequiresIPhoneOS = infoDictionary[@"LSRequiresIPhoneOS"];
    // MinimumOSVersion
    NSString *MinimumOSVersion = infoDictionary[@"MinimumOSVersion"];
    
   */
    
    // 异常名称
    NSString *name = [exception name];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // Info
    NSDictionary *info = [exception userInfo];
    // 异常的堆栈信息 callStackSymbols
    NSArray *callStackSymbols = [exception callStackSymbols];
    // callStackReturnAddresses
    NSArray *callStackReturnAddresses = [exception callStackReturnAddresses];

    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception name:%@\nException reason:%@\nException userInfo:%@\nException callStackSymbols:%@\nException callStackReturnAddress:%@",name, reason, info,callStackSymbols,callStackReturnAddresses];
    
    NSString *log = [NSString stringWithFormat:@"timestamp:%@\n%@\n%@",timestamp,appDesc,exceptionInfo];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [docDir stringByAppendingPathComponent:yhCrashFileName];
    //保存到本地  --  当然你可以在下次启动的时候，上传这个log
    [log writeToFile:path  atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


- (void)yh_report {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [docDir stringByAppendingPathComponent:yhCrashFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = nil;
        NSString *log = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (!error && log) {
            //
            //1.创建会话对象
            NSURLSession *session = [NSURLSession sharedSession];
            //2.根据会话对象创建task
            NSURL *url = [NSURL URLWithString:@"http://10.2.11.240:3000/test/post"];
            //3.创建可变的请求对象
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            //4.修改请求方法为POST
            request.HTTPMethod = @"POST";
            //5.设置请求体
            request.HTTPBody = [log dataUsingEncoding:NSUTF8StringEncoding];
            //6.根据会话对象创建一个Task(发送请求）
            /*
                    第一个参数：请求对象
                    第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
                    data：响应体信息（期望的数据）
                    response：响应头信息，主要是对服务器端的描述
                    error：错误信息，如果请求失败，则error有值
             */
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
               //8.解析数据
               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    NSLog(@"%@",dict);
            }];
            //7.执行任务
            [dataTask resume];
        }
    }
}


@end
