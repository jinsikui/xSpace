//
//  QTNetworkManager.h
//  QTRadio
//
//  Created by Leo on 2017/8/14.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTRequestConvertable.h"
#import "QTNetworkResponse.h"
#import "QTNetworkAdapter.h"

NS_ASSUME_NONNULL_BEGIN

/**
 请求创建后返回的透明类型
 */
@protocol QTCancelableToken <NSObject>
/**
 执行取消动作
 */
- (void)cancel;

/**
 动作是否取消了
 */
@property (assign, nonatomic, readonly)BOOL isCanceled;

@end
typedef NSProgress * _Nullable  __autoreleasing * QTNetworkResposeProgress;

typedef void (^QTNetworkResposeComplete)(QTNetworkResponse *  response);

@interface QTNetworkManager : NSObject

/**
 单例
 */
+ (instancetype)shared;

/**
 新建一个实例
*/
+ (instancetype)manager;


/**
 根据sessionConfiguration配置一个实例
 */
- (instancetype)initWithConfiguraiton:(NSURLSessionConfiguration *)sessionConfiguration;


/**
 根据配置信息来创实例
 @param sessionConfiguration 配置信息
 @param trackRepeactRequest 是否要跟踪重复的请求（如果重复，不会进行第二次网络请求）
 */
- (instancetype)initWithConfiguraiton:(NSURLSessionConfiguration *)sessionConfiguration
                   trackRepeatRequest:(BOOL)trackRepeactRequest;


/**
 根据配置信息来创实例

 @param sessionConfiguration 配置信息
 @param requestAdapter 请求适配器
 @param urlAdapter URL适配器
 @param trackRepeactRequest 是否要跟踪重复的请求（如果重复，不会进行第二次网络请求）
 @return 实例
 */
- (instancetype)initWithConfiguraiton:(NSURLSessionConfiguration *)sessionConfiguration
                       requestAdapter:(id<QTNetworkRequestAdapter> )requestAdapter
                           urlAdapter:(id<QTNetworkURLAdapter> )urlAdapter
                    trackRepeatRequest:(BOOL)trackRepeactRequest;


/**
 发出一个网络请求

 @param requestable 请求
 @param proress 进度callback
 @param completion 完成回调
 @return 透明的可以取消的Token
 */
- (id<QTCancelableToken>)request:(id<QTRequestConvertable>)requestable
                      progress:(QTNetworkResposeProgress _Nullable )proress
                    completion:(QTNetworkResposeComplete)completion;

/**
 发出一个网络请求
 
 @param requestable 请求
 @param completion 完成回调
 @return 透明的可以取消的Token
 */
- (id<QTCancelableToken>)request:(id<QTRequestConvertable>)requestable
                    completion:(QTNetworkResposeComplete)completion;


- (void)cancelAllOperations;

@end

NS_ASSUME_NONNULL_END
