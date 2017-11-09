//
//  QTHTTPRequest.h
//  QTNetwork
//
//  Created by Leo on 2017/8/14.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTRequestType.h"
#import "QTNetworkSub.h"
#import "QTNetworkResponseValider.h"

@class QTNetworkResponse;

typedef NS_ENUM(NSInteger,QTHTTPMethod){
    HTTP_GET,
    HTTP_POST,
    HTTP_PUT,
    HTTP_DELETE,
    HTTP_OPTIONS,
    HTTP_PATCH,
    HTTP_TRACE,
    HTTP_CONNECT,
    HTTP_HEAD
};

typedef NS_ENUM(NSInteger,QTParameterEncoding){
    QTParameterEncodingHTTP,
    QTParameterEncodingJSON,
    QTParameterEncodingPropertyList
};

typedef NS_ENUM(NSInteger,QTResponseDecncoding){
    QTResponseDecncodingHTTP,
    QTResponseDecncodingJSON,
    QTResponseDecncodingXML,
};

NS_ASSUME_NONNULL_BEGIN

@protocol QTRequestConvertable <NSObject>

@property (nonatomic, readonly) NSString *  baseURL;

@property (nonatomic, readonly) NSString *  path;

@optional
/**
 默认是Data Request
 */
@property (nonatomic, readonly) QTRequestType * requestType;
@property (nonatomic, readonly) NSDictionary *  parameters;
@property (nonatomic, readonly) QTHTTPMethod httpMethod; //默认GET

@property (nonatomic, readonly) NSDictionary<NSString *,NSString *> * httpHeaders;
/**
 参数的编码方式，默认会按照HTTP的方式进行编码
 */
@property (nonatomic, readonly) QTParameterEncoding encodingType;
/**
 返回NSData的解码方式，默认按照JSON来解析
 */
@property (nonatomic, readonly) QTResponseDecncoding decodingType;//默认JSON

/**
 如果提供这个方法，那么不会实际进行网络请求，而是以stubData中的数据和模式进行返回
 */
@property (nonatomic, readonly) QTNetworkSub * stubData;
/**
 在多少秒内如果相同的请求发出，当缓存有数据的时候，返回缓存数据
 */
@property (nonatomic, readonly) NSTimeInterval durationForReturnCache;
/**
 对返回的response进行适配，这个方法在后台线程执行
 @param networkResponse 返回的response
 @return 适配后的结果，不可为空
 */
- (QTNetworkResponse *)adaptResponse:(QTNetworkResponse *)networkResponse;

/**
 对请求进行有效性验证
 */
@property (nonatomic, readonly) id<QTNetworkResponseValider> responseValider;

/**
 如果失败的重试次数，默认不会重试
 */
@property (nonatomic, assign) NSUInteger retryTimes;

@end

NS_ASSUME_NONNULL_END
