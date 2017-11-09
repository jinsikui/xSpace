//
//  QTBatchNetworkOperation.h
//  QTNetwork
//
//  Created by Leo on 2017/8/18.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTNetworkAsyncOperation.h"
#import "QTNetwork.h"
/**
 一组网络请求，只有请求都完成才会回调completion
 */
@interface QTBatchNetworkOperation : QTNetworkAsyncOperation

/**
 同一个对象不能被添加到Array里两次，否则会引起混乱
 */
- (instancetype)initWithRequestables:(NSArray *)requestables
                          completion:(void(^)(NSArray<QTNetworkResponse *> *))completion;

- (instancetype)initWithRequestables:(NSArray *)requestables
                             manager:(QTNetworkManager *)manager
                          completion:(void(^)(NSArray<QTNetworkResponse *> *))completion;
@end
