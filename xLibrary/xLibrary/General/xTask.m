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
    self.result = result;
    self.error = error;
    self.status = status;
}

@end

@interface xAsyncTaskHandle:xTaskHandle

@property(nonatomic) BOOL isInvoked;

@end

@implementation xAsyncTaskHandle

-(instancetype)init{
    return [super init];
}

@end

@interface xAsyncTask(){
    xAsyncTaskHandle *_handle;
}
@end

@implementation xAsyncTask

-(xTaskHandle*)handle{
    return _handle;
}

-(xTaskStatus)status{
    return _handle.status;
}

-(instancetype)initWithQueue:(dispatch_queue_t)queue after:(double)afterSecs task:(void(^)())task{
    self = [super init];
    if(!self)
        return nil;
    _handle = [[xAsyncTaskHandle alloc] init];
    _queue = queue;
    _afterSecs = afterSecs;
    _task = task;
    return self;
}

-(void)execute{
    if(_handle.status == xTaskStatusInitial) {
        _handle.status = xTaskStatusExecuting;
        xAsyncTaskHandle *hd = (xAsyncTaskHandle *)_handle;
        void (^block)() = _task;
        void (^wrapperBlock)() = ^{
            if(hd.status == xTaskStatusExecuting) {
                hd.isInvoked = YES;
                block();
                hd.status = xTaskStatusCompleted;
            }
        };
        if(_afterSecs <= 0){
            dispatch_async(_queue, wrapperBlock);
        }
        else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_afterSecs * NSEC_PER_SEC)), _queue, wrapperBlock);
        }
    }
}

-(void)cancel{
    if((_handle.status == xTaskStatusInitial || _handle.status == xTaskStatusExecuting) && !_handle.isInvoked){
        _handle.status = xTaskStatusCanceled;
    }
}

@end

@interface xDelayTask(){
    xTaskHandle *_handle;
}
@end

@implementation xDelayTask

-(xTaskHandle*)handle{
    return _handle;
}

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
        xTaskHandle *hd = _handle;
        void (^wrapperTask)() = ^{
            if(hd.status == xTaskStatusExecuting) {
                [hd complete];
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

@interface xCustomTask(){
    xTaskHandle *_handle;
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

-(xTaskHandle*)handle{
    return _handle;
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
    xTaskHandle *_handle;
    FBKVOController *_kvo;
}

@end

@implementation xCompositeTask

-(instancetype)initWithType:(xCompositeTaskType)type tasks:(NSArray<id<xTaskProtocol>>*)tasks callback:(void(^)(NSArray<id<xTaskProtocol>>*))callback{
    self = [super init];
    if(!self)
        return nil;
    _handle = [[xTaskHandle alloc] init];
    _type = type;
    _tasks = tasks;
    _callback = callback;
    return self;
    
}

-(xTaskHandle*)handle{
    return _handle;
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
            __weak typeof(self) weak = self;
            [_kvo observe:task keyPath:@"handle.status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                [weak handleTaskStatusChange];
            }];
        }
        __weak NSArray<id<xTaskProtocol>> *wTasks = _tasks;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __strong NSArray<id<xTaskProtocol>> *sTasks = wTasks;
            for(id<xTaskProtocol> task in sTasks){
                [task execute];
            }
        });
    }
}

-(void)cancel{
    if(_handle.status == xTaskStatusInitial || _handle.status == xTaskStatusExecuting){
        //置为canceled可保证callback不会被调用
        _handle.status = xTaskStatusCanceled;
        
        for(id<xTaskProtocol> task in _tasks){
            xTaskHandle *handle = task.handle;
            //将子task状态置为canceled，但不保证子task能立刻停止执行
            if(handle.status == xTaskStatusInitial || handle.status == xTaskStatusExecuting){
                handle.status = xTaskStatusCanceled;
            }
        }
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

+(xCompositeTask*)all:(NSArray<id<xTaskProtocol>>*)tasks callback:(void(^)(NSArray<id<xTaskProtocol>>*))callback{
    xCompositeTask *t = [[xCompositeTask alloc] initWithType:xCompositeTaskTypeAll tasks:tasks callback:callback];
    [t execute];
    return t;
}

+(xCompositeTask*)any:(NSArray<id<xTaskProtocol>>*)tasks callback:(void(^)(NSArray<id<xTaskProtocol>>*))callback{
    xCompositeTask *t = [[xCompositeTask alloc] initWithType:xCompositeTaskTypeAny tasks:tasks callback:callback];
    [t execute];
    return t;
}

@end
