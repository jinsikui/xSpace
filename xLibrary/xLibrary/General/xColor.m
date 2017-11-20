//
//  xColor.m
//  xLibrary
//
//  Created by JSK on 2017/11/19.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xColor.h"

@implementation xColor

+(UIColor*)fromRGB:(uint)rgbValue{
    return [self fromRGBA:rgbValue alpha:1];
}

+(UIColor*)fromRGBA:(uint)rgbValue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0
                            blue:((CGFloat)(rgbValue & 0x0000FF))/255.0
                           alpha:alpha];
}

+(UIColor*)fromHexStr:(NSString*)hexStr{
    return [self fromHexStr:hexStr alpha:1];
}

+(UIColor*)fromHexStr:(NSString*)hexStr alpha:(CGFloat)alpha{
    // Check for hash and add the missing hash
    if('#' != [hexStr characterAtIndex:0])
    {
        hexStr = [NSString stringWithFormat:@"#%@", hexStr];
    }
    
    // check for string length
    assert(7 == hexStr.length || 4 == hexStr.length);
    
    // check for 3 character hexStrs
    hexStr = [[self class] hexStrFrom3Chars:hexStr];
    
    NSString *redHex    = [NSString stringWithFormat:@"0x%@", [hexStr substringWithRange:NSMakeRange(1, 2)]];
    NSInteger redInt = [self hexValueToUnsigned:redHex];
    
    NSString *greenHex  = [NSString stringWithFormat:@"0x%@", [hexStr substringWithRange:NSMakeRange(3, 2)]];
    NSInteger greenInt = [self hexValueToUnsigned:greenHex];
    
    NSString *blueHex   = [NSString stringWithFormat:@"0x%@", [hexStr substringWithRange:NSMakeRange(5, 2)]];
    NSInteger blueInt = [self hexValueToUnsigned:blueHex];
    
    UIColor *color = [self from8bitR:redInt G:greenInt B:blueInt alpha:alpha];
    
    return color;
}

+ (NSString *)hexStrFrom3Chars:(NSString *)hexStr
{
    if(hexStr.length == 4)
    {
        hexStr = [NSString stringWithFormat:@"#%@%@%@%@%@%@",
                     [hexStr substringWithRange:NSMakeRange(1, 1)],[hexStr substringWithRange:NSMakeRange(1, 1)],
                     [hexStr substringWithRange:NSMakeRange(2, 1)],[hexStr substringWithRange:NSMakeRange(2, 1)],
                     [hexStr substringWithRange:NSMakeRange(3, 1)],[hexStr substringWithRange:NSMakeRange(3, 1)]];
    }
    return hexStr;
}

+ (NSInteger)hexValueToUnsigned:(NSString *)hexValue
{
    unsigned value = 0;
    NSScanner *hexValueScanner = [NSScanner scannerWithString:hexValue];
    [hexValueScanner scanHexInt:&value];
    return (NSInteger)value;
}

+(UIColor*)from8bitR:(Byte)red G:(Byte)green B:(Byte)blue{
    return [self from8bitR:red G:green B:blue alpha:1];
}

+(UIColor*)from8bitR:(Byte)red G:(Byte)green B:(Byte)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((CGFloat)red)/255.0
                           green:((CGFloat)green)/255.0
                            blue:((CGFloat)blue)/255.0
                           alpha:alpha];
}

@end
