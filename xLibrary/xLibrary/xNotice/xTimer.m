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

+(void)runOnMainAfterSeconds:(NSInteger)seconds block:(void (^)())block {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        if (block) {
            block();
        } });
}

+ (xTimer *)timerWithIntervalSeconds:(NSInteger)seconds
                         queue:(dispatch_queue_t)queue
                         action:(dispatch_block_t)action
{
    return [[xTimer alloc] initWithIntervalSeconds:seconds queue:queue action:action];
}

+ (xTimer *)timerWithStartSeconds:(NSInteger)seconds queue:(dispatch_queue_t)queue action:(dispatch_block_t)action
{
    return [[xTimer alloc] initWithStartSeconds:seconds queue:queue action:action];
}

- (id)initWithIntervalSeconds:(NSInteger)seconds
                 queue:(dispatch_queue_t)queue
                 action:(dispatch_block_t)action
{
    self = [super init];
    if (self == nil) return nil;
    
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (self.source != nil) {
        dispatch_source_set_timer(self.source,dispatch_walltime(NULL, 0),seconds*NSEC_PER_SEC,0);
        dispatch_source_set_event_handler(self.source, action);
    }
    self.suspended = YES;
    
    return self;
}

- (id)initWithStartSeconds:(NSInteger)seconds queue:(dispatch_queue_t)queue action:(dispatch_block_t)action
{
    self = [super init];
    if (self == nil) return nil;
    
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (self.source != nil) {
        dispatch_source_set_timer(self.source, dispatch_walltime(NULL, seconds*NSEC_PER_SEC), seconds*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.source, action);
    }
    self.suspended = YES;
    
    return self;
}
- (void)dealloc
{
    [self cancel];
}

- (void)start {
    if (!self.suspended) return;
    
    dispatch_resume(self.source);
    self.suspended = NO;
}

- (void)stop {
    if (self.suspended) return;
    
    dispatch_suspend(self.source);
    self.suspended = YES;
}

- (void)cancel {
    dispatch_source_cancel(self.source);
}

@end
