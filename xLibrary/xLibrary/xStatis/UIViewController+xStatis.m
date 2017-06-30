//
//  UIViewController+xStatis.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "UIViewController+xStatis.h"
#import "NSObject+xRuntime.h"
#import "NSObject+xStatis.h"
#import "xStatisStack.h"

@implementation UIViewController (xStatis)

+ (void) load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject x_exchangeInstanceMethodOfClass:[UIViewController class]
                       originalSelector:@selector(presentViewController:animated:completion:)
                             newSelector:@selector(xs_hook_presentViewController:animated:completion:)];
        [NSObject x_exchangeInstanceMethodOfClass:[UIViewController class]
                       originalSelector:@selector(dismissViewControllerAnimated:completion:)
                             newSelector:@selector(xs_hook_dismissViewControllerAnimated:completion:)];
        [NSObject x_exchangeInstanceMethodOfClass:[UIViewController class]
                       originalSelector:@selector(init)
                             newSelector:@selector(xs_hook_init)];
        [NSObject x_exchangeInstanceMethodOfClass:[UIViewController class]
                       originalSelector:@selector(viewDidAppear:)
                             newSelector:@selector(xs_hook_viewDidAppear:)];
        [NSObject x_exchangeInstanceMethodOfClass:[UIViewController class]
                       originalSelector:@selector(viewDidDisappear:)
                             newSelector:@selector(xs_hook_viewDidDisappear:)];
    });
}

- (id) xs_hook_init
{
    UIViewController *object = [self xs_hook_init];
    //could do more thing...
    return object;
}

- (void) xs_hook_viewDidAppear:(BOOL)animated
{
    [self xs_hook_viewDidAppear:animated];
    //could do more thing...
}

- (void) xs_hook_viewDidDisappear:(BOOL)animated
{
    [self xs_hook_viewDidDisappear:animated];
    //could do more thing...
}

- (void) xs_hook_presentViewController:(UIViewController *)viewControllerToPresent
                          animated:(BOOL)flag
                        completion:(void (^)(void))completion
{
    UIViewController *vc = viewControllerToPresent;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc topViewController];
    }
    [[xStatisStack sharedInstance] push:vc pageName:vc.xs_pageName clearStatck:NO isSystem:YES];
    [self xs_hook_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void) xs_hook_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [[xStatisStack sharedInstance] popToSystem];
    [self xs_hook_dismissViewControllerAnimated:flag completion:completion];
}

@end
