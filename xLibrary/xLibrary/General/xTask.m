//
//  xTask.m
//  QTRadio
//
//  Created by JSK on 2017/11/22.
//  Copyright © 2017年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "xTask.h"

@implementation xTaskHandle

-(void)cancel{
    if(!_isCanceled){
        _isCanceled = YES;
    }
}

@end

@implementation xTask

+(void)asyncMain:(void(^)())task{
    if([NSThread isMainThread]){
        task();
        return;
    }
    dispatch_async(dispatch_get_main_queue(), task);
}

+(void)asyncGlobal:(void(^)())task{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), task);
}

+(void)async:(dispatch_queue_t)queue task:(void(^)())task{
    dispatch_async(queue, task);
}

+(xTaskHandle*)asyncMainAfter:(double)seconds task:(void(^)())task{
    return [self asyncAfter:seconds onQueue:dispatch_get_main_queue() task:task];
}

+(xTaskHandle*)asyncGlobalAfter:(double)seconds task:(void(^)())task{
    return [self asyncAfter:seconds onQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) task:task];
}

+(xTaskHandle*)asyncAfter:(double)seconds onQueue:(dispatch_queue_t)queue task:(void(^)())task{
    xTaskHandle *handle = [[xTaskHandle alloc] init];
    void(^_task)() = ^{
        if(handle.isCanceled){
            return;
        }
        task();
        handle.isCompleted = YES;
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), queue, _task);
    return handle;
}

@end
