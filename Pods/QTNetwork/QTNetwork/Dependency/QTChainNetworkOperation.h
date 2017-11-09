//
//  QTChainNetworkOperation.h
//  QTNetwork
//
//  Created by Leo on 2017/8/18.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTNetworkAsyncOperation.h"
#import "QTNetwork.h"

@protocol  QTChainRequestable <QTRequestConvertable>

/**
 收到了上一个网络请求的完成回调，在这里决定是否要继续进行下一个网络请求

 */
- (BOOL)shouldStartNextWithResponse:(QTNetworkResponse *)response error:(NSError **)error;

@end

@interface QTChainNetworkOperation : QTNetworkAsyncOperation

/**
 同一个对象不能被添加到Array里两次，否则会引起混乱
 */
- (instancetype)initWithRequestables:(NSArray *)requestables
                          completion:(void(^)(QTNetworkResponse * lastActiveResponse))completion;

- (instancetype)initWithRequestables:(NSArray *)requestables
                             manager:(QTNetworkManager *)manager
                          completion:(void(^)(QTNetworkResponse * lastActiveResponse))completion;

@end
