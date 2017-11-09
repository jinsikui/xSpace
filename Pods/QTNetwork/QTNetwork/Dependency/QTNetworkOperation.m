//
//  QTNetworkOperation.m
//  QTNetwork
//
//  Created by Leo on 2017/8/18.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTNetworkOperation.h"

@interface QTNetworkOperation()

@property (strong, nonatomic) id<QTRequestConvertable> requestable;

@property (copy, nonatomic) void (^completion)(QTNetworkResponse *);

@property (strong, nonatomic) QTNetworkManager * manager;

@property (strong, nonatomic) id<QTCancelableToken> token;
@end

@implementation QTNetworkOperation

- (instancetype)initWithRequestable:(id<QTRequestConvertable>)requestable completion:(void (^)(QTNetworkResponse *))completion{
    return [self initWithRequestable:requestable
                             manager:[QTNetworkManager manager]
                          completion:completion];
}

- (instancetype)initWithRequestable:(id<QTRequestConvertable>)requestable
                            manager:(QTNetworkManager *)manager
                         completion:(void (^)(QTNetworkResponse *))completion{
    if (self = [super init]) {
        self.requestable = requestable;
        self.completion = completion;
        self.manager = manager;
    }
    return self;
}

- (void)execute{
    self.token = [self.manager request:self.requestable
                            completion:^(QTNetworkResponse * _Nonnull response) {
                                self.completion(response);
                                [self finishOperation];
                            }];
}

- (void)cancel{
    if (self.token) {
        [self.token cancel];
    }
    [super cancel];
}

- (void)dealloc{
    NSLog(@"Dealloc operation");
}
@end
