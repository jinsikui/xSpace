//
//  xExtensions.m
//  xLibrary
//
//  Created by JSK on 2017/11/20.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xExtensions.h"
#import "YYText.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation NSData (xExtension)

-(NSString*)x_MD5{
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(self.bytes, (CC_LONG)self.length, md5Buffer);
//    NSData *data = [NSData dataWithBytes:md5Buffer length:CC_MD5_DIGEST_LENGTH];
//    return [xFile dataToBase64:data];
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];

    return output;
}

@end

@implementation NSDate (xExtension)

-(NSString*)x_toString:(NSString*)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

@end

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

-(BOOL)x_startWith:(NSString*)str{
    NSRange range = [self rangeOfString:str options:NSLiteralSearch];
    return range.location == 0;
}

-(BOOL)x_endWith:(NSString*)str{
    NSRange range = [self rangeOfString:str options:NSLiteralSearch | NSBackwardsSearch];
    return range.location == self.length - str.length;
}

-(NSData*)x_hmacSha1ByKey:(NSString*)key{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [self cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    return HMAC;
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

- (NSUInteger) count{
    return 0;
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

-(UIImage*)scaleToSize:(CGSize)size{
    CGRect rect = CGRectMake(0,0,size.width,size.height);
    UIGraphicsBeginImageContext( rect.size );
    [self drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *img=[UIImage imageWithData:imageData];
    return img;
}

-(UIImage*)scale:(CGFloat)scale{
    CGSize size = CGSizeMake(self.size.width*scale, self.size.height*scale);
    return [self scaleToSize:size];
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

- (NSMutableArray *)preffixArrayOfCount:(NSInteger)count{
    if(count < 0){
        return nil;
    }
    NSMutableArray *result =[NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count && i < self.count; i++) {
        [result addObject:[self objectAtIndex:i]];
    }
    return result;
}

- (NSMutableArray *)suffixArrayOfCount:(NSInteger)count{
    if(count < 0){
        return nil;
    }
    NSMutableArray *result =[NSMutableArray arrayWithCapacity:count];
    long i = self.count - count;
    i = i < 0 ? 0 : i;
    for (; i < self.count; i++) {
        [result addObject:[self objectAtIndex:i]];
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

@implementation NSAttributedString (xExtension)
    
-(CGSize)x_sizeWithMaxWidth:(CGFloat)maxWidth{
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(maxWidth, CGFLOAT_MAX) text:self];
    return layout.textBoundingSize;
}
    
-(CGFloat)qt_heightWithMaxWidth:(CGFloat)maxWidth{
    CGSize size = [self x_sizeWithMaxWidth:maxWidth];
    return size.height;
}

@end

@implementation NSMutableAttributedString (xExtension)

-(NSMutableAttributedString*) x_appendImgWithUrl:(NSString*)url size:(CGSize)size alignToFont:(UIFont*)font{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    CGRect f = imageView.frame;
    f.size = size;
    imageView.frame = f;
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    NSMutableAttributedString *imgAttr = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [self appendAttributedString:imgAttr];
    return self;
}
    
-(NSMutableAttributedString*) x_appendView:(UIView*)view alignToFont:(UIFont*)font{
    NSMutableAttributedString *attr = [NSMutableAttributedString yy_attachmentStringWithContent:view contentMode:UIViewContentModeCenter attachmentSize:view.bounds.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [self appendAttributedString:attr];
    return self;
}
    
-(NSMutableAttributedString*) x_appendImgNamed:(NSString*)imgName alignToFont:(UIFont*)font{
    UIImage *img = [UIImage imageNamed:imgName];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = img;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    CGRect f = imageView.frame;
    f.size = img.size;
    imageView.frame = f;
    NSMutableAttributedString *imgAttr = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:img.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [self appendAttributedString:imgAttr];
    return self;
}

-(NSMutableAttributedString*) x_appendImgNamed:(NSString*)imgName size:(CGSize)size alignToFont:(UIFont*)font{
    UIImage *img = [UIImage imageNamed:imgName];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = img;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    CGRect f = imageView.frame;
    f.size = size;
    imageView.frame = f;
    NSMutableAttributedString *imgAttr = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:img.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [self appendAttributedString:imgAttr];
    return self;
}

-(NSMutableAttributedString*) x_appendImgNamed:(NSString*)imgName scale:(CGFloat)scale alignToFont:(UIFont*)font{
    UIImage *img = [UIImage imageNamed:imgName];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = img;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    CGRect f = imageView.frame;
    f.size = CGSizeMake(img.size.width*scale,img.size.height*scale);
    imageView.frame = f;
    NSMutableAttributedString *imgAttr = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:img.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [self appendAttributedString:imgAttr];
    return self;
}
    
-(NSMutableAttributedString*) x_appendStr:(NSString*)str foreColor:(UIColor*)foreColor font:(UIFont*)font underline:(BOOL)underline baselineOffset:(CGFloat)baselineOffset{
        
    NSMutableDictionary<NSAttributedStringKey, id> *attributes = [[NSMutableDictionary alloc] initWithDictionary:
                                                                  @{ NSForegroundColorAttributeName: foreColor,
                                                                                NSFontAttributeName: font }];
    if(underline) {
        attributes[NSUnderlineStyleAttributeName] = @(1);
    }
    if(baselineOffset != 0) {
        attributes[NSBaselineOffsetAttributeName] = @(baselineOffset);
    }
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    [self appendAttributedString:attr];
    return self;
}

-(NSMutableAttributedString*) x_appendStr:(NSString*)str foreColor:(UIColor*)foreColor font:(UIFont*)font{
    return [self x_appendStr:str foreColor:foreColor font:font underline:NO baselineOffset:0];
}
    
+(NSMutableAttributedString*) x_attrStr:(NSString*)str foreColor:(UIColor*)foreColor font:(UIFont*)font{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str attributes:
                                                @{NSForegroundColorAttributeName: foreColor,
                                                             NSFontAttributeName: font}];
    return attr;
}
@end

@implementation UITableView (xExtension)
    
-(void)scrollToTopAnimated:(BOOL)animated{
    if([self numberOfRowsInSection:0] > 0){
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
    else{
        [self scrollToOffset:CGPointZero animated:animated];
    }
}

-(void)scrollToOffset:(CGPoint)offset animated:(BOOL)animated {
    [self setContentOffset:offset animated:animated];
}
    
-(void)scrollToBottomAnimated:(BOOL)animated{
    long rowCount = [self numberOfRowsInSection:0];
    if(rowCount > 0){
        if(rowCount >= 2){
            [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowCount - 2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}
@end

@implementation UICollectionViewCell (xExtension)

-(NSIndexPath*)x_indexPath{
    NSIndexPath *indexPath = objc_getAssociatedObject(self, _cmd);
    return indexPath;
}

-(void)setX_indexPath:(NSIndexPath *)x_indexPath{
    objc_setAssociatedObject(self, @selector(x_indexPath), x_indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)x_data{
    id data = objc_getAssociatedObject(self, _cmd);
    return data;
}

-(void)setX_data:(id)x_data{
    objc_setAssociatedObject(self, @selector(x_data), x_data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UITableViewCell (xExtension)

-(NSIndexPath*)x_indexPath{
    NSIndexPath *indexPath = objc_getAssociatedObject(self, _cmd);
    return indexPath;
}

-(void)setX_indexPath:(NSIndexPath *)x_indexPath{
    objc_setAssociatedObject(self, @selector(x_indexPath), x_indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)x_data{
    id data = objc_getAssociatedObject(self, _cmd);
    return data;
}

-(void)setX_data:(id)x_data{
    objc_setAssociatedObject(self, @selector(x_data), x_data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
