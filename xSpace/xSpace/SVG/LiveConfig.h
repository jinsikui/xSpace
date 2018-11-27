//
//  LiveConfig.h
//  QTTourAppStore
//
//  Created by JSK on 2018/4/9.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBLPromises.h"

@interface LiveConfig : NSObject

+(LiveConfig*)shared;

@property(nonatomic, readonly) NSInteger maxSendMessageLength;

@property(nonatomic, readonly) NSString *defaultRedPacketMessage;

@property(nonatomic, readonly) NSString *msgPlaceholder;

@property(nonatomic, readonly) NSString *hostinPolicy;

@property(nonatomic, readonly) NSString *applyHostinPlacehoder;

@property(nonatomic, readonly) NSInteger maxApplyHostinMsgLength;

//====================================================================

@property(nonatomic, readonly) NSString *rewardAnimationFolderPath;

-(NSMutableDictionary*)getRewardAnimationConfigFor:(NSInteger)rewardId;

//下载原始动画json文件，将原始的动画文件转化为ios可用的动画文件并保存，原始动画文件中的base64图片转化为本地文件存储，返回ios可用的动画文件
-(FBLPromise<NSDictionary*>*)loadRewardAnimation:(NSString*)animationUrl for:(NSInteger)rewardId;

@end
