//
//  xNoticeCenter.h
//  xLibrary
//
//  Created by JSK on 2017/8/3.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xNoticeCenter : NSObject

+(instancetype)sharedInstance;

// 后台切换至前台操作  block生命周期同lifeCycle
-(void)registerAppBecomeActive:(id)lifeCycle block:(void(^)())block;
// 前台进入后台操作
-(void)registerAppEnterBackground:(id)lifeCycle block:(void(^)())block;
// 程序将要结束进程操作
-(void)registerAppWillTerminate:(id)lifeCycle block:(void (^)())block;
// 程序将要停止活动操作
-(void)registerAppWillResignActive:(id)lifeCycle block:(void (^)())block;
// 程序定时器 1s为单位
-(void)registerRunTimerAction:(id)liftCycle  block:(void(^)())block;
// 程序定时器 interval 秒为单位
-(void)registerRunTimerAction:(id)liftCycle interval:(NSInteger)interval  block:(void(^)())block;

@end

