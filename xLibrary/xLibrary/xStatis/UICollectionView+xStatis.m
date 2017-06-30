//
//  UICollectionViewCell+xStatis.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "UICollectionView+xStatis.h"
#import <objc/runtime.h>
#import "NSObject+xRuntime.h"
#import "xStatisService.h"


@implementation  UICollectionView (xStatis)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject x_exchangeInstanceMethodOfClass:[UICollectionView class] originalSelector:@selector(setDelegate:) newSelector:@selector(xs_hook_setDelegate:)];
        [NSObject x_exchangeInstanceMethodOfClass:[UICollectionView class] originalSelector:@selector(setDataSource:) newSelector:@selector(xs_hook_setDataSource:)];
    });
}

-(void)xs_hook_setDelegate:(id<UICollectionViewDelegate>) delegate{
    [self xs_hook_setDelegate:delegate];
    //
    if([delegate isKindOfClass:[NSObject class]]){
        SEL selector = @selector(collectionView:didSelectItemAtIndexPath:);
        if(![delegate respondsToSelector:selector]){
            return;
        }
        xStatisService *service = [xStatisService sharedInstance];
        if([service hasHookedSelector:selector inClass:[delegate class]]){
            return;
        }
        //给delegate添加方法
        SEL hookSelector = @selector(xs_hook_collectionView:didSelectItemAtIndexPath:);
        Method hookMethod = class_getInstanceMethod([self class], hookSelector);
        IMP hookImp = method_getImplementation(hookMethod);
        class_addMethod([delegate class], hookSelector, hookImp, method_getTypeEncoding(hookMethod));
        //交换delegate方法
        [service exchangeOnceInstanceMethodOfClass:[delegate class] originalSelector:selector newSelector:hookSelector];
    }
}

-(void)xs_hook_setDataSource:(id<UICollectionViewDataSource>) dataSource{
    [self xs_hook_setDataSource:dataSource];
    if([dataSource isKindOfClass:[NSObject class]]){
        SEL selector = @selector(collectionView:cellForItemAtIndexPath:);
        xStatisService *service = [xStatisService sharedInstance];
        if([service hasHookedSelector:selector inClass:[dataSource class]]){
            return;
        }
        //给dataSource添加方法
        SEL hookSelector = @selector(xs_hook_collectionView:cellForItemAtIndexPath:);
        Method hookMethod = class_getInstanceMethod([self class], hookSelector);
        IMP hookImp = method_getImplementation(hookMethod);
        class_addMethod([dataSource class], hookSelector, hookImp, method_getTypeEncoding(hookMethod));
        //交换dataSource方法
        [service exchangeOnceInstanceMethodOfClass:[dataSource class] originalSelector:selector newSelector:hookSelector];
    }
}

//此方法要加入到UICollectionViewDataSource中，所以self指向UICollectionViewDataSource实例
-(UICollectionViewCell*)xs_hook_collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath{
    UICollectionViewCell *cell = [self xs_hook_collectionView:collectionView cellForItemAtIndexPath:indexPath];
    if(cell){
        cell.xs_indexPath = indexPath;
    }
    return cell;
}

//此方法要加入到UICollectionViewDelegate中，所以self指向UICollectionViewDelegate实例
-(void)xs_hook_collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [xStatisService sharedInstance].previousResponder = cell;
    //
    [self xs_hook_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

@end


@implementation UICollectionViewCell (xStatis)

-(void)setXs_indexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, @selector(xs_indexPath), indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSIndexPath*)xs_indexPath{
    NSIndexPath *indexPath = objc_getAssociatedObject(self, _cmd);
    return indexPath;
}

@end
