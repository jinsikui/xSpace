//
//  xViewFactory.h
//  xLibrary
//
//  Created by JSK on 2017/11/19.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface xViewFactory : NSObject

+(UILabel*)labelWithText:(NSString*)text font:(UIFont*)font color:(UIColor*)color;

+(UILabel*)labelWithText:(NSString*)text font:(UIFont*)font color:(UIColor*)color alignment:(NSTextAlignment)alignment;

//高度会自动计算
+(UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace underline:(BOOL)underline;

+(UIButton*)imageButton:(UIImage*)image;

+(UIButton*)buttonWithTitle:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor bgColor:(UIColor*)bgColor;

+(UIButton*)buttonWithTitle:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor bgColor:(UIColor*)bgColor cornerRadius:(CGFloat)cornerRadius;

+(UIButton*)buttonWithTitle:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor bgColor:(UIColor*)bgColor borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth;

+(UIButton*)buttonWithTitle:(NSString*)title font:(UIFont*)font titleColor:(UIColor*)titleColor bgColor:(UIColor*)bgColor cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth;

+(UIButton*)buttonWithTitle:(NSString*)title
                       font:(UIFont*)font
                 titleColor:(UIColor*)titleColor
                    bgColor:(UIColor*)bgColor
               cornerRadius:(CGFloat)cornerRadius
                borderColor:(UIColor*)borderColor
                borderWidth:(CGFloat)borderWidth
                      frame:(CGRect)frame;
@end
