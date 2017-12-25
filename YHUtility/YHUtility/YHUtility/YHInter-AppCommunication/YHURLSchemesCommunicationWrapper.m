//
//  YHURLSchemesCommunicationWrapper.m
//  YHUtility
//
//  Created by taiyh on 22/12/2017.
//  Copyright © 2017 taiyh. All rights reserved.
//

#import "YHURLSchemesCommunicationWrapper.h"

NSString * const YHURLSchemesBuildInMail = @"mailto";
NSString * const YHURLSchemesBuildInTel = @"tel";
NSString * const YHURLSchemesBuildInFaceTimeVideo = @"facetime";
NSString * const YHURLSchemesBuildInFaceTimeAudio = @"facetime-audio";
NSString * const YHURLSchemesBuildInSMS = @"sms";


@interface YHURLSchemesCommunicationWrapper()

@property (nonatomic, strong) NSSet *noSlashSchemes;

@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *query;

@end


@implementation YHURLSchemesCommunicationWrapper

- (NSSet *)noSlashSchemes {
    if (!_noSlashSchemes) {
        _noSlashSchemes = [NSSet setWithObjects:YHURLSchemesBuildInMail,YHURLSchemesBuildInTel,YHURLSchemesBuildInSMS, nil];
    }
    return _noSlashSchemes;
}

- (void)yh_openScheme:(NSString *)scheme {
    [self yh_openScheme:scheme host:nil path:nil query:nil];
}

- (void)yh_openScheme:(NSString *)scheme host:(NSString *)host {
    [self yh_openScheme:scheme host:host path:nil query:nil];
}

- (void)yh_openScheme:(NSString *)scheme host:(NSString *)host query:(NSString *)query {
    [self yh_openScheme:scheme host:host path:nil query:query];
}

- (void)yh_openScheme:(NSString *)scheme host:(NSString *)host path:(NSString *)path {
    [self yh_openScheme:scheme host:host path:path query:nil];
}

- (void)yh_openScheme:(NSString *)scheme host:(NSString *)host path:(NSString *)path query:(NSString *)query {
    NSAssert(scheme, @"scheme can not be nil");
    self.scheme = scheme;
    self.host = host;
    self.path = path;
    self.query = query;
    NSString *slash = [self.noSlashSchemes containsObject:self.scheme] ? @"" : @"//";
    NSMutableString *url = [NSMutableString stringWithString:self.scheme];
    [url appendString:@":"];
    [url appendString:slash];
    if (self.host) {
        [url appendString:self.host];
        if (self.path) {
            [url appendString:@"/"];
            [url appendString:self.path];
        }
        if (self.query) {
            [url appendString:@"?"];
            [url appendString:self.query];
        }
    }
    NSLog(@"url:%@",url);
    // stringByAddingPercentEscapesUsingEncoding  iOS9 废弃
//    NSString *urlAddedPercentEscapes = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlAddedPercentEscapes = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *resultURL = [NSURL URLWithString:urlAddedPercentEscapes];
    
    if ([[UIApplication sharedApplication] canOpenURL:resultURL]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:resultURL options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:resultURL];
        }
    }

}


#pragma mark - built-in Apps

- (void)yh_mailto:(NSArray<NSString *> *)recipient cc:(nullable NSArray<NSString *> *)cc bcc:(nullable NSArray<NSString *> *)bcc subject:(nullable NSString *)subject body:(nullable NSString *)body  {
    NSAssert(recipient.count >= 1, @"收件人不能为空");
    NSString * recipientStr = [recipient componentsJoinedByString:@","]; // path
    NSString * ccStr = nil;
    if (cc.count >= 1) {
        ccStr = [cc componentsJoinedByString:@","];
        ccStr = [@"cc=" stringByAppendingString:ccStr];
    }
    NSString * bccStr = nil;
    if (bcc.count >= 1) {
        bccStr = [bcc componentsJoinedByString:@","];
        bccStr = [@"bcc=" stringByAppendingString:bccStr];
    }
    NSMutableArray * queryArray = [NSMutableArray array];
    if (ccStr) {
        [queryArray addObject:ccStr];
    }
    if (bccStr) {
        [queryArray addObject:bccStr];
    }
    if (subject) {
        [queryArray addObject:[@"subject=" stringByAppendingString:subject]];
    }
    if (body) {
        [queryArray addObject:[@"body=" stringByAppendingString:body]];
    }
    NSString *query = nil;
    if (queryArray.count > 0) {
        query = [queryArray componentsJoinedByString:@"&"];
    }
    [self yh_openScheme:YHURLSchemesBuildInMail host:recipientStr query:query];
}


- (void)yh_tel:(nullable NSString *)tel {
    [self yh_openScheme:YHURLSchemesBuildInTel host:tel];
}

- (void)yh_facetimeVideo:(nullable NSString *)somebody {
    [self yh_openScheme:YHURLSchemesBuildInFaceTimeVideo host:somebody];
}

- (void)yh_facetimeAudio:(nullable NSString *)somebody {
    [self yh_openScheme:YHURLSchemesBuildInFaceTimeAudio host:somebody];
}

- (void)yh_sms:(nullable NSString *)phone {
    [self yh_openScheme:YHURLSchemesBuildInSMS host:phone];
}


#pragma mark -

@end
