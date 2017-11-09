//
//  QTNetworkManager.m
//  QTRadio
//
//  Created by Leo on 2017/8/14.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTNetworkManager.h"
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif
#import "QTNetworkAdapter.h"
#import "NSURLRequest+QTNetwork.h"
#import "QTNetworkCache.h"

typedef void(^QTAFDataTaskCompletionBlock)(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error);
typedef void(^QTAFDownloadTaskCompletionBlock)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error);;

#define BEGIN_ASYNC_MANAGER_QUEUE dispatch_async(self.queue, ^{
#define END_ASYNC_MANAGER_QUEU });

#define BEGIN_ASYNC_MAIN_QUEUE dispatch_async(dispatch_get_main_queue(), ^{
#define END_ASYNC_MAIN_QUEU });

@interface QTCancelableToken : NSObject <QTCancelableToken>

+ (instancetype)token;

@property (assign, nonatomic,readonly)BOOL isCanceled;

@property (strong, nonatomic)NSURLSessionTask * task;

@end

@interface QTCancelableToken()

@property (assign, nonatomic, readwrite)BOOL isCanceled;

@end

@implementation QTCancelableToken


- (instancetype)init{
    if (self = [super init]) {
        _isCanceled = NO;
    }
    return self;
}

- (void)cancel{
    @synchronized (self) {
        if (_isCanceled) {
            return;
        }
        _isCanceled = YES;
        [_task cancel];
    }
}

+ (instancetype)token{
    return [[QTCancelableToken alloc] init];
}
@end



@interface QTNetworkManager()

@property (strong, nonatomic) NSRecursiveLock * lock;

@property (strong, nonatomic) id<QTNetworkRequestAdapter> requestAdapter;

@property (strong, nonatomic) id<QTNetworkURLAdapter> urlAdapter;

@property (strong, nonatomic) AFURLSessionManager * afSessionManager;

@property (strong, nonatomic) dispatch_queue_t queue;

@property (assign, nonatomic, readonly) BOOL trackRepeatRequest;

@property (strong, nonatomic) NSMutableDictionary * callbackMap;//URLRequst -> CallBcaks

@end

@implementation QTNetworkManager

- (void)cancelAllOperations{
    [self.lock lock];
    [self.afSessionManager.operationQueue cancelAllOperations];
    self.callbackMap = [NSMutableDictionary new];
    [self.lock unlock];
}
+ (instancetype)shared{
    static QTNetworkManager * _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [QTNetworkManager manager];
    });
    return _instance;
}
+ (instancetype)manager{
    return [[QTNetworkManager alloc] initWithConfiguraiton:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (instancetype)initWithConfiguraiton:(NSURLSessionConfiguration *)sessionConfiguration
                       requestAdapter:(id<QTNetworkRequestAdapter>)requestAdapter
                           urlAdapter:(id<QTNetworkURLAdapter>)urlAdapter
                   trackRepeatRequest:(BOOL)trackRepeactRequest{
    NSParameterAssert(sessionConfiguration != nil);
    NSParameterAssert(requestAdapter != nil && [requestAdapter conformsToProtocol:@protocol(QTNetworkRequestAdapter)]);
    NSParameterAssert(urlAdapter != nil && [urlAdapter conformsToProtocol:@protocol(QTNetworkURLAdapter)]);
    if (self = [super init]) {
        self.requestAdapter = requestAdapter;
        self.urlAdapter = urlAdapter;
        self.afSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        self.afSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.queue = dispatch_queue_create("com.qtnetwork.sessionManager.queue", DISPATCH_QUEUE_SERIAL);
        _trackRepeatRequest = trackRepeactRequest;
        if (self.trackRepeatRequest) {
            self.callbackMap = [NSMutableDictionary new];
        }
        self.lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}
- (instancetype)initWithConfiguraiton:(NSURLSessionConfiguration *)sessionConfiguration
                   trackRepeatRequest:(BOOL)trackRepeactRequest{
    QTNetworkRequestDefaultAdapter * requestAdapter = [[QTNetworkRequestDefaultAdapter alloc] init];
    QTNetworkURLDefaultAdapter * urlAdapter = [[QTNetworkURLDefaultAdapter alloc] init];
    return [self initWithConfiguraiton:sessionConfiguration
                        requestAdapter:requestAdapter
                            urlAdapter:urlAdapter
                    trackRepeatRequest:trackRepeactRequest];
}
- (instancetype)initWithConfiguraiton:(NSURLSessionConfiguration *)sessionConfiguration{
    QTNetworkRequestDefaultAdapter * requestAdapter = [[QTNetworkRequestDefaultAdapter alloc] init];
    QTNetworkURLDefaultAdapter * urlAdapter = [[QTNetworkURLDefaultAdapter alloc] init];
    return [self initWithConfiguraiton:sessionConfiguration
                        requestAdapter:requestAdapter
                            urlAdapter:urlAdapter
                    trackRepeatRequest:NO];
}

- (id<QTCancelableToken>)request:(id<QTRequestConvertable>)requestConvertable
     completion:(void (^)(QTNetworkResponse * _Nonnull))completion{
    return [self request:requestConvertable
                progress:nil
              completion:completion];
}

- (id<QTCancelableToken>)request:(id<QTRequestConvertable>)requestConvertable
                   progress:(QTNetworkResposeProgress )progress
                 completion:(QTNetworkResposeComplete)completion{
    NSParameterAssert(requestConvertable != nil);
    QTCancelableToken * token = [QTCancelableToken token];
    [self.requestAdapter adaptRequestConvertable:requestConvertable
                                        complete:^(QTNetworkRequest * _Nonnull request, NSError * _Nonnull error) {
                                            if (error) {
                                                [self envokeCompletion:completion withError:error request:requestConvertable];
                                                return;
                                            }
                                            if (token.isCanceled) {
                                                NSError * error = [NSError errorWithDomain:QTNetworkErrorDomain
                                                                                      code:QTNetworkErrorCanceled
                                                                                  userInfo:nil];
                                                [self envokeCompletion:completion withError:error request:requestConvertable];
                                                return;
                                            }
                                            if (request == nil) {
                                                NSError * error = [NSError errorWithDomain:QTNetworkErrorDomain
                                                                                      code:QTNetworkErrorFailToAdaptQTNetworkRequest
                                                                                  userInfo:nil];
                                                [self envokeCompletion:completion withError:error request:requestConvertable];
                                                return;
                                            }
                                            [self.urlAdapter adaptRequest:request
                                                                 complete:^(NSURLRequest * _Nonnull urlRequest, NSError * _Nonnull error) {
                                                                     if (error) {
                                                                         [self envokeCompletion:completion withError:error request:requestConvertable];
                                                                         return;
                                                                     }
                                                                     if (token.isCanceled) {
                                                                         NSError * error = [NSError errorWithDomain:QTNetworkErrorDomain
                                                                                                               code:QTNetworkErrorCanceled
                                                                                                           userInfo:nil];
                                                                         [self envokeCompletion:completion withError:error request:requestConvertable];
                                                                         return;
                                                                     }
                                                                     if (urlRequest == nil) {
                                                                         NSError * error = [NSError errorWithDomain:QTNetworkErrorDomain
                                                                                                               code:QTNetworkErrorFailToAdaptURLRequest
                                                                                                           userInfo:nil];
                                                                         [self envokeCompletion:completion withError:error request:requestConvertable];
                                                                         return;
                                                                     }
                                                                     if ([requestConvertable respondsToSelector:@selector(stubData)]) {//走假数据模式
                                                                         if ([requestConvertable stubData] != nil) {
                                                                             [self envokeSubWithrequestConvertable:requestConvertable
                                                                                                        urlRequest:urlRequest
                                                                                                        completion:completion];
                                                                             return;
                                                                         }
                                                                     }
                                                                     //重复网络请求检查
                                                                     if(self.trackRepeatRequest){
                                                                         [self.lock lock];
                                                                         NSString * requestID = urlRequest.qt_unqiueIdentifier;
                                                                         NSArray * callBacks = [self.callbackMap objectForKey:requestID];
                                                                         NSMutableArray * updatedCallbacks;
                                                                         if (callBacks == nil) {
                                                                             updatedCallbacks = [NSMutableArray new];
                                                                         }else{
                                                                             updatedCallbacks = [[NSMutableArray alloc] initWithArray:callBacks];
                                                                         }
                                                                         if (completion) {
                                                                             [updatedCallbacks addObject:completion];
                                                                         }
                                                                         NSArray * array = [[NSArray alloc] initWithArray:updatedCallbacks];
                                                                         [self.callbackMap setObject:array forKey:requestID];
                                                                         [self.lock unlock];
                                                                         if (array.count > 1) {//同时存在几个一样的请求
                                                                             return;
                                                                         }
                                                                     }
                                                                     if ([requestConvertable respondsToSelector:@selector(durationForReturnCache)]) {
                                                                         NSTimeInterval duration = [requestConvertable durationForReturnCache];
                                                                         QTNetworkCacheItem * item = [QTNetworkCache cachedDataForRequest:urlRequest expire:duration];
                                                                         if (item) {//有缓存数据
                                                                             [self envokeCacheCallBackWithrequestConvertable:requestConvertable
                                                                                                           urlRequest:urlRequest
                                                                                                           cachedItem:item
                                                                                                           completion:completion];
                                                                             return;
                                                                         }
                                                                     }
                                                                     NSInteger retryTimes = [requestConvertable respondsToSelector:@selector(retryTimes)] ? [requestConvertable retryTimes] - 1: 0;
                                                                     [self startTaskWithRequestConvertable:requestConvertable
                                                                                                urlRequest:urlRequest
                                                                                                     token:token
                                                                                              toRetryTimes:retryTimes
                                                                                                  progress:progress
                                                                                                completion:completion];
                                                                 }];
                                        }];
    return token;
    
}


- (void)envokeCompletion:(void(^)(QTNetworkResponse *  response))completion withError:(NSError *)error request:(id<QTRequestConvertable>) requestConvertable{
    QTNetworkResponse * response = [[QTNetworkResponse alloc] initWithRequest:requestConvertable urlResponse:nil responseData:nil error:error];
    BEGIN_ASYNC_MAIN_QUEUE
    if (completion) {
        completion(response);
    }
    END_ASYNC_MAIN_QUEU
}

- (void)envokeCacheCallBackWithrequestConvertable:(id<QTRequestConvertable>)requestConvertable
                                urlRequest:(NSURLRequest *)urlRequest
                                cachedItem:(QTNetworkCacheItem *)item
                                completion:(void(^)(QTNetworkResponse *  response))completion{
    BEGIN_ASYNC_MANAGER_QUEUE
    QTNetworkResponse * response = [[QTNetworkResponse alloc] initWithRequest:requestConvertable
                                                                  urlResponse:item.httpResponse
                                                                 responseData:item.data
                                                                        error:nil
                                                                       source:QTNetworkResponseSourceLocalCache];
    if(self.trackRepeatRequest){
        [self.lock lock];
        NSString * requestID = urlRequest.qt_unqiueIdentifier;
        NSArray * callBacks = [self.callbackMap objectForKey:requestID];
        for (QTNetworkResposeComplete callback in callBacks) {
            [self envokeCallBack:callback withResponse:response requestConvertable:requestConvertable];
        }
        [self.callbackMap removeObjectForKey:requestID];
        [self.lock unlock];
    }else{
        [self envokeCallBack:completion withResponse:response requestConvertable:requestConvertable];
    }
    END_ASYNC_MANAGER_QUEU
}
- (void)envokeSubWithrequestConvertable:(id<QTRequestConvertable>)requestConvertable
                      urlRequest:(NSURLRequest *)urlRequest
                      completion:(void(^)(QTNetworkResponse *  response))completion{
    BEGIN_ASYNC_MANAGER_QUEUE
    QTNetworkSub * stub = [requestConvertable stubData];
    QTNetworkResponse * response;
    if (stub.sampleData) {
        response = [[QTNetworkResponse alloc] initStubResponseWithRequest:requestConvertable
                                                                     data:stub];
        dispatch_after(DISPATCH_TIME_NOW + stub.delay, self.queue, ^{
            if(self.trackRepeatRequest){
                [self.lock lock];
                NSString * requestID = urlRequest.qt_unqiueIdentifier;
                NSArray * callBacks = [self.callbackMap objectForKey:requestID];
                for (QTNetworkResposeComplete  callback in callBacks) {
                    [self envokeCallBack:callback withResponse:response requestConvertable:requestConvertable];
                }
                [self.callbackMap removeObjectForKey:requestID];
                [self.lock unlock];
            }else{
                [self envokeCallBack:completion withResponse:response requestConvertable:requestConvertable];
            }
        });
    }
    END_ASYNC_MANAGER_QUEU
}

- (void)envokeCallBack:(QTNetworkResposeComplete)callback
          withResponse:(QTNetworkResponse *)response
           requestConvertable:(id<QTRequestConvertable>)requestConvertable{
    
    if ([requestConvertable respondsToSelector:@selector(adaptResponse:)]) {
        QTNetworkResponse * adaptedResponse = [requestConvertable adaptResponse:response];
        NSAssert(adaptedResponse != nil, @"You can not return a empty response here");
        if (adaptedResponse == nil) {
            adaptedResponse = response;
        }
        BEGIN_ASYNC_MAIN_QUEUE
        callback(adaptedResponse);
        END_ASYNC_MAIN_QUEU
    }else{
        BEGIN_ASYNC_MAIN_QUEUE
        callback(response);
        END_ASYNC_MAIN_QUEU
    }
}

- (void)startTaskWithRequestConvertable:(id<QTRequestConvertable>)requestConvertable
                             urlRequest:(NSURLRequest *)urlRequest
                                  token:(QTCancelableToken *)token
                           toRetryTimes:(NSInteger)retryTimes
                               progress:(QTNetworkResposeProgress)progress
                             completion:(void(^)(QTNetworkResponse *  response))completion{
    QTRequestType * requestType = [QTRequestType data];
    if ([requestConvertable respondsToSelector:@selector(requestType)]) {
        requestType = [requestConvertable requestType];
    }
    QTAFDataTaskCompletionBlock dataCompletion = ^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (token.isCanceled) {
            NSError * error = [NSError errorWithDomain:QTNetworkErrorDomain
                                                  code:QTNetworkErrorCanceled
                                              userInfo:nil];
            [self envokeCompletion:completion withError:error request:requestConvertable];
            return;
        }
        if (retryTimes > 0 && error) {
            [self startTaskWithRequestConvertable:requestConvertable
                                       urlRequest:urlRequest
                                            token:token
                                     toRetryTimes:(retryTimes - 1)
                                         progress:progress
                                       completion:completion];
            return;
        }
        //保存数据
        if ([requestConvertable respondsToSelector:@selector(durationForReturnCache)] && !error) {
            NSTimeInterval duration = [requestConvertable durationForReturnCache];
            if (duration > 0) {
                [QTNetworkCache saveCache:responseObject
                               forRequset:urlRequest
                             httpResponse:response
                                   expire:duration];
            }
        }
        QTNetworkResponse * networkResponse = [[QTNetworkResponse alloc] initWithRequest:requestConvertable
                                                                             urlResponse:response
                                                                            responseData:responseObject
                                                                                   error:error];
        if(self.trackRepeatRequest){
            [self.lock lock];
            NSString * requestID = urlRequest.qt_unqiueIdentifier;
            NSArray * callBacks = [self.callbackMap objectForKey:requestID];
            for (QTNetworkResposeComplete callback in callBacks) {
                [self envokeCallBack:callback withResponse:networkResponse requestConvertable:requestConvertable];
            }
            [self.callbackMap removeObjectForKey:requestID];
            [self.lock unlock];
        }else{
            [self envokeCallBack:completion withResponse:networkResponse requestConvertable:requestConvertable];
        }
    };
    if ([requestType isKindOfClass:[QTRequestTypeDownlaod class]]) {//下载任务
        QTRequestTypeDownlaod * download = (QTRequestTypeDownlaod *)requestType;
        
        QTAFDownloadTaskCompletionBlock downloadCompletion = ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (token.isCanceled) {
                NSError * error = [NSError errorWithDomain:QTNetworkErrorDomain
                                                      code:QTNetworkErrorCanceled
                                                  userInfo:nil];
                [self envokeCompletion:completion withError:error request:requestConvertable];
                return;
            }
            if (retryTimes > 0 && error) {
                [self startTaskWithRequestConvertable:requestConvertable
                                           urlRequest:urlRequest
                                                token:token
                                         toRetryTimes:(retryTimes - 1)
                                             progress:progress
                                           completion:completion];
                return;
            }
            QTNetworkResponse * networkResponse = [[QTNetworkResponse alloc] initWithRequest:requestConvertable
                                                                                 urlResponse:response
                                                                                    filePath:filePath
                                                                                       error:error];
            if(self.trackRepeatRequest){
                [self.lock lock];
                NSString * requestID = urlRequest.qt_unqiueIdentifier;
                NSArray * callBacks = [self.callbackMap objectForKey:requestID];
                for (QTNetworkResposeComplete callback in callBacks) {
                    [self envokeCallBack:callback withResponse:networkResponse requestConvertable:requestConvertable];
                }
                [self.callbackMap removeObjectForKey:requestID];
                [self.lock unlock];
            }else{
                [self envokeCallBack:completion withResponse:networkResponse requestConvertable:requestConvertable];
            }
        };
        NSURLSessionDownloadTask * task;
        if (!download.resumeData) {
            task = [self.afSessionManager downloadTaskWithRequest:urlRequest
                                                         progress:progress
                                                      destination:download.destionation
                                                completionHandler:downloadCompletion];
        }else{
            task = [self.afSessionManager downloadTaskWithResumeData:download.resumeData
                                                            progress:progress
                                                         destination:download.destionation
                                                   completionHandler:downloadCompletion];
        }
        token.task = task;
        [task resume];
    }else if ([requestConvertable isKindOfClass:[QTRequestTypeUpload class]]) {//上传任务
        QTRequestTypeUpload * upload = (QTRequestTypeUpload *)requestConvertable.requestType;
        NSURLSessionUploadTask * task;
        if (upload.data) {
            task = [self.afSessionManager uploadTaskWithRequest:urlRequest
                                                       fromData:upload.data
                                                       progress:progress
                                              completionHandler:dataCompletion];
        }else if(!upload.isMultiPartFormData){
            task = [self.afSessionManager uploadTaskWithRequest:urlRequest
                                                       fromFile:upload.fileURL
                                                       progress:progress
                                              completionHandler:dataCompletion];
        }else{
            task = [self.afSessionManager uploadTaskWithStreamedRequest:urlRequest
                                                               progress:progress
                                                      completionHandler:dataCompletion];
        }

        token.task = task;
        [task resume];
    }else{
        NSURLSessionDataTask * task = [self.afSessionManager dataTaskWithRequest:urlRequest
                                                               completionHandler:dataCompletion];
        token.task = task;
        [task resume];
    }

}
@end

