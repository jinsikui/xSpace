//
//  xNotice.h
//  xLibrary
//
//  Created by JSK on 2017/11/18.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (xNotice)

@property(nonatomic,assign)BOOL x_notice_disable;

@end

@interface xNotice : NSObject

+(instancetype)shared;

-(void)registerAppFinishLaunching:(id)lifeIndicator action:(void(^)(id))action;

-(void)registerAppBecomeActive:(id)lifeIndicator action:(void (^)(id))action;

-(void)registerAppWillResignActive:(id)lifeIndicator action:(void (^)(id))action;

-(void)registerAppEnterBackground:(id)lifeIndicator action:(void (^)(id))action;

-(void)registerAppWillTerminate:(id)lifeIndicator action:(void (^)(id))action;

-(void)registerAppAudioSessionRouteChange:(id)lifeIndicator action:(void (^)(id))action;

-(void)registerTimerTicking:(id)lifeIndicator action:(void (^)(id))action;

-(void)registerTimer:(id)lifeIndicator intervalSeconds:(NSInteger)seconds action:(void (^)())action;

-(void)registerEvent:(NSString*)eventName lifeIndicator:(id)lifeIndicator action:(void (^)(id))action;

#pragma mark - post events

-(void)postEvent:(NSString*)eventName userInfo:(NSDictionary<NSString*, id>*)userInfo;

@end
