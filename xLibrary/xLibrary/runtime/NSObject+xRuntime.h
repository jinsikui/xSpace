//
//  NSObject+xRuntime.h
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (xRuntime)

+(void)x_exchangeInstanceMethodOfClass:(Class)clazz originalSelector:(SEL)originalSelector newSelector:(SEL)newSelector;

+(void)x_exchangeClassMethodOfClass:(Class)clazz originalSelector:(SEL)originalSelector newSelector:(SEL)newSelector;

-(void)x_exchangeInstanceMethod:(SEL)originalSelector newSelector:(SEL)newSelector;

-(void)x_exchangeClassMethod:(SEL)originalSelector newSelector:(SEL)newSelector;

@end
