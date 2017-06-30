//
//  UITableViewCell+xStatis.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "UITableView+xStatis.h"
#import "NSObject+xRuntime.h"
#import "xStatisService.h"
#import <objc/runtime.h>

@implementation  UITableView (xStatis)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject x_exchangeInstanceMethodOfClass:[UITableView class] originalSelector:@selector(setDelegate:) newSelector:@selector(xs_hook_setDelegate:)];
        [NSObject x_exchangeInstanceMethodOfClass:[UITableView class] originalSelector:@selector(setDataSource:) newSelector:@selector(xs_hook_setDataSource:)];
    });
}

-(void)xs_hook_setDelegate:(id<UITableViewDelegate>) delegate{
    [self xs_hook_setDelegate:delegate];
    //
    if([delegate isKindOfClass:[NSObject class]]){
        SEL selector = @selector(tableView:didSelectRowAtIndexPath:);
        if(![delegate respondsToSelector:selector]){
            return;
        }
        xStatisService *service = [xStatisService sharedInstance];
        if([service hasHookedSelector:selector inClass:[delegate class]]){
            return;
        }
        //给delegate添加方法
        SEL hookSelector = @selector(xs_hook_tableView:didSelectRowAtIndexPath:);
        Method hookMethod = class_getInstanceMethod([self class], hookSelector);
        IMP hookImp = method_getImplementation(hookMethod);
        class_addMethod([delegate class], hookSelector, hookImp, method_getTypeEncoding(hookMethod));
        //交换delegate方法
        [service exchangeOnceInstanceMethodOfClass:[delegate class] originalSelector:selector newSelector:hookSelector];
    }
}

-(void)xs_hook_setDataSource:(id<UITableViewDataSource>) dataSource{
    [self xs_hook_setDataSource:dataSource];
    if([dataSource isKindOfClass:[NSObject class]]){
        SEL selector = @selector(tableView:cellForRowAtIndexPath:);
        xStatisService *service = [xStatisService sharedInstance];
        if([service hasHookedSelector:selector inClass:[dataSource class]]){
            return;
        }
        //给dataSource添加方法
        SEL hookSelector = @selector(xs_hook_tableView:cellForRowAtIndexPath:);
        Method hookMethod = class_getInstanceMethod([self class], hookSelector);
        IMP hookImp = method_getImplementation(hookMethod);
        class_addMethod([dataSource class], hookSelector, hookImp, method_getTypeEncoding(hookMethod));
        //交换dataSource方法
        [service exchangeOnceInstanceMethodOfClass:[dataSource class] originalSelector:selector newSelector:hookSelector];
    }
}

//此方法要加入到UITableViewDataSource中，所以self指向UITableViewDataSource实例
-(UITableViewCell*)xs_hook_tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell *cell = [self xs_hook_tableView:tableView cellForRowAtIndexPath:indexPath];
    if(cell){
        cell.xs_indexPath = indexPath;
    }
    return cell;
}

//此方法要加入到UITableViewDelegate中，所以self指向UITableViewDelegate实例
-(void)xs_hook_tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [xStatisService sharedInstance].previousResponder = cell;
    //
    [self xs_hook_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end

@implementation  UITableViewCell (xStatis)

-(void)setXs_indexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, @selector(xs_indexPath), indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSIndexPath*)xs_indexPath{
    NSIndexPath *indexPath = objc_getAssociatedObject(self, _cmd);
    return indexPath;
}

@end
