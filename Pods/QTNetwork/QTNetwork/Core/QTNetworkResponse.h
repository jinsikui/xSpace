//
//  QTNetworkResponse.h
//  QTNetwork
//
//  Created by Leo on 2017/8/14.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTRequestConvertable.h"

@protocol QTRequestConvertable;

extern NSString * const QTNetworkErrorDomain;

typedef NS_ENUM(NSInteger, QTNetworkErrorCode){
    QTNetworkErrorCanceled = -400001, //请求被取消
    QTNetworkErrorFailToAdaptQTNetworkRequest = -400002, //从Requstable -> QTNeworkRequest转换失败
    QTNetworkErrorFailToAdaptURLRequest = -400003, //从QTNeworkRequest -> URLRequst转换失败
};


/**
 响应对象的来源

 - QTNetworkResponseSourceStub: 由假数据返回，假数据由Requestable提供
 - QTNetworkResponseSourceLocalCache: 由本地缓存提供
 - QTNetworkResponseSourceURLLoadingSystem: 由URL Loading System提供
 */
typedef NS_ENUM(NSInteger, QTNetworkResponseSource){
    QTNetworkResponseSourceStub,
    QTNetworkResponseSourceLocalCache,
    QTNetworkResponseSourceURLLoadingSystem
};

/**
   网络请求返回给上层的对象
 */
@interface QTNetworkResponse<T> : NSObject


/**
 网络请求返回的对象，默认当作JSON解析的，这个对象是经过Requestable适配后的对象，客户端
 */
@property (strong, nonatomic, readonly) T responseObject;

/**
 网络请求的HTTP Response
 */
@property (strong, nonatomic, readonly) NSURLResponse * urlResponse;

/**
 网络请求的错误，没有Error说明请求成功
 */
@property (strong, nonatomic, readonly) NSError * error;

/**
 状态码
 */
@property (assign, nonatomic,readonly) NSInteger statusCode;

/**
 原始的请求
 */
@property (strong, nonatomic,readonly) id <QTRequestConvertable> requestConvertable;

/**
 下载文件的路径（只有download任务有效）
 */
@property (strong, nonatomic, readonly) NSURL * filePath;

/**
 数据的来源
 */
@property (assign, nonatomic, readonly) QTNetworkResponseSource source;

- (instancetype)initWithRequest:(id<QTRequestConvertable>)request
                    urlResponse:(NSURLResponse *)urlResponse
                   responseData:(NSData *)data
                          error:(NSError *)error;


- (instancetype)initWithRequest:(id<QTRequestConvertable>)request
                    urlResponse:(NSURLResponse *)urlResponse
                       filePath:(NSURL *)filePath
                          error:(NSError *)error;


- (instancetype)initWithRequest:(id<QTRequestConvertable>)request
                    urlResponse:(NSURLResponse *)urlResponse
                   responseData:(NSData *)data
                          error:(NSError *)error
                         source:(QTNetworkResponseSource)source;

- (instancetype)initWithRequest:(id<QTRequestConvertable>)request
                    urlResponse:(NSURLResponse *)urlResponse
                       filePath:(NSURL *)filePath
                          error:(NSError *)error
                         source:(QTNetworkResponseSource)source;


- (instancetype)initStubResponseWithRequest:(id<QTRequestConvertable>)request data:(QTNetworkSub *)data;

- (instancetype)initWithResponse:(QTNetworkResponse *)response adpatedObject:(id)object;
- (instancetype)initWithResponse:(QTNetworkResponse *)response udpatedError:(NSError *)error;
@end
