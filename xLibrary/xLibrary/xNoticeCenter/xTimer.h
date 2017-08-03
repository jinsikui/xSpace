//
//  xTimer.h
//  xLibrary
//
//  Created by JSK on 2017/8/3.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xTimer : NSObject

+ (xTimer *)timerWithInterval:(uint64_t)interval
                        leeway:(uint64_t)leeway
                         queue:(dispatch_queue_t)queue
                         block:(dispatch_block_t)block;

+ (xTimer *)timerWithStart:(uint64_t)start
                     leeway:(uint64_t)leeway
                      queue:(dispatch_queue_t)queue
                      block:(dispatch_block_t)block;
/*
 * 创建完后立刻执行block
 * interval 时间间隔
 * leeway   允许误差
 * queue    回调队列
 * block    执行block
 */
- (id)initWithInterval:(uint64_t)interval
                leeway:(uint64_t)leeway
                 queue:(dispatch_queue_t)queue
                 block:(dispatch_block_t)block;
/*
 * 创建完后过下一个时间间隔执行block
 * start 时间间隔
 * leeway   允许误差
 * queue    回调队列
 * block    执行block
 */
- (id)initWithStart:(uint64_t)start
             leeway:(uint64_t)leeway
              queue:(dispatch_queue_t)queue
              block:(dispatch_block_t)block;

- (void)resume;
- (void)suspend;
- (void)cancel;

+(void)runMainQueueAfterSec:(CGFloat)sec block:(void(^)())block;

@end
