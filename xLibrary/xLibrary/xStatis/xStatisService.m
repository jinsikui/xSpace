//
//  xStatisService.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xStatisService.h"
#import "NSObject+xRuntime.h"

@interface xStatisService()

@property(nonatomic, strong) NSMutableSet *hookKeySet;

@end

@implementation xStatisService

+(instancetype)sharedInstance{
    static xStatisService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hookKeySet = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - exchange method once

- (NSString *)createHookKeyWithClass:(Class)clazz andSelector:(SEL)selector {
    return [NSString stringWithFormat:@"%@-%@", NSStringFromClass(clazz), NSStringFromSelector(selector)];
}

- (BOOL)hasHookedSelector:(SEL)selector inClass:(Class)clazz {
    NSString *hookKey = [self createHookKeyWithClass:clazz andSelector:selector];
    BOOL hasHooked = [_hookKeySet containsObject:hookKey];
    return hasHooked;
}

- (void)exchangeOnceInstanceMethodOfClass:(Class)clazz originalSelector:(SEL)originalSelector newSelector:(SEL)newSelector {
    BOOL hasHooked = [self hasHookedSelector:originalSelector inClass:clazz];
    if (!hasHooked) {
        [_hookKeySet addObject:[self createHookKeyWithClass:clazz andSelector:originalSelector]];
        [NSObject x_exchangeInstanceMethodOfClass:clazz originalSelector:originalSelector newSelector:newSelector];
    }
}

@end
