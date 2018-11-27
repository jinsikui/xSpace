//
//  xDevice.m
//  xLibrary
//
//  Created by JSK on 2017/11/19.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xDevice.h"
#import <sys/utsname.h>

static float _iosVersion = -1;
static CGFloat _screenWidth = -1;
static CGFloat _screenHeight = -1;
static NSString *_deviceId = nil;
static NSString *_bundleId = nil;

@implementation xDevice

+(CGFloat)screenWidth{
    if(_screenWidth < 0){
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return _screenWidth;
}

+(CGFloat)screenHeight{
    if(_screenHeight < 0){
        _screenHeight = [UIScreen mainScreen].bounds.size.height;
    }
    return _screenHeight;
}

+(CGFloat)statusBarHeight{
    //[[UIApplication sharedApplication] statusBarFrame].size.height
    if([self isIphoneX]){
        return 44;
    }
    return 20;
}

+(CGFloat)navBarHeight{
    //navigationController.navigationBar.frame.size.height
    return 44;
}

+(CGFloat)bottomBarHeight{
    if([self isIphoneX]){
        return 34;
    }
    return 0;
}

+(float)iosVersion{
    if(_iosVersion < 0){
        NSString *str = [UIDevice currentDevice].systemVersion;
        //convert like "10.3.1" -> "10.3"
        NSRange range = NSMakeRange(0,str.length);
        NSRange found;
        NSInteger foundCount = 0;
        while (range.location < str.length) {
            found = [str rangeOfString:@"." options:0 range:range];
            if (found.location != NSNotFound) {
                foundCount += 1;
                if(foundCount == 2){
                    str = [str substringToIndex:found.location];
                    break;
                }
                range.location = found.location + found.length;
                range.length = str.length - range.location;
            } else {
                // no more substring to find
                break;
            }
        }
        _iosVersion = str.floatValue;
    }
    return _iosVersion;
}

+(NSString*)iosRawVersion{
    return [UIDevice currentDevice].systemVersion;
}

+(NSString*)deviceName{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+(NSString*)deviceId{
    if(_deviceId == nil){
        _deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    }
    return _deviceId;
}

+(NSString*)bundleId{
    if(_bundleId == nil){
        _bundleId = [[NSBundle mainBundle] bundleIdentifier];
    }
    return _bundleId;
}

+(BOOL)isIphoneX{
    return [self screenWidth] == 375.f && [self screenHeight] == 812.f;
}

@end
