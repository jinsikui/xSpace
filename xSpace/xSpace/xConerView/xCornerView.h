//
//  xCornerView.h
//  QTTourAppStore
//
//  Created by JSK on 2018/4/11.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 可以任意指定view的四个角中哪些需要圆角
 在autolayout的情况下，无法根据view的frame来设置layer.mask的尺寸，这个类通过覆盖draw(rect:)实现
 必须在view尺寸改变后调用setNeedsDisplay()方法来触发draw(rect:)
 **/
@interface xCornerView : UIView

@property(nonatomic) UIRectCorner corners;
@property(nonatomic) CGFloat radius;
@property(nonatomic) CGFloat borderWidth; //default is 0
@property(nonatomic) UIColor *borderColor; //default is clear color

-(instancetype)initWithCorners:(UIRectCorner)corners radius:(CGFloat)radius;

@end
