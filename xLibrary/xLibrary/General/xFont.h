//
//  xFont.h
//  xLibrary
//
//  Created by JSK on 2017/11/19.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface xFont : NSObject
/*
 *  中文字体
 */
+(UIFont*)lightPFWithSize:(CGFloat)size;

+(UIFont*)regularPFWithSize:(CGFloat)size;

+(UIFont*)mediumPFWithSize:(CGFloat)size;

+(UIFont*)semiboldPFWithSize:(CGFloat)size;

/*
 *  英文和数字字体
 */
+(UIFont*)boldWithSize:(CGFloat)size;

+(UIFont*)regularWithSize:(CGFloat)size;

+(UIFont*)lightWithSize:(CGFloat)size;
@end
