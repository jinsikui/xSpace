//
//  xDevice.h
//  xLibrary
//
//  Created by JSK on 2017/11/19.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xDevice : NSObject

+(CGFloat)screenWidth;

+(CGFloat)screenHeight;

+(CGFloat)statusBarHeight;

+(CGFloat)navBarHeight;

+(CGFloat)bottomBarHeight;

+(float)iosVersion;

+(NSString*)iosRawVersion;

+(NSString*)deviceName;

+(NSString*)deviceId;

+(BOOL)isIphoneX;

@end
