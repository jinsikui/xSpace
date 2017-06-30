//
//  UINavigationViewController+xStatis.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "UINavigationController+xStatis.h"
#import "NSObject+xRuntime.h"
#import "NSObject+xStatis.h"
#import "xStatisStack.h"


@implementation UINavigationController (xStatis)

+ (void) load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject x_exchangeInstanceMethodOfClass:[UINavigationController class]
                       originalSelector:@selector(pushViewController:animated:)
                             newSelector:@selector(xs_hook_PushViewController:animated:)];
        
        [NSObject x_exchangeInstanceMethodOfClass:[UINavigationController class]
                       originalSelector:@selector(popViewControllerAnimated:)
                             newSelector:@selector(xs_hook_PopViewControllerAnimated:)];
        
        [NSObject  x_exchangeInstanceMethodOfClass:[UINavigationController class]
                        originalSelector:@selector(popToViewController:animated:)
                              newSelector:@selector(xs_hook_PopToViewController:animated:)];
        
        [NSObject x_exchangeInstanceMethodOfClass:[UINavigationController class]
                       originalSelector:@selector(popToRootViewControllerAnimated:)
                             newSelector:@selector(xs_hook_PopToRootViewControllerAnimated:)];
    });
}

- (UIViewController *)xs_hook_PopViewControllerAnimated:(BOOL)animated
{
    [[xStatisStack sharedInstance] popToSystem];
    return [self xs_hook_PopViewControllerAnimated:animated];
}

- (NSArray *)xs_hook_PopToRootViewControllerAnimated:(BOOL)animated
{
    [[xStatisStack sharedInstance] popToRoot];
    return [self xs_hook_PopToRootViewControllerAnimated:animated];
}

- (NSArray *)xs_hook_PopToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[xStatisStack sharedInstance] popToKey:viewController];
    return [self xs_hook_PopToViewController:viewController animated:animated];
}

- (void) xs_hook_PushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[xStatisStack sharedInstance] push:viewController pageName:viewController.xs_pageName clearStatck:NO isSystem:YES];
    [self xs_hook_PushViewController:viewController animated:animated];
}

- (NSString*)xs_pageName{
    return [self visibleViewController].xs_pageName;
}

- (NSString*)xs_pageId{
    return [self visibleViewController].xs_pageId;
}

@end
