//
//  LiveExtensions.m
//  QTTourAppStore
//
//  Created by JSK on 2018/4/11.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "LiveExtensions.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

@implementation UIImageView (LiveExtension)

-(void)qt_showAvatar:(NSString*)url width:(CGFloat)width {
    self.layer.cornerRadius = width / 2;
    self.clipsToBounds = YES;
    UIImage *placeholder = [UIImage imageNamed:@"avatar-placeholder"];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}

-(void)qt_showImage:(NSString*)url {
    [self sd_setImageWithURL:[NSURL URLWithString:url]];
}
@end

@implementation NSObject (LiveExtension)

-(void)setQt_initialized:(BOOL)qt_initialized{
    objc_setAssociatedObject(self, @selector(qt_initialized), @(qt_initialized), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)qt_initialized{
    NSNumber *value = objc_getAssociatedObject(self, _cmd);
    if(!value){
        [self setQt_initialized:NO];
        return NO;
    }
    else{
        return [value boolValue];
    }
}

@end

@implementation NSNull (LiveExtension)

-(NSDate*)lv_toDate{
    return nil;
}

@end

@implementation NSString (LiveExtension)

-(NSDate*)lv_toDate{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    f.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *date = [f dateFromString:self];
    return date;
}

@end
