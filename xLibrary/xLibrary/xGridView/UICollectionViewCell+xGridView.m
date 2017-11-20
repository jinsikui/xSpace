//
//  UICollectionViewCell+xGridView.m
//  xLibrary
//
//  Created by JSK on 2017/11/20.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "UICollectionViewCell+xGridView.h"
#import <objc/runtime.h>

@implementation UICollectionViewCell (xGridView)

-(void)setX_data:(id)data{
    objc_setAssociatedObject(self, @selector(x_data), data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)x_data{
    id data = objc_getAssociatedObject(self, _cmd);
    return data;
}

-(void)setX_indexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, @selector(x_indexPath), indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSIndexPath*)x_indexPath{
    NSIndexPath *indexPath = objc_getAssociatedObject(self, _cmd);
    return indexPath;
}

@end
