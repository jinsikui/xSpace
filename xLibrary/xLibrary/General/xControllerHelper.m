//
//  xControllerHelper.m
//  QTTourAppStore
//
//  Created by JSK on 2018/5/14.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "xControllerHelper.h"

@implementation xControllerHelper

+(UIViewController*)rootVC{
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+(UIViewController*)curVC{
    return [self _curVCFrom:[self rootVC]];
}

+(UIViewController*)_curVCFrom:(UIViewController*)rootVC{
    UIViewController *curVC = nil;
    UIViewController *presentedVC = rootVC.presentedViewController;
    if(presentedVC){
        rootVC = presentedVC;
    }
    if([rootVC isKindOfClass:[UITabBarController class]]){
        curVC = [self _curVCFrom:[(UITabBarController*)rootVC selectedViewController]];
    }
    else if([rootVC isKindOfClass:[UINavigationController class]]){
        curVC = [self _curVCFrom:[(UINavigationController*)rootVC visibleViewController]];
    }
    else{
        curVC = rootVC;
    }
    return curVC;
}

+(UINavigationController*)curNavVC{
    UIViewController *curVC = [self curVC];
    if(!curVC){
        return nil;
    }
    return curVC.navigationController;
}

@end
