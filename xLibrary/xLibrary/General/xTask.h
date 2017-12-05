//
//  xTask.h
//  QTRadio
//
//  Created by JSK on 2017/11/22.
//  Copyright © 2017年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xTask : NSObject

+(void)asyncMain:(void(^)())task;

+(void)asyncGlobal:(void(^)())task;

+(void)async:(dispatch_queue_t)queue task:(void(^)())task;

+(void)asyncMainAfter:(double)seconds task:(void(^)())task;

+(void)asyncGlobalAfter:(double)seconds task:(void(^)())task;

+(void)asyncAfter:(double)seconds onQueue:(dispatch_queue_t)queue task:(void(^)())task;

@end
