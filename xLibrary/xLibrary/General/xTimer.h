//
//  xTimer.h
//  xLibrary
//
//  Created by JSK on 2017/8/3.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xTimer : NSObject

+ (xTimer *)timerWithIntervalSeconds:(double)seconds queue:(dispatch_queue_t)queue fireOnStart:(BOOL)fireOnStart action:(dispatch_block_t)action;

+ (xTimer *)timerOnMainWithIntervalSeconds:(double)seconds fireOnStart:(BOOL)fireOnStart action:(dispatch_block_t)action;

+ (xTimer *)timerOnGlobalWithIntervalSeconds:(double)seconds fireOnStart:(BOOL)fireOnStart action:(dispatch_block_t)action;

- (id)initWithIntervalSeconds:(double)seconds queue:(dispatch_queue_t)queue fireOnStart:(BOOL)fireOnStart action:(dispatch_block_t)action;

- (void)start;

- (void)stop;

@end
