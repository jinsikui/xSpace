//
//  QTChainNetworkOperation.m
//  QTNetwork
//
//  Created by Leo on 2017/8/18.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTChainNetworkOperation.h"
#import "QTNetworkOperation.h"
#import <objc/runtime.h>

@interface QTChainNetworkOperation()

@property (strong, nonatomic) NSArray * requestables;
@property (strong, nonatomic) QTNetworkManager * manager;
@property (strong, nonatomic) void(^completion)(QTNetworkResponse * lastActiveResponse);
@property (strong, nonatomic) NSString * udidKey;
@property (strong, nonatomic) QTNetworkResponse * lastResponse;
@property (strong, nonatomic) NSOperationQueue * queue;
@end



@implementation QTChainNetworkOperation

- (instancetype)initWithRequestables:(NSArray *)requestables completion:(void(^)(QTNetworkResponse * lastActiveResponse))completion{
    return [self initWithRequestables:requestables
                              manager:[QTNetworkManager manager]
                           completion:completion];
}
- (instancetype)initWithRequestables:(NSArray *)requestables
                             manager:(QTNetworkManager *)manager
                          completion:(void(^)(QTNetworkResponse * lastActiveResponse))completion{
    if (self = [super init]) {
        self.requestables = requestables;
        self.manager = manager;
        self.completion = completion;
        self.udidKey = [[NSUUID UUID] UUIDString];
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)execute{
    NSBlockOperation * finishOperation = [NSBlockOperation blockOperationWithBlock:^{
        if (self.completion) {
            self.completion(self.lastResponse);
        }
    }];
    [self.requestables enumerateObjectsUsingBlock:^(id<QTRequestConvertable> requestable, NSUInteger idx, BOOL * _Nonnull stop) {
        objc_setAssociatedObject(requestable, [self.udidKey UTF8String], @(idx), OBJC_ASSOCIATION_RETAIN);
        QTNetworkOperation * operation = [[QTNetworkOperation alloc] initWithRequestable:requestable
                                                                                 manager:self.manager
                                                                              completion:^(QTNetworkResponse * response) {
                                                                                  if (response.error) {//请求失败，取消全部任务
                                                                                      if(self.completion){
                                                                                          self.completion(response);
                                                                                      }
                                                                                      [self.queue cancelAllOperations];
                                                                                  }else{
                                                                                      if ([requestable conformsToProtocol:@protocol(QTChainRequestable)]) {
                                                                                          id<QTChainRequestable> chainRequest = (id)requestable;
                                                                                          NSError * error;
                                                                                          BOOL shouldStartNext = [chainRequest shouldStartNextWithResponse:response error:&error];
                                                                                          if (!shouldStartNext) {
                                                                                              if (!error) {
                                                                                                  error = [NSError errorWithDomain:QTNetworkErrorDomain
                                                                                                                              code:-1000010
                                                                                                                          userInfo:@{@"Reason":@"Chain request decide not to contine"}];
                                                                                              }
                                                                                              QTNetworkResponse * adaptedResponse = [[QTNetworkResponse alloc] initWithResponse:response udpatedError:error];
                                                                                              if(self.completion){
                                                                                                  self.completion(adaptedResponse);
                                                                                              }
                                                                                              [self.queue cancelAllOperations];
                                                                                          }else{
                                                                                              self.lastResponse = response;
                                                                                          }
                                                                                      }else{
                                                                                          self.lastResponse = response;
                                                                                      }
                                                                                  }
                                                                              }];
        [self.queue addOperation:operation];
    }];
    [self.queue addOperation:finishOperation];
}

- (void)cancel{
    [self.queue cancelAllOperations];
    [super cancel];
}

@end
