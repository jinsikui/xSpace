/*******************************************************************************
    xTask 轻量好用的任务管理组件
    定义: task是指一个实现了xTaskProtocol协议的实例，代表一个会在未来某个时刻结束的过程
    原则上，一个task可以cancel，但不保证cancel成功，这由具体实现决定
    已经实现了以下几种task:
    xAsyncTask: 在某个dispatch queue上执行一个block，可以设置延迟时间，在延迟结束前可以cancel成功
    xDelayTask: 代表一个延迟过程，在延迟结束前可以cancel成功，常作为xCompositeTask的子task
    xCustomTask: 通过一个block来定义task，可自由的决定task何时complete，何时cancel
    xCompositeTask: 传入一组子task和一个回调函数，可设置all或any两种类型，当任意(any)一个子task结束(status == canceled || status == completed)
    或当全部(all)子task结束时，xCompositeTask结束，触发回调函数。每个子task本身也可以是一个xCompositeTask

    应用例子:比如打开红包，希望开红包动效至少持续2秒，可以把请求api的过程封装成一个xCustomTask，同时再创建一个延迟2秒的xDelayTask，两个一起组成一个all类型的xCompositeTask
    这个xCompositeTask可以来实现开红包动效至少持续2秒，即使api在2秒内就返回了。

    Created by JSK on 2017/11/22.
    Copyright © 2017年 Markphone Culture Media Co.Ltd. All rights reserved.
*******************************************************************************/

#import <Foundation/Foundation.h>

typedef enum xTaskStatus{
    xTaskStatusInitial = 0,
    xTaskStatusExecuting,
    xTaskStatusCanceled,
    xTaskStatusCompleted
} xTaskStatus;

@interface xTaskHandle : NSObject

@property(nonatomic) xTaskStatus status;
@property(nonatomic) id result;         //任务执行结果，可以为空
@property(nonatomic) NSError *error;    //错误信息，可以为空

-(void)cancel;
-(void)cancel:(id)result error:(NSError*)error;
-(void)complete;
-(void)complete:(id)result;
-(void)complete:(id)result error:(NSError*)error;

@end

@protocol xTaskProtocol

@property(nonatomic,readonly) xTaskHandle *handle;
@property(nonatomic,readonly) xTaskStatus status;
-(void)execute;     //执行任务

@end

@interface xAsyncTask : NSObject<xTaskProtocol>

@property(nonatomic,readonly) xTaskHandle *handle;
@property(nonatomic,readonly) xTaskStatus status;
@property(nonatomic) dispatch_queue_t     queue;
@property(nonatomic) double               afterSecs;
@property(nonatomic) void(^task)();
-(instancetype)initWithQueue:(dispatch_queue_t)queue after:(double)afterSecs task:(void(^)())task;
-(void)cancel;

@end

@interface xDelayTask : NSObject<xTaskProtocol>

@property(nonatomic,readonly) xTaskHandle *handle;
@property(nonatomic,readonly) xTaskStatus status;
@property(nonatomic) double   delaySecs;
-(instancetype)initWithDelaySecs:(double)delaySecs;
-(void)cancel;

@end

@interface xCustomTask : NSObject<xTaskProtocol>

@property(nonatomic,readonly) xTaskHandle *handle;
@property(nonatomic,readonly) xTaskStatus status;
@property(nonatomic) void (^handler)(xTaskHandle*);
-(instancetype)initWithHandler:(void(^)(xTaskHandle*))handler;

@end

typedef enum xCompositeTaskType{
    xCompositeTaskTypeAll = 1,
    xCompositeTaskTypeAny = 2
}xCompositeTaskType;

@interface xCompositeTask : NSObject<xTaskProtocol>

@property(nonatomic,readonly) xTaskHandle *handle;
@property(nonatomic,readonly) xTaskStatus status;
@property(nonatomic) xCompositeTaskType     type;
@property(nonatomic) NSArray<id<xTaskProtocol>> *tasks;
@property(nonatomic) void (^callback)(NSArray<id<xTaskProtocol>>*);
-(instancetype)initWithType:(xCompositeTaskType)type tasks:(NSArray<id<xTaskProtocol>>*)tasks callback:(void(^)(NSArray<id<xTaskProtocol>>*))callback;
-(void)cancel;

@end


/**
 快捷调用方式
 **/
@interface xTask : NSObject

//会立刻执行
+(void)asyncMain:(void(^)())task;

//会立刻执行
+(void)asyncGlobal:(void(^)())task;

//会立刻执行
+(void)async:(dispatch_queue_t)queue task:(void(^)())task;

//会立刻执行
+(xTaskHandle*)asyncMainAfter:(double)seconds task:(void(^)())task;

//会立刻执行
+(xTaskHandle*)asyncGlobalAfter:(double)seconds task:(void(^)())task;

//会立刻执行
+(xTaskHandle*)async:(dispatch_queue_t)queue after:(double)seconds task:(void(^)())task;

+(xAsyncTask*)asyncTaskWithQueue:(dispatch_queue_t)queue task:(void(^)())task;

+(xAsyncTask*)asyncTaskWithQueue:(dispatch_queue_t)queue after:(double)seconds task:(void(^)())task;

+(xDelayTask*)delayTaskWithDelay:(double)seconds;

+(xCustomTask*)customTaskWithHandler:(void(^)(xTaskHandle*))handler;

//会立刻执行，注意保存返回的xCompositeTask，否则可能还未执行完就连同子task一起被回收了
+(xCompositeTask*)all:(NSArray<id<xTaskProtocol>>*)tasks callback:(void(^)(NSArray<id<xTaskProtocol>>*))callback;

//会立刻执行，注意保存返回的xCompositeTask，否则可能还未执行完就连同子task一起被回收了
+(xCompositeTask*)any:(NSArray<id<xTaskProtocol>>*)tasks callback:(void(^)(NSArray<id<xTaskProtocol>>*))callback;


@end
