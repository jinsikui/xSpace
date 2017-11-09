//
//  QTBatchNetworkOperation.m
//  QTNetwork
//
//  Created by Leo on 2017/8/18.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTBatchNetworkOperation.h"
#import <objc/runtime.h>
#import "QTNetworkOperation.h"

@interface QTBatchNetworkOperation()

@property (strong, nonatomic) NSArray * requestables;
@property (strong, nonatomic) QTNetworkManager * manager;
@property (strong, nonatomic) void(^completion)(NSArray<QTNetworkResponse *> *);
@property (strong, nonatomic) NSString * udidKey;
@property (strong, nonatomic) NSMutableArray * receiveResponses;
@property (strong, nonatomic) NSOperationQueue * queue;
@end

@implementation QTBatchNetworkOperation

- (instancetype)initWithRequestables:(NSArray *)requestables completion:(void (^)(NSArray<QTNetworkResponse *> *))completion{
    return [self initWithRequestables:requestables
                              manager:[QTNetworkManager manager]
                           completion:completion];
}
- (instancetype)initWithRequestables:(NSArray *)requestables
                             manager:(QTNetworkManager *)manager
                          completion:(void (^)(NSArray<QTNetworkResponse *> *))completion{
    if (self = [super init]) {
        self.requestables = requestables;
        self.manager = manager;
        self.completion = completion;
        self.udidKey = [[NSUUID UUID] UUIDString];
        self.receiveResponses = [[NSMutableArray alloc] initWithCapacity:requestables.count];
        for (NSInteger i = 0; i < requestables.count; i ++) {
            [self.receiveResponses addObject:@(0)];//占位符
        }
        self.queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)execute{
    NSBlockOperation * finishOperation = [NSBlockOperation blockOperationWithBlock:^{
        if (self.completion) {
            self.completion(self.receiveResponses);
        }
    }];
    __block NSMutableArray * operations = [NSMutableArray new];
    [self.requestables enumerateObjectsUsingBlock:^(id<QTRequestConvertable> requestable, NSUInteger idx, BOOL * _Nonnull stop) {
        objc_setAssociatedObject(requestable, [self.udidKey UTF8String], @(idx), OBJC_ASSOCIATION_RETAIN);
        QTNetworkOperation * operation = [[QTNetworkOperation alloc] initWithRequestable:requestable
                                                                                 manager:self.manager
                                                                              completion:^(QTNetworkResponse * response) {
                                                                                  [self updateCallbacksWithResponse:response];
                                                                              }];
        [finishOperation addDependency:operation];
        [operations addObject:operation];
    }];
    [operations enumerateObjectsUsingBlock:^(NSOperation * operation, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.queue addOperation:operation];
    }];
    [self.queue addOperation:finishOperation];
}

- (void)updateCallbacksWithResponse:(QTNetworkResponse *)response{
    @synchronized (self) {
        NSNumber * idx = objc_getAssociatedObject(response.requestConvertable, [self.udidKey UTF8String]);
        [self.receiveResponses replaceObjectAtIndex:idx.integerValue withObject:response];
    }
}
- (void)cancel{
    [self.queue cancelAllOperations];
    [super cancel];
}
@end
