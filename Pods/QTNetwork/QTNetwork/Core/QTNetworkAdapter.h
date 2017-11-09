//
//  QTNetworkAdapter.h
//  QTNetwork
//
//  Created by Leo on 2017/8/14.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTRequestConvertable.h"

@class QTNetworkRequest;
NS_ASSUME_NONNULL_BEGIN

@protocol QTNetworkRequestAdapter <NSObject>

/**
 适配方法，在这个方法里，把QTRequestConvertable转换成QTNetworkRequst

 @param requestConvertable 请求
 @param complete 当你完成了QTRequestConvertable->QTNetworkRequst转换后，执行complete闭包，如果出错传入Error对象，传入error对象后，网络请求不会继续进行
 */
- (void)adaptRequestConvertable:(id<QTRequestConvertable>)requestConvertable
                       complete:(void(^)(QTNetworkRequest *  request, NSError *  error))complete;

@end

@protocol QTNetworkURLAdapter <NSObject>

/**
 适配方法，在这个方法里，把QTNetworkRequest转换成NSURLRequest
 
 @param requset QTNetworkRequest请求
 @param complete 当你完成了QTNetworkRequest->NSURLRequest转换后，执行complete闭包，如果出错传入Error对象，传入error对象后，网络请求不会继续进行
 */
- (void)adaptRequest:(QTNetworkRequest * )requset
            complete:(void(^)(NSURLRequest *  request,NSError * error))complete;

@end

/**
 默认的QTNetworkRequst适配
 */
@interface QTNetworkRequestDefaultAdapter : NSObject<QTNetworkRequestAdapter>

- (void)adaptRequestConvertable:(id<QTRequestConvertable> )requestConvertable
                       complete:(void(^)(QTNetworkRequest *  request, NSError *  error))complete;

+ (instancetype)adapter;
@end

/**
 默认的URLRequest适配
 */
@interface QTNetworkURLDefaultAdapter : NSObject <QTNetworkURLAdapter>

- (void)adaptRequest:(QTNetworkRequest * )requset
            complete:(void(^)(NSURLRequest *  request,NSError * error))complete;

+ (instancetype)adapter;

@end

NS_ASSUME_NONNULL_END
