//
//  UITabBarController+xStatis.m
//  xLibrary
//
//  Created by JSK on 2017/6/30.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "UITabBarController+xStatis.h"
#import "NSObject+xRuntime.h"
#import "NSObject+xStatis.h"
#import "xStatisStack.h"
#import "xStatisActionData.h"
#import "xStatisManager.h"


@implementation UITabBarController (xStatis)

+ (void) load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject x_exchangeInstanceMethodOfClass:[UITabBarController class] originalSelector:@selector(setSelectedViewController:) newSelector:@selector(xs_hook_SetSelectedViewController:)];
        [NSObject x_exchangeInstanceMethodOfClass:[UITabBarController class] originalSelector:@selector(setViewControllers:) newSelector:@selector(xs_hook_SetViewControllers:)];
    });
}

- (void) xs_hook_SetViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    UIViewController *vc = [viewControllers firstObject];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc topViewController];
    }
    [[xStatisStack sharedInstance] push:vc pageName:vc.xs_pageName clearStatck:YES isSystem:YES];
    
    //
    [self xs_hook_SetViewControllers:viewControllers];
}

- (void) xs_hook_SetSelectedViewController:(__kindof UIViewController *)selectedViewController
{
    //
    UIViewController *vc = selectedViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)selectedViewController topViewController];
    }
    [[xStatisStack sharedInstance] push:vc pageName:vc.xs_pageName clearStatck:YES isSystem:YES];
    
    //
    [self xs_hook_SetSelectedViewController:selectedViewController];
}

- (NSString *) xs_pageName
{
    return self.selectedViewController.xs_pageName;
}

- (NSString *) xs_pageId
{
    return self.selectedViewController.xs_pageId;
}

@end
