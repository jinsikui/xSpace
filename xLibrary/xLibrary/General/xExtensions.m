//
//  xExtensions.m
//  xLibrary
//
//  Created by JSK on 2017/11/20.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xExtensions.h"

@implementation NSString (xExtension)

-(CGSize)x_sizeWithFont:(UIFont*)font{
    CGSize size = [self x_sizeWithFont:font maxWidth:CGFLOAT_MAX];
    return CGSizeMake(size.width + 1, size.height);
}

-(CGSize)x_sizeWithFont:(UIFont*)font maxWidth:(CGFloat)maxWidth{
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName: font}];
    CGSize size = [attr boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return size;
}

@end

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

@implementation NSArray (xOperations)

- (NSArray *)filter:(BOOL (^)(id))predicate {
    if (!predicate) return self;
    NSMutableArray *result = [NSMutableArray array];
    for (id item in self) {
        if (predicate(item)) {
            [result addObject:item];
        }
    }
    return result;
}

- (NSArray *)map:(id (^)(id))selector {
    if (!selector) return self;
    // Capacity:avoid size change.
    NSMutableArray *result =[NSMutableArray arrayWithCapacity:self.count];
    for (id item in self) {
        id mapResult = selector(item);
        if (mapResult) [result addObject:mapResult];
    }
    return result;
}

- (NSArray *)mapWithIndex:(id (^)(id, NSInteger))selector {
    if (!selector) return self;
    // Capacity:avoid size change.
    NSMutableArray *result =[NSMutableArray arrayWithCapacity:self.count];
    for (int i = 0; i < self.count; i++) {
        id mapResult = selector([self objectAtIndex:i],i);
        if (mapResult) [result addObject:mapResult];
    }
    return result;
}

- (id)first:(BOOL (^)(id))predicate {
    if (!predicate) return self.firstObject;
    for (id item in self) {
        if (predicate(item)) {
            return item;
        }
    }
    return nil;
}

- (NSArray *)reverse {
    return [self reverseObjectEnumerator].allObjects;
}

- (BOOL)all:(BOOL (^)(id))predicate {
    if (!predicate) return NO;
    for (id item in self) {
        if (!predicate(item)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)any:(BOOL (^)(id))predicate {
    if (!predicate) return NO;
    for (id item in self) {
        if(predicate(item)) {
            return YES;
        }
    }
    return NO;
}

- (void)each:(void (^)(id))action {
    if (!action) return;
    for (id item in self) {
        action(item);
    }
}

- (void)eachWithIndex:(void (^)(id, NSInteger))action {
    if (!action) return;
    for (int i = 0; i < self.count; i++) {
        id item = [self objectAtIndex:i];
        action(item,i);
    }
}

- (NSInteger)indexOf:(BOOL (^)(id))predicate {
    if (!predicate) return NSNotFound;
    for (NSInteger i = 0; i < self.count; i++) {
        id item = self[i];
        if (predicate(item)) return i;
    }
    return NSNotFound;
}

@end



