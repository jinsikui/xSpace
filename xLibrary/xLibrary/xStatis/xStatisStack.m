//
//  xStatisStack.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xStatisStack.h"
#import "NSObject+xStatis.h"

@interface xStatisStackData()
@property (nonatomic, assign) BOOL isSystem;
@end

@implementation xStatisStackData
- (NSString *) description{
    return [NSString stringWithFormat:@"stack - pageName : %@, refPageName : %@, isSystem: %d", self.pageName, self.refPageName, self.isSystem];
}
@end


@interface xStatisStack(){
    BOOL stackInit_;
}

@property (nonatomic, strong) NSMutableArray *stacks;

@end

@implementation xStatisStack

+(instancetype)sharedInstance{
    static xStatisStack *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if(self){
        _stacks = [NSMutableArray array];
    }
    return self;
}

- (xStatisStackData *)topData{
    @synchronized (self) {
        return [_stacks lastObject];
    }
}

- (void) insertStack:(id)key
          clearStack:(BOOL)clear
            isSystem:(BOOL)isSystem
{
    //
    if (!stackInit_ && [key isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController *)key;
        if ([viewController.navigationController.viewControllers count] == 0) {
            return;
        }
    }
    
    //
    @synchronized (self) {
        //
        stackInit_ = YES;
        //
        xStatisStackData *stackData1 = [self.stacks lastObject];
        if (stackData1.key == key) {
            return;
        }
        
        //
        xStatisStackData *stackData = [[xStatisStackData alloc] init];
        stackData.pageId = ((NSObject*)key).xs_pageId;
        stackData.pageName = ((NSObject*)key).xs_pageName;
        
        //
        stackData.refPageId = stackData1.pageId;
        stackData.refPageName = stackData1.pageName;
        
        //
        stackData.key = key;
        
        //
        stackData.isSystem = isSystem;
        
        //
        if (clear) {
            [self.stacks removeAllObjects];
        }
        [self.stacks addObject:stackData];
    }
}

- (void) push:(id)key pageName:(NSString *)pageName{
    [self push:key pageName:pageName clearStatck:NO];
}

- (void) push:(id)key pageName:(NSString *)pageName clearStatck:(BOOL)clearStack{
    [self push:key pageName:pageName clearStatck:clearStack isSystem:NO];
}

- (void) push:(id)key pageName:(NSString *)pageName clearStatck:(BOOL)clearStack isSystem:(BOOL)isSystem{
    ((NSObject*)key).xs_pageName = pageName;
    [self insertStack:key clearStack:clearStack isSystem:isSystem];
}

- (void) pop{
    @synchronized (self) {
        [_stacks removeLastObject];
    }
}

- (void) pop:(id)key{
    @synchronized (self) {
        xStatisStackData *data = [_stacks lastObject];
        if(data.key != key){
            return;
        }
        [_stacks removeLastObject];
    }
}

- (void) popToSystem{
    @synchronized (self) {
        NSMutableArray *needRemoveDatas = [NSMutableArray array];
        for (NSInteger i = [self.stacks count] - 1; i >= 0; i--) {
            xStatisStackData *data = [self.stacks objectAtIndex:i];
            if (data.isSystem) {
                [needRemoveDatas addObject:data];
                break;
            }
            [needRemoveDatas addObject:data];
        }
        //
        [self.stacks removeObjectsInArray:needRemoveDatas];
    }
}

- (void) popToKey:(id)key{
    @synchronized (self) {
        //
        NSMutableArray *needRemoveDatas = [NSMutableArray array];
        for (NSInteger i = [self.stacks count] - 1; i >= 0; i--) {
            xStatisStackData *data = [self.stacks objectAtIndex:i];
            if (data.key == key) {
                break;
            }
            [needRemoveDatas addObject:data];
        }
        //
        [self.stacks removeObjectsInArray:needRemoveDatas];
    }
}

- (void) popToRoot{
    @synchronized (self) {
        xStatisStackData *data = [self.stacks firstObject];
        [self.stacks removeAllObjects];
        [self.stacks addObject:data];
    }
}

@end
