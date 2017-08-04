//
//  xNoticeCenter.m
//  xLibrary
//
//  Created by JSK on 2017/8/3.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xNoticeCenter.h"
#import "xTimer.h"
#import "xAlert.h"



@interface xNoticeTime : NSObject

@property(nonatomic)NSInteger intervalTime;
@property(nonatomic)NSInteger currentTime;
@property(nonatomic,copy)void(^callback)();

@end

@implementation xNoticeTime
@end

//===================================================================

static NSString *const kSysAppFinishLaunching = @"kSysAppFinishLaunching";
static NSString *const kSysAppBecomeActive = @"kSysAppBecomeActive";
static NSString *const kSysAppEnterBackground = @"kSysAppEnterBackground";
static NSString *const kSysAppWillTerminate = @"kSysAppWillTerminate";
static NSString *const kSysAppWillResignActive = @"kSysAppWillResignActive";
static NSString *const kTimerRun = @"kTimerRun";

@interface xNoticeCenter()

@property(nonatomic,strong) xTimer              *timer;
@property(nonatomic,strong) NSMutableDictionary *actionDic;
@property(nonatomic,strong) NSMapTable          *timerMap;
@property(nonatomic,strong) dispatch_queue_t    bindQueue;

@end

@implementation xNoticeCenter

+(instancetype)sharedInstance {
    static xNoticeCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[xNoticeCenter alloc] initInstance];
    });
    return instance;
}

-(instancetype)initInstance{
    self = [super init];
    if (self) {
        _timerMap  = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
        _actionDic = [NSMutableDictionary dictionary];
        _bindQueue =  dispatch_queue_create([@"SystemManagerQueue" UTF8String], DISPATCH_QUEUE_CONCURRENT);
        _timer = [xTimer timerWithInterval:1*NSEC_PER_SEC leeway:0 queue:_bindQueue block:^{
            [self runTimerCallBack];
        }];
        [self registerSystemNotification];
    }
    return self;
}

-(instancetype)init {
    NSAssert(NO, @"请使用 sharedInstance 方法创建对象");
    return nil;
}


-(void)registerSystemNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}


-(void)setActionKey:(NSString *)actionKey key:(id)key block:(id)block {
    NSMapTable *mapTable = _actionDic[actionKey];
    if (!mapTable) {
        mapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableCopyIn];
        _actionDic[actionKey] = mapTable;
    }
    [mapTable setObject:block forKey:key];
}

-(void)runBlock:(NSString *)key param:(id)param {
    NSMapTable *mapTable = _actionDic[key];
    if (!mapTable) {
        return;
    }
    NSEnumerator *enumerator = [mapTable objectEnumerator];
    id obj;
    while ( obj = [enumerator nextObject] ) {
        if (param) {
            ( (void (^)(id)) obj)(param);
        }else {
            ( (void (^)()) obj)();
        }
    }
}


-(void)registerAppFinishLaunching:(id)lifeCycle block:(void(^)(NSDictionary*))block{
    dispatch_barrier_async(_bindQueue, ^{
        [self setActionKey:kSysAppFinishLaunching key:lifeCycle block:block];
    });
}

-(void)appFinishLaunching:(NSNotification*)notification{
    dispatch_async(_bindQueue, ^{
        [self runBlock:kSysAppFinishLaunching param:notification.userInfo];
    });
}

-(void)registerAppBecomeActive:(id)lifeCycle block:(void (^)())block {
    
    dispatch_barrier_async(_bindQueue, ^{
        [self setActionKey:kSysAppBecomeActive key:lifeCycle block:block];
    });
}

-(void)appBecomeActive {
    dispatch_async(_bindQueue, ^{
        [self.timer resume];
        [self runTimerCallBack];
        [self runBlock:kSysAppBecomeActive param:nil];
    });
}

-(void)registerAppWillResignActive:(id)lifeCycle block:(void (^)())block {
    dispatch_barrier_async(_bindQueue, ^{
        [self setActionKey:kSysAppWillResignActive key:lifeCycle block:block];
    });
}

-(void)appWillResignActive {
    dispatch_async(_bindQueue, ^{
        [self.timer suspend];
        [self runBlock:kSysAppWillResignActive param:nil];
    });
}

-(void)registerAppEnterBackground:(id)lifeCycle block:(void (^)())block {
    dispatch_barrier_async(_bindQueue, ^{
        [self setActionKey:kSysAppEnterBackground key:lifeCycle block:block];
    });
}

-(void)appEnterBackground {
    dispatch_async(_bindQueue, ^{
        [self.timer suspend];
        [self runBlock:kSysAppEnterBackground param:nil];
    });
}

-(void)registerAppWillTerminate:(id)lifeCycle block:(void (^)())block {
    dispatch_barrier_async(_bindQueue, ^{
        [self setActionKey:kSysAppWillTerminate key:lifeCycle block:block];
    });
}

-(void)appWillTerminate {
    dispatch_async(_bindQueue, ^{
        [self.timer suspend];
        [self runBlock:kSysAppWillTerminate param:nil];
    });
}

-(void)runTimerCallBack {
    NSMapTable *mapTable = _actionDic[kTimerRun];
    if (!mapTable) {
        [self.timer suspend];
        return;
    }
    if (mapTable.count <= 0) {
        [self.timer suspend];
        return;
    }
    [self runBlock:kTimerRun param:nil];
}

-(void)registerRunTimerAction:(id)liftCycle block:(void (^)())block {
    dispatch_barrier_async(_bindQueue, ^{
        [self setActionKey:kTimerRun key:liftCycle block:block];
        [self.timer resume];
    });
}

-(void)registerRunTimerAction:(id)liftCycle interval:(NSInteger)interval block:(void (^)())block {
    dispatch_barrier_async(_bindQueue, ^{
        xNoticeTime *time = [[xNoticeTime alloc] init];
        time.currentTime = 0;
        time.intervalTime = interval;
        time.callback = block;
        [self.timerMap setObject:time forKey:liftCycle];
        __weak typeof(time)weak = time;
        [self registerRunTimerAction:liftCycle block:^{
            weak.currentTime++;
            if (weak.currentTime >= weak.intervalTime) {
                weak.callback();
                weak.currentTime = 0;
            }
        }];
    });
}

@end



