//
//  YHSessionManager.m
//  YHUtility
//
//  Created by taiyh on 2017/12/5.
//  Copyright © 2017年 taiyh. All rights reserved.
//

#import "YHSessionManager.h"

typedef void (^YHURLSessionTaskSuccessBlock)(NSURLSessionTask *task, id _Nullable responseObject);
typedef void (^YHURLSessionTaskFailureBlock)(NSURLSessionTask * _Nullable task, NSError *error);


// 解析器 serializer
@interface YHRequestSerializer : NSObject

- (NSMutableURLRequest *)requestByJSONSerializingHTTPMethod:(NSString *)method
                                                  URLString:(NSString *)URLString
                                                 parameters:(NSDictionary *)parameters
                                                      error:(NSError *__autoreleasing *)error;

@end

@implementation YHRequestSerializer

- (NSMutableURLRequest *)requestByJSONSerializingHTTPMethod:(NSString *)method
                                           URLString:(NSString *)URLString
                                          parameters:(NSDictionary *)parameters
                                               error:(NSError *__autoreleasing *)error {
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:URL];
    req.HTTPMethod = method;
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:error]];
    return req;
}

@end



/**
 JSON 序列化
 */
@interface YHResponseSerializer : NSObject

- (nullable id)responseJSONObjectWithData:(NSData *)data error:(NSError *__autoreleasing *)error;

@end

@implementation YHResponseSerializer

- (nullable id)responseJSONObjectWithData:(NSData *)data error:(NSError *__autoreleasing *)error {
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:error];
}

@end




@interface YHSessionManager()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>//NSURLSessionDownloadDelegate,NSURLSessionStreamDelegate

@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (readwrite, nonatomic, strong) NSOperationQueue *operationQueue;
@property (readwrite, nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) YHRequestSerializer * requestSerializer;
@property (nonatomic, strong) YHResponseSerializer * responseSerializer;

@property (nonatomic, copy) YHURLSessionTaskSuccessBlock successBlock;
@property (nonatomic, copy) YHURLSessionTaskFailureBlock failureBlock;

@property (nonatomic, strong) NSMutableData *mutableData;

@end

@implementation YHSessionManager

- (instancetype)init {
    return [self initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (!sessionConfiguration) {
        self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];
    
    self.requestSerializer = [[YHRequestSerializer alloc] init];
    self.responseSerializer = [[YHResponseSerializer alloc] init];
    
    self.mutableData = [NSMutableData data];
    
    return self;
}


#pragma mark - NSURLSessionDelegate

/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly invalidated, in which case the error parameter will be nil.
 */
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
}

/*
 * Messages related to the operation of a specific task.  confirm to Protocol NSURLSessionDelegate
 */
#pragma mark - NSURLSessionTaskDelegate

/* Sent periodically to notify the delegate of upload progress.  This
 * information is also available as properties of the task.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
}


/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete. 
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        if (self.failureBlock) {
            self.failureBlock(task, error);
        }
    } else {
        NSError * resError = nil;
        id responseObject = [self.responseSerializer responseJSONObjectWithData:self.mutableData error:&resError];
        if (resError) {
            if (self.failureBlock) {
                self.failureBlock(task, error);
            }
        } else {
            if (self.successBlock) {
                self.successBlock(task, responseObject);
            }
        }
    }
}

/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.mutableData appendData:data];
}


#pragma mark - HTTP Method

- (nullable NSURLSessionTask *)GET:(NSString *)URLString
                            parameters:(nullable NSDictionary *)parameters
                               success:(nullable void (^)(NSURLSessionTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionTask * _Nullable task, NSError *error))failure
{
    NSURLSessionTask * dataTask = [self dataTaskWithHTTPMethod:@"GET" URLString:URLString parameters:parameters success:success failure:failure];
    return dataTask;
}

- (nullable NSURLSessionTask *)POST:(NSString *)URLString
                         parameters:(nullable NSDictionary *)parameters
                            success:(nullable void (^)(NSURLSessionTask *task, id _Nullable responseObject))success
                            failure:(nullable void (^)(NSURLSessionTask * _Nullable task, NSError *error))failure
{
    NSURLSessionTask * dataTask = [self dataTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters success:success failure:failure];
    return dataTask;
}

- (NSURLSessionTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(NSDictionary *)parameters
                                         success:(void (^)(NSURLSessionTask *, id))success
                                         failure:(void (^)(NSURLSessionTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestByJSONSerializingHTTPMethod:method URLString:URLString parameters:parameters error: &serializationError];
    
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    self.successBlock = success;
    self.failureBlock = failure;
    
    NSURLSessionTask *dataTask = [self.session dataTaskWithRequest:request];
    [dataTask resume];
    
    return dataTask;
}


@end
