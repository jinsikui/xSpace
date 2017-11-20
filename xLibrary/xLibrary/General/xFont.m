//
//  xFont.m
//  xLibrary
//
//  Created by JSK on 2017/11/19.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xFont.h"
#import "xDevice.h"

@implementation xFont

/*
 *  中文字体
 */
+(UIFont*)lightPFWithSize:(CGFloat)size{
    if(xDevice.iosVersion >= 9.0){
        return [UIFont fontWithName:@"PingFangSC-Light" size:size];
    }
    else if(xDevice.iosVersion >= 8.19 ){
        return [UIFont systemFontOfSize:size weight:UIFontWeightLight];
    }
    else{
        return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
    }
}

+(UIFont*)regularPFWithSize:(CGFloat)size{
    if(xDevice.iosVersion >= 9.0){
        return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }
    else if(xDevice.iosVersion >= 8.19 ){
        return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
    }
    else{
        return [UIFont fontWithName:@"HelveticaNeue" size:size];
    }
}

+(UIFont*)mediumPFWithSize:(CGFloat)size{
    if(xDevice.iosVersion >= 9.0){
        return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    }
    else if(xDevice.iosVersion >= 8.19 ){
        return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
    }
    else{
        return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
    }
}

+(UIFont*)semiboldPFWithSize:(CGFloat)size{
    if(xDevice.iosVersion >= 9.0){
        return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    }
    else if(xDevice.iosVersion >= 8.19 ){
        return [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
    }
    else{
        return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
    }
}

/*
 *  英文和数字字体
 */
+(UIFont*)boldWithSize:(CGFloat)size{
    if(xDevice.iosVersion >= 9.0){
        return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
    }
    else{
        return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
    }
}

+(UIFont*)regularWithSize:(CGFloat)size{
    if(xDevice.iosVersion >= 9.0){
        return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
    }
    else{
        return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
    }
}

+(UIFont*)lightWithSize:(CGFloat)size{
    if(xDevice.iosVersion >= 9.0){
        return [UIFont systemFontOfSize:size weight:UIFontWeightLight];
    }
    else{
        return [UIFont fontWithName:@"HelveticaNeue-Thin" size:size];
    }
}

@end
