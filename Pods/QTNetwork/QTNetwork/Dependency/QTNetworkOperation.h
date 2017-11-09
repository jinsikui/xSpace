//
//  QTNetworkOperation.h
//  QTNetwork
//
//  Created by Leo on 2017/8/18.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTNetworkAsyncOperation.h"
#import "QTNetwork.h"
#
@interface QTNetworkOperation : QTNetworkAsyncOperation

- (instancetype)initWithRequestable:(id<QTRequestConvertable>)requestable completion:(void(^)(QTNetworkResponse *))completion;

- (instancetype)initWithRequestable:(id<QTRequestConvertable>)requestable manager:(QTNetworkManager *)manager completion:(void(^)(QTNetworkResponse *))completion;
@end
