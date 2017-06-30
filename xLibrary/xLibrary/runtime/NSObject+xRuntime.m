//
//  NSObject+xRuntime.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "NSObject+xRuntime.h"
#import <objc/runtime.h>

@implementation NSObject (xRuntime)

+(void)x_exchangeInstanceMethodOfClass:(Class)clazz originalSelector:(SEL)originalSelector newSelector:(SEL)newSelector{
    method_exchangeImplementations(class_getInstanceMethod(clazz, originalSelector), class_getInstanceMethod(clazz,newSelector));
}

+(void)x_exchangeClassMethodOfClass:(Class)clazz originalSelector:(SEL)originalSelector newSelector:(SEL)newSelector{
    method_exchangeImplementations(class_getClassMethod(clazz, originalSelector), class_getClassMethod(clazz, newSelector));
}

-(void)x_exchangeInstanceMethod:(SEL)originalSelector newSelector:(SEL)newSelector{
    Class clazz = [self class];
    [NSObject x_exchangeInstanceMethodOfClass:clazz originalSelector:originalSelector newSelector:newSelector];
}

-(void)x_exchangeClassMethod:(SEL)originalSelector newSelector:(SEL)newSelector{
    Class clazz = [self class];
    [NSObject x_exchangeClassMethodOfClass:clazz originalSelector:originalSelector newSelector:newSelector];
}

@end
