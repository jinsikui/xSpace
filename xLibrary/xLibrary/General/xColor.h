//
//  xColor.h
//  xLibrary
//
//  Created by JSK on 2017/11/19.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface xColor : UIColor

+(UIColor*)fromRGB:(uint)rgbValue;

+(UIColor*)fromRGBA:(uint)rgbValue alpha:(CGFloat)alpha;

+(UIColor*)fromRGBAHexStr:(NSString*)rgbaHexStr;

+(UIColor*)fromHexStr:(NSString*)hexStr;

+(UIColor*)fromHexStr:(NSString*)hexStr alpha:(CGFloat)alpha;

+(UIColor*)from8bitR:(Byte)red G:(Byte)green B:(Byte)blue;

+(UIColor*)from8bitR:(Byte)red G:(Byte)green B:(Byte)blue alpha:(CGFloat)alpha;

@end
