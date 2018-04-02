//
//  xTask.m
//  QTRadio
//
//  Created by JSK on 2017/11/22.
//  Copyright © 2017年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "xTask.h"
#import "KVOController.h"

@implementation xTaskHandle

-(void)cancel{
    [self _setStatus:xTaskStatusCanceled result:nil error:nil];
}
-(void)cancel:(id)result error:(NSError*)error{
    [self _setStatus:xTaskStatusCanceled result:result error:error];
}
-(void)complete{
    [self _setStatus:xTaskStatusCompleted result:nil error:nil];
}
-(void)complete:(id)result{
    [self _setStatus:xTaskStatusCompleted result:result error:nil];
}
-(void)complete:(id)result error:(NSError*)error{
    [self _setStatus:xTaskStatusCompleted result:result error:error];
}

-(void)_setStatus:(xTaskStatus)status result:(id)result error:(NSError*)error{
    self.status = status;
    self.result = result;
    self.error = error;
}

@end

@interface xAsyncTask()
@property(nonatomic) BOOL isBlockInvoked;
@end

@implementation xAsyncTask

-(xTaskStatus)status{
    return _handle.status;
}

-(instancetype)initWithQueue:(dispatch_queue_t)queue after:(double)afterSecs task:(void(^)())task{
    self = [super init];
    if(!self)
        return nil;
    _handle = [[xTaskHandle alloc] init];
    _queue = queue;
    _afterSecs = afterSecs;
    _task = task;
    return self;
}

-(void)execute{
    if(_handle.status == xTaskStatusInitial) {
        _handle.status = xTaskStatusExecuting;
        __weak typeof(self) weak = self;
        void (^wrapperTask)() = ^{
            __strong typeof(weak) self_ = weak;
            if(self_.handle.status == xTaskStatusExecuting) {
                self_.isBlockInvoked = YES;
                self_.task();
                self_.handle.status = xTaskStatusCompleted;
            }
        };
        if(_afterSecs <= 0){
            dispatch_async(_queue, wrapperTask);
        }
        else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_afterSecs * NSEC_PER_SEC)), _queue, wrapperTask);
        }
    }
}

-(void)cancel{
    if((_handle.status == xTaskStatusInitial || _handle.status == xTaskStatusExecuting) && !_isBlockInvoked){
        _handle.status = xTaskStatusCanceled;
    }
}

@end

@implementation xDelayTask

-(xTaskStatus)status{
    return _handle.status;
}

-(instancetype)initWithDelaySecs:(double)delaySecs{
    self = [super init];
    if(!self)
        return nil;
    _handle = [[xTaskHandle alloc] init];
    _delaySecs = delaySecs;
    return self;
}

-(void)execute {
    if(_handle.status == xTaskStatusInitial) {
        _handle.status = xTaskStatusExecuting;
        __weak typeof(self) weak = self;
        void (^wrapperTask)() = ^{
            __strong typeof(weak) self_ = weak;
            if(self_.handle.status == xTaskStatusExecuting) {
                self_.handle.status = xTaskStatusCompleted;
            }
        };
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delaySecs * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), wrapperTask);
    }
}

-(void)cancel{
    if(_handle.status == xTaskStatusInitial || _handle.status == xTaskStatusExecuting){
        _handle.status = xTaskStatusCanceled;
    }
}

@end

@implementation xCustomTask

-(instancetype)initWithHandler:(void(^)(xTaskHandle*))handler{
    self = [super init];
    if(!self)
        return nil;
    _handle = [[xTaskHandle alloc] init];
    _handler = handler;
    return self;
}

-(xTaskStatus)status{
    return _handle.status;
}

-(void)execute {
    if(_handler != nil){
        _handler(_handle);
    }
}

@end

@interface xCompositeTask(){
    FBKVOController *_kvo;
}

@end

@implementation xCompositeTask

-(instancetype)initWithType:(xCompositeTaskType)type tasks:(NSArray<xTaskProtocol>*)tasks callback:(void(^)(NSArray<xTaskProtocol>*))callback{
    self = [super init];
    if(!self)
        return nil;
    _handle = [[xTaskHandle alloc] init];
    _type = type;
    _tasks = tasks;
    _callback = callback;
    return self;
    
}

-(void)dealloc{
    _kvo = nil;
}

-(xTaskStatus)status{
    return _handle.status;
}

-(BOOL)determineComplete{
    if(_tasks == nil || _tasks.count == 0){
        return YES;
    }
    if(_type == xCompositeTaskTypeAny){
        for(id<xTaskProtocol> task in _tasks){
            if(task.status == xTaskStatusCompleted || task.status == xTaskStatusCanceled){
                return YES;
            }
        }
        return NO;
    }
    else{
        for(id<xTaskProtocol> task in _tasks){
            if(task.status != xTaskStatusCompleted && task.status != xTaskStatusCanceled){
                return NO;
            }
        }
        return YES;
    }
}

-(void)handleTaskStatusChange{
    BOOL complete = [self determineComplete];
    if(complete){
        _kvo = nil;
        if(_handle.status == xTaskStatusExecuting){
            _handle.status = xTaskStatusCompleted;
            if(_callback){
                _callback(_tasks);
            }
        }
    }
}

-(void)execute{
    if(_handle.status == xTaskStatusInitial) {
        _handle.status = xTaskStatusExecuting;
        _kvo = [[FBKVOController alloc] initWithObserver:self];
        for(id<xTaskProtocol> task in _tasks){
            [task execute];
            __weak typeof(self) weak = self;
            [_kvo observe:task keyPath:@"status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                [weak handleTaskStatusChange];
            }];
        }
    }
}

-(void)cancel{
    if(_handle.status == xTaskStatusInitial || _handle.status == xTaskStatusExecuting){
        _handle.status = xTaskStatusCanceled;
    }
}

@end


@implementation xTask

+(void)asyncMain:(void(^)())task{
    xAsyncTask *t = [self asyncTaskWithQueue:dispatch_get_main_queue() task:task];
    [t execute];
}

+(void)asyncGlobal:(void(^)())task{
    xAsyncTask *t = [self asyncTaskWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) task:task];
    [t execute];
}

+(void)async:(dispatch_queue_t)queue task:(void(^)())task{
    xAsyncTask *t = [self asyncTaskWithQueue:queue task:task];
    [t execute];
}

+(xTaskHandle*)asyncMainAfter:(double)seconds task:(void(^)())task{
    xAsyncTask *t = [self asyncTaskWithQueue:dispatch_get_main_queue() after:seconds task:task];
    [t execute];
    return t.handle;
}

+(xTaskHandle*)asyncGlobalAfter:(double)seconds task:(void(^)())task{
    xAsyncTask *t = [self asyncTaskWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) after:seconds task:task];
    [t execute];
    return t.handle;
}

+(xTaskHandle*)async:(dispatch_queue_t)queue after:(double)seconds task:(void(^)())task{
    xAsyncTask *t = [self asyncTaskWithQueue:queue after:seconds task:task];
    [t execute];
    return t.handle;
}

+(xAsyncTask*)asyncTaskWithQueue:(dispatch_queue_t)queue task:(void(^)())task{
    return [[xAsyncTask alloc] initWithQueue:queue after:0 task:task];
}

+(xAsyncTask*)asyncTaskWithQueue:(dispatch_queue_t)queue after:(double)seconds task:(void(^)())task{
    return [[xAsyncTask alloc] initWithQueue:queue after:seconds task:task];
}

+(xDelayTask*)delayTaskWithDelay:(double)seconds{
    return [[xDelayTask alloc] initWithDelaySecs:seconds];
}

+(xCustomTask*)customTaskWithHandler:(void(^)(xTaskHandle*))handler{
    return [[xCustomTask alloc] initWithHandler:handler];
}

+(xTaskHandle*)all:(NSArray<xTaskProtocol>*)tasks callback:(void(^)(NSArray<xTaskProtocol>*))callback{
    xCompositeTask *t = [[xCompositeTask alloc] initWithType:xCompositeTaskTypeAll tasks:tasks callback:callback];
    [t execute];
    return t.handle;
}

+(xTaskHandle*)any:(NSArray<xTaskProtocol>*)tasks callback:(void(^)(NSArray<xTaskProtocol>*))callback{
    xCompositeTask *t = [[xCompositeTask alloc] initWithType:xCompositeTaskTypeAny tasks:tasks callback:callback];
    [t execute];
    return t.handle;
}

@end
