//
//  xStatisService.h
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "xStatisActionData.h"

@interface xStatisService : NSObject

+(instancetype)sharedInstance;

@property(nonatomic, strong) UIView *previousResponder;

- (BOOL)hasHookedSelector:(SEL)selector inClass:(Class)clazz;

- (void)exchangeOnceInstanceMethodOfClass:(Class)clazz originalSelector:(SEL)originalSelector newSelector:(SEL)newSelector;


@end
