//
//  xTimer.h
//  xLibrary
//
//  Created by JSK on 2017/8/3.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xTimer : NSObject

+ (void)runOnMainAfterSeconds:(NSInteger)seconds action:(void (^)())action;

+ (xTimer *)timerWithIntervalSeconds:(NSInteger)seconds queue:(dispatch_queue_t)queue action:(dispatch_block_t)action;

+ (xTimer *)timerWithStartSeconds:(NSInteger)seconds queue:(dispatch_queue_t)queue action:(dispatch_block_t)action;

- (id)initWithIntervalSeconds:(NSInteger)seconds queue:(dispatch_queue_t)queue action:(dispatch_block_t)action;

- (id)initWithStartSeconds:(NSInteger)seconds queue:(dispatch_queue_t)queue action:(dispatch_block_t)action;

- (void)start;

- (void)stop;

- (void)cancel;

@end
