//
//  xDevice.m
//  xLibrary
//
//  Created by JSK on 2017/11/19.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xDevice.h"

static float _iosVersion = -1;
static CGFloat _screenWidth = -1;
static CGFloat _screenHeight = -1;
static NSString *_deviceId = nil;

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
    return 20;
}

+(CGFloat)navBarHeight{
    //navigationController.navigationBar.frame.size.height
    return 44;
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

+(NSString*)deviceId{
    if(_deviceId == nil){
        _deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    }
    return _deviceId;
}

@end
