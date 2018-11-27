//
//  LiveError.h
//  QTTourAppStore
//
//  Created by JSK on 2018/4/11.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LIVE_ERROR_DOMAIN @"LIVE_ERROR"

@interface LiveError : NSError
@property(nonatomic) NSString *msg;
+(instancetype)errorWithCode:(NSInteger)code msg:(NSString*)msg;
@end
