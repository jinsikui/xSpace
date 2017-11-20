//
//  xExtensions.m
//  xLibrary
//
//  Created by JSK on 2017/11/20.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xExtensions.h"

@implementation UIImage (xExtension)

+(UIImage*)imageWithColor:(UIColor*)color rect:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage*)imageWithColor:(UIColor*)color height:(CGFloat)height{
    return [self imageWithColor:color rect:CGRectMake(0, 0, 1, height)];
}

+(UIImage*)imageWithShadowColor:(UIColor*)color{
    return [self imageWithColor:color rect:CGRectMake(0, 0, 1, 0.5)];
}

@end
