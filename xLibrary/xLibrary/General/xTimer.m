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

+ (xTimer *)timerWithIntervalSeconds:(NSInteger)seconds
                               queue:(dispatch_queue_t)queue
                         fireOnStart:(BOOL)fireOnStart
                              action:(dispatch_block_t)action
{
    return [[xTimer alloc] initWithIntervalSeconds:seconds queue:queue fireOnStart:fireOnStart action:action];
}

+ (xTimer *)timerOnMainWithIntervalSeconds:(NSInteger)seconds
                               fireOnStart:(BOOL)fireOnStart
                                    action:(dispatch_block_t)action{
    return [[xTimer alloc] initWithIntervalSeconds:seconds queue:dispatch_get_main_queue() fireOnStart:fireOnStart action:action];
}

+ (xTimer *)timerOnGlobalWithIntervalSeconds:(NSInteger)seconds
                                 fireOnStart:(BOOL)fireOnStart
                                      action:(dispatch_block_t)action{
    return [[xTimer alloc] initWithIntervalSeconds:seconds queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) fireOnStart:fireOnStart action:action];
}

- (id)initWithIntervalSeconds:(NSInteger)seconds
                        queue:(dispatch_queue_t)queue
                  fireOnStart:(BOOL)fireOnStart
                       action:(dispatch_block_t)action
{
    self = [super init];
    if (self == nil) return nil;
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (self.source != nil) {
        dispatch_source_set_timer(self.source,dispatch_walltime(NULL, fireOnStart?0:seconds*NSEC_PER_SEC),seconds*NSEC_PER_SEC,0);
        dispatch_source_set_event_handler(self.source, action);
    }
    self.suspended = YES;
    return self;
}

-(void)dealloc{
    dispatch_source_set_event_handler(self.source, ^{});
    dispatch_source_cancel(self.source);
    /*
     If the timer is suspended, calling cancel without resuming
     triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
     */
    [self start];
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

@end
