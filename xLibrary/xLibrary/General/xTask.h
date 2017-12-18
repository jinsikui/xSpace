//
//  xTask.h
//  QTRadio
//
//  Created by JSK on 2017/11/22.
//  Copyright © 2017年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xTaskHandle : NSObject

-(void)cancel;

@property(nonatomic, assign) BOOL isCanceled;
@property(nonatomic, assign) BOOL isCompleted;

@end

@interface xTask : NSObject

+(void)asyncMain:(void(^)())task;

+(void)asyncGlobal:(void(^)())task;

+(void)async:(dispatch_queue_t)queue task:(void(^)())task;

+(xTaskHandle*)asyncMainAfter:(double)seconds task:(void(^)())task;

+(xTaskHandle*)asyncGlobalAfter:(double)seconds task:(void(^)())task;

+(xTaskHandle*)asyncAfter:(double)seconds onQueue:(dispatch_queue_t)queue task:(void(^)())task;

@end
