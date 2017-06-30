//
//  UIView+xStatis.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "UIView+xStatis.h"
#import <objc/runtime.h>
#import "xStatisService.h"
#import "NSObject+xRuntime.h"
#import "UITableView+xStatis.h"
#import "UICollectionView+xStatis.h"

@implementation UIView (xStatis)

#pragma mark - 捕获事件源

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject x_exchangeInstanceMethodOfClass:[UIView class] originalSelector:@selector(gestureRecognizerShouldBegin:) newSelector:@selector(xs_hook_gestureRecognizerShouldBegin:)];
    });
}

- (BOOL)xs_hook_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BOOL should = [self xs_hook_gestureRecognizerShouldBegin:gestureRecognizer];
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && should){
        [xStatisService sharedInstance].previousResponder = gestureRecognizer.view;
    }
    return should;
}

#pragma mark viewPath（xPath形式）

- (void)setXs_viewPath:(NSString *)viewPath {
    objc_setAssociatedObject(self, @selector(xs_viewPath), viewPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)xs_viewPath {
    NSString *viewPath = objc_getAssociatedObject(self, _cmd);
    if (viewPath && viewPath.length){
        return viewPath;
    }
    viewPath = [self queryViewPath];
    self.xs_viewPath = viewPath;
    return viewPath;
}

- (NSString *)queryViewPath {
    NSString *viewPath = @"";
    if ([self.nextResponder isKindOfClass:[UIViewController class]]) {
        //controller.view
        viewPath = NSStringFromClass([self.nextResponder class]);
    }else if ([self isKindOfClass:[UIWindow class]]){
        
        viewPath = NSStringFromClass([self class]);
    }else if ([self isKindOfClass:[UITableViewCell class]]){
        //cell indexPath代替视图深度
        NSIndexPath *index = ((UITableViewCell *)self).xs_indexPath;
        NSString *path = [NSString stringWithFormat:@"%@[%zd,%zd]",NSStringFromClass([self class]), index.section, index.row];
        viewPath = [NSString stringWithFormat:@"%@-%@",[self.superview queryViewPath], path];
        
    }else if ([self isKindOfClass:[UICollectionViewCell  class]]){
        //CollectionCell
        NSIndexPath *index = ((UICollectionViewCell *)self).xs_indexPath;
        NSString *path = [NSString stringWithFormat:@"%@[%zd,%zd]", NSStringFromClass([self class]), index.section, index.row];
        viewPath = [NSString stringWithFormat:@"%@-%@",[self.superview queryViewPath], path];
    }else {
        //
        NSString *path = [NSString stringWithFormat:@"%@[%zd]",NSStringFromClass([self class]), [self.superview.subviews indexOfObject:self]];
        viewPath = [NSString stringWithFormat:@"%@-%@",[self.superview queryViewPath], path];
    }
    return viewPath;
}

@end
