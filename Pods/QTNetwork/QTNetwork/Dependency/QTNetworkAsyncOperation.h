//
//  QTNetworkAsyncOperation.h
//  QTNetwork
//
//  Created by Leo on 2017/8/18.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTNetworkAsyncOperation : NSOperation

/**
 异步调用的代码，子类重写
 */
- (void)execute;

/**
 给子类调用的完成当前operation
 */
- (void)finishOperation;

@end
