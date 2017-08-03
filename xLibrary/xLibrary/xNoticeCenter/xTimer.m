//
//  xTimer.m
//  xLibrary
//
//  Created by JSK on 2017/8/3.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xTimer.h"

@interface xTimer()
@property (nonatomic) dispatch_source_t source;
@property (nonatomic, assign) BOOL suspended;
@end


@implementation xTimer

+ (xTimer *)timerWithInterval:(uint64_t)interval
                        leeway:(uint64_t)leeway
                         queue:(dispatch_queue_t)queue
                         block:(dispatch_block_t)block
{
    return [[xTimer alloc] initWithInterval:interval leeway:leeway queue:queue block:block];
}

+ (xTimer *)timerWithStart:(uint64_t)start leeway:(uint64_t)leeway queue:(dispatch_queue_t)queue block:(dispatch_block_t)block
{
    return [[xTimer alloc] initWithStart:start leeway:leeway queue:queue block:block];
}

- (id)initWithInterval:(uint64_t)interval
                leeway:(uint64_t)leeway
                 queue:(dispatch_queue_t)queue
                 block:(dispatch_block_t)block
{
    self = [super init];
    if (self == nil) return nil;
    
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (self.source != nil) {
        dispatch_source_set_timer(self.source,dispatch_walltime(NULL, 0),interval,leeway);
        dispatch_source_set_event_handler(self.source, block);
    }
    self.suspended = YES;
    
    return self;
}

- (id)initWithStart:(uint64_t)start leeway:(uint64_t)leeway queue:(dispatch_queue_t)queue block:(dispatch_block_t)block
{
    self = [super init];
    if (self == nil) return nil;
    
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (self.source != nil) {
        dispatch_source_set_timer(self.source, dispatch_walltime(NULL, start), start, leeway);
        dispatch_source_set_event_handler(self.source, block);
    }
    self.suspended = YES;
    
    return self;
}
- (void)dealloc
{
    [self cancel];
}

- (void)resume {
    if (!self.suspended) return;
    
    dispatch_resume(self.source);
    self.suspended = NO;
}

- (void)suspend {
    if (self.suspended) return;
    
    dispatch_suspend(self.source);
    self.suspended = YES;
}

- (void)cancel {
    dispatch_source_cancel(self.source);
}

+(void)runMainQueueAfterSec:(CGFloat)sec block:(void (^)())block {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        if (block) {
            block();
        } });
}
@end
