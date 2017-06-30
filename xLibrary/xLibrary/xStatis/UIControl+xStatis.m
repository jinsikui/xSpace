//
//  UIControl+xStatis.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "UIControl+xStatis.h"
#import "NSObject+xRuntime.h"
#import <objc/runtime.h>
#import "xStatisService.h"

@implementation UIControl (xStatis)

#pragma mark - 捕获事件源

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject x_exchangeInstanceMethodOfClass:[UIControl class] originalSelector:@selector(sendAction:to:forEvent:) newSelector:@selector(xs_hook_sendAction:to:forEvent:)];
    });
}

- (void)setPreviousTouch:(UITouch *)previousTouch {
    objc_setAssociatedObject(self, @selector(previousTouch), previousTouch, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITouch *)previousTouch {
    UITouch *touch = objc_getAssociatedObject(self, @selector(previousTouch));
    return touch;
}

- (void)xs_hook_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    NSSet *touches = [event touchesForView:self];
    //只关注点击事件
    if (touches.count == 1) {
        UITouch *touch = touches.anyObject;
        //因为同一个按钮点击可能添加了多个target&action，所以需要去重
        if (touch != self.previousTouch) {
            self.previousTouch = touch;
            [xStatisService sharedInstance].previousResponder = self;
        }
    }
    [self xs_hook_sendAction:action to:target forEvent:event];
}

@end
