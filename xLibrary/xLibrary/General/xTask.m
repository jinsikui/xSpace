//
//  xTask.m
//  QTRadio
//
//  Created by JSK on 2017/11/22.
//  Copyright © 2017年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "xTask.h"

@implementation xTask

+(void)asyncMain:(void(^)())task{
    dispatch_async(dispatch_get_main_queue(), task);
}

+(void)asyncGlobal:(void(^)())task{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), task);
}

+(void)async:(dispatch_queue_t)queue task:(void(^)())task{
    dispatch_async(queue, task);
}

+(void)asyncMainAfter:(double)seconds task:(void(^)())task{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), task);
}

+(void)asyncGlobalAfter:(double)seconds task:(void(^)())task{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), task);
}

+(void)asyncAfter:(double)seconds onQueue:(dispatch_queue_t)queue task:(void(^)())task{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), queue, task);
}

@end
