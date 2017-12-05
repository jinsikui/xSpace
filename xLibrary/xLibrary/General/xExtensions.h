//
//  xExtensions.h
//  xLibrary
//
//  Created by JSK on 2017/11/20.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (JSON)

@end

@interface UIImage (xExtension)

+(UIImage*)imageWithColor:(UIColor*)color rect:(CGRect)rect;

+(UIImage*)imageWithColor:(UIColor*)color height:(CGFloat)height;

+(UIImage*)imageWithShadowColor:(UIColor*)color;

@end
