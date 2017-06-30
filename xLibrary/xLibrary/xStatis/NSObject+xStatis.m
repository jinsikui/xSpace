//
//  NSObject+xStatis.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "NSObject+xStatis.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

@implementation NSObject (xStatis)

-(NSString*)xs_pageId{
    NSString* pageId = objc_getAssociatedObject(self, _cmd);
    if(!pageId){
        pageId = [self generatePageId];
        [self setXs_pageId:pageId];
    }
    return pageId;
}

-(void)setXs_pageId:(NSString *)xs_pageId{
    objc_setAssociatedObject(self, @selector(xs_pageId), xs_pageId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)xs_pageName{
    NSString* pageName = objc_getAssociatedObject(self, _cmd);
    if(!pageName){
        pageName = NSStringFromClass([self class]);
        [self setXs_pageId:pageName];
    }
    return pageName;
}

-(void)setXs_pageName:(NSString *)pageName{
    objc_setAssociatedObject(self, @selector(xs_pageName), pageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)generatePageId{
    //
    NSString *s = [[NSUUID UUID] UUIDString];
    
    //generate md5
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    const char *str = [data bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)[data length], result);
    //
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return hash;
}

@end
