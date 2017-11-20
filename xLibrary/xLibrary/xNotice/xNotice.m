//
//  xNotice.m
//  xLibrary
//
//  Created by JSK on 2017/11/18.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xNotice.h"
#import "xTimer.h"


@interface xTimerContext : NSObject

@property(nonatomic)NSInteger intervalTime;
@property(nonatomic)NSInteger curTime;
@property(nonatomic,copy)void(^action)();

-(void)timeTicking;

@end

@implementation xTimerContext

-(void)timeTicking{
    _curTime += 1;
    if (_curTime >= _intervalTime) {
        if(_action != nil){
            _action();
        }
        _curTime = 0;
    }
}

@end

//===================================================================

static NSString *const kAppFinishLaunching = @"xNotice.AppFinishLaunching";
static NSString *const kAppBecomeActive = @"xNotice.AppBecomeActive";
static NSString *const kAppEnterBackground = @"xNotice.AppEnterBackground";
static NSString *const kAppWillTerminate = @"xNotice.AppWillTerminate";
static NSString *const kAppWillResignActive = @"xNotice.AppWillResignActive";
static NSString *const kTimerTicking = @"xNotice.TimerTicking";
static NSString *const _customEventNameKey = @"xNotice.customEventNameKey";
static NSString *const _customEventUserInfoKey = @"xNotice.customEventUserInfoKey";

@interface xNotice()

@property(nonatomic,strong) NSMutableDictionary<NSString*, NSMapTable<id, void(^)(id)>*> *actionDic;
@property(nonatomic,strong) dispatch_queue_t                bindQueue;
@property(nonatomic,strong) xTimer                          *timer;
@property(nonatomic,strong) NSMapTable<id, xTimerContext*>  *timerTable;
@property(nonatomic,strong) NSMutableArray<NSString*>       *customEventNames;
@property(nonatomic,assign) BOOL    hasRegisterred;

@end

@implementation xNotice

+(instancetype)shared {
    static xNotice *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[xNotice alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _timerTable = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
        _actionDic = [NSMutableDictionary dictionary];
        _bindQueue =  dispatch_queue_create([@"xNotice.bindQueue" UTF8String], DISPATCH_QUEUE_CONCURRENT);
        _timer = [xTimer timerWithIntervalSeconds:1 queue:_bindQueue action:^{
            [self timerTicking];
        }];
        _customEventNames = [NSMutableArray array];
        [self registerNotices];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer cancel];
    _timer = nil;
}


-(void)registerNotices {
    if(_hasRegisterred){
        return;
    }
    _hasRegisterred = true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}


-(void)setAction:(NSString *)key lifeIndicator:(id)lifeIndicator action:(id)action {
    NSMapTable *mapTable = _actionDic[key];
    if (!mapTable) {
        mapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableCopyIn];
        _actionDic[key] = mapTable;
    }
    [mapTable setObject:action forKey:lifeIndicator];
}

-(void)runAction:(NSString *)key param:(id)param {
    NSMapTable *mapTable = _actionDic[key];
    if (!mapTable) {
        return;
    }
    NSEnumerator *enumerator = [mapTable objectEnumerator];
    id obj;
    while ( obj = [enumerator nextObject] ) {
        ( (void (^)(id)) obj)(param);
    }
}

#pragma mark - Notification handlers

-(void)appFinishLaunching:(NSNotification*)notification{
    dispatch_async(_bindQueue, ^{
        [self runAction:kAppFinishLaunching param:notification.userInfo];
    });
}

-(void)appBecomeActive:(NSNotification*)notification{
    dispatch_async(_bindQueue, ^{
        [self.timer start];
        [self timerTicking];
        [self runAction:kAppBecomeActive param:notification.userInfo];
    });
}

-(void)appWillResignActive:(NSNotification*)notification{
    dispatch_async(_bindQueue, ^{
        [self.timer stop];
        [self runAction:kAppWillResignActive param:notification.userInfo];
    });
}

-(void)appEnterBackground:(NSNotification*)notification {
    dispatch_async(_bindQueue, ^{
        [self.timer stop];
        [self runAction:kAppEnterBackground param:notification.userInfo];
    });
}

-(void)appWillTerminate:(NSNotification*)notification {
    dispatch_async(_bindQueue, ^{
        [self.timer stop];
        [self runAction:kAppWillTerminate param:notification.userInfo];
    });
}

-(void)timerTicking {
    NSMapTable *mapTable = _actionDic[kTimerTicking];
    if (!mapTable || mapTable.count == 0) {
        [self.timer stop];
        return;
    }
    [self runAction:kTimerTicking param:nil];
}

-(void)customEventFired:(NSNotification*)notification{
    dispatch_async(_bindQueue, ^{
        NSString *eventName = notification.userInfo[_customEventNameKey];
        id userInfo = notification.userInfo[_customEventUserInfoKey];
        [self runAction:eventName param:userInfo];
    });
}

#pragma mark - register methods

-(void)registerAppFinishLaunching:(id)lifeIndicator action:(void(^)(id))action{
    dispatch_barrier_async(_bindQueue, ^{
        [self setAction:kAppFinishLaunching lifeIndicator:lifeIndicator action:action];
    });
}

-(void)registerAppBecomeActive:(id)lifeIndicator action:(void (^)(id))action {
    
    dispatch_barrier_async(_bindQueue, ^{
        [self setAction:kAppBecomeActive lifeIndicator:lifeIndicator action:action];
    });
}

-(void)registerAppWillResignActive:(id)lifeIndicator action:(void (^)(id))action {
    dispatch_barrier_async(_bindQueue, ^{
        [self setAction:kAppWillResignActive lifeIndicator:lifeIndicator action:action];
    });
}

-(void)registerAppEnterBackground:(id)lifeIndicator action:(void (^)(id))action {
    dispatch_barrier_async(_bindQueue, ^{
        [self setAction:kAppEnterBackground lifeIndicator:lifeIndicator action:action];
    });
}

-(void)registerAppWillTerminate:(id)lifeIndicator action:(void (^)(id))action {
    dispatch_barrier_async(_bindQueue, ^{
        [self setAction:kAppWillTerminate lifeIndicator:lifeIndicator action:action];
    });
}

-(void)registerTimerTicking:(id)lifeIndicator action:(void (^)(id))action {
    dispatch_barrier_async(_bindQueue, ^{
        [self setAction:kTimerTicking lifeIndicator:lifeIndicator action:action];
        [self.timer start];
    });
}

-(void)registerTimer:(id)lifeIndicator intervalSeconds:(NSInteger)seconds action:(void (^)())action {
    dispatch_barrier_async(_bindQueue, ^{
        xTimerContext *context = [[xTimerContext alloc] init];
        context.curTime = 0;
        context.intervalTime = seconds;
        context.action = action;
        [self.timerTable setObject:context forKey:lifeIndicator];
        __weak typeof(context)weak = context;
        [self registerTimerTicking:lifeIndicator action:^(id param){
            [weak timeTicking];
        }];
    });
}

-(void)registerEvent:(NSString*)eventName lifeIndicator:(id)lifeIndicator action:(void (^)(id))action{
    dispatch_barrier_async(_bindQueue, ^{
        [self setAction:eventName lifeIndicator:lifeIndicator action:action];
    });
}

#pragma mark - post events

-(void)postEvent:(NSString*)eventName userInfo:(NSDictionary<NSString*, id>*)userInfo{
    dispatch_barrier_sync(_bindQueue, ^{
        if(![self.customEventNames containsObject:eventName]){
            [self.customEventNames addObject:eventName];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customEventFired:) name:eventName object:nil];
        }
        NSMutableDictionary<NSString*, id> *userInfoWrapper = [[NSMutableDictionary alloc] init];
        userInfoWrapper[_customEventNameKey] = eventName;
        if(userInfo){
            userInfoWrapper[_customEventUserInfoKey] = userInfo;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:nil userInfo:userInfoWrapper];
    });
}

@end
