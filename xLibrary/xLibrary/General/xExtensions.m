//
//  xExtensions.m
//  xLibrary
//
//  Created by JSK on 2017/11/20.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xExtensions.h"

@implementation NSNull (JSON)

- (void) forwardInvocation:(NSInvocation *)invocation{
    if ([self respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *) methodSignatureForSelector:(SEL)selector{
    NSMethodSignature *signature = [[NSNull class] instanceMethodSignatureForSelector:selector];
    if(signature == nil) {
        signature = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }
    return signature;
}

- (NSUInteger) length{
    return 0;
}

- (NSUInteger) unsignedIntegerValue{
    return 0;
}

- (NSInteger) integerValue{
    return 0;
}

- (int) intValue{
    return 0;
}

- (float) floatValue{
    return 0;
}

- (NSString *) description{
    return @"";
}

- (NSArray *) componentsSeparatedByString:(NSString *)separator{
    return @[];
}

- (id) objectForKey:(id)key{
    return nil;
}

- (id) objectAtIndex:(NSUInteger)index{
    return nil;
}

- (BOOL)boolValue{
    return NO;
}

@end

@implementation UIImage (xExtension)

+(UIImage*)imageWithColor:(UIColor*)color rect:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage*)imageWithColor:(UIColor*)color height:(CGFloat)height{
    return [self imageWithColor:color rect:CGRectMake(0, 0, 1, height)];
}

+(UIImage*)imageWithShadowColor:(UIColor*)color{
    return [self imageWithColor:color rect:CGRectMake(0, 0, 1, 0.5)];
}

@end
