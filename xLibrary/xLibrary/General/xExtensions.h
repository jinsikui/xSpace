//
//  xExtensions.h
//  xLibrary
//
//  Created by JSK on 2017/11/20.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (xExtension)

-(NSString*)x_MD5;

@end

@interface NSDate (xExtension)

-(NSString*)x_toString:(NSString*)format;

@end

@interface NSString (xExtension)

-(CGSize)x_sizeWithFont:(UIFont*)font;

-(CGSize)x_sizeWithFont:(UIFont*)font maxWidth:(CGFloat)maxWidth;

-(BOOL)x_startWith:(NSString*)str;

-(BOOL)x_endWith:(NSString*)str;

-(NSData*)x_hmacSha1ByKey:(NSString*)key;

@end

@interface NSNull (JSON)

@end

@interface UIImage (xExtension)

+(UIImage*)imageWithColor:(UIColor*)color rect:(CGRect)rect;

+(UIImage*)imageWithColor:(UIColor*)color height:(CGFloat)height;

+(UIImage*)imageWithShadowColor:(UIColor*)color;

-(UIImage*)scaleToSize:(CGSize)size;

-(UIImage*)scale:(CGFloat)scale;

@end

@interface NSArray<ObjectType> (xOperations)

- (NSArray<ObjectType> *)filter:(BOOL(^)(ObjectType item))predicate;

- (NSArray *)map:(id(^)(ObjectType item))selector;

- (NSArray *)mapWithIndex:(id(^)(ObjectType item,NSInteger idx))selector;

- (ObjectType)first:(BOOL(^)(ObjectType item))predicate;

- (NSMutableArray<ObjectType> *)preffixArrayOfCount:(NSInteger)count;

- (NSMutableArray<ObjectType> *)suffixArrayOfCount:(NSInteger)count;

- (NSArray<ObjectType> *)reverse;

- (BOOL)all:(BOOL(^)(ObjectType item))predicate;

- (BOOL)any:(BOOL(^)(ObjectType item))predicate;

- (void)each:(void(^)(ObjectType item))action;

- (void)eachWithIndex:(void(^)(ObjectType item,NSInteger idx))action;

// first index of.
- (NSInteger)indexOf:(BOOL(^)(ObjectType item))predicate;

@end

@interface NSAttributedString (xExtension)

-(CGSize)x_sizeWithMaxWidth:(CGFloat)maxWidth;

-(CGFloat)qt_heightWithMaxWidth:(CGFloat)maxWidth;

@end

@interface NSMutableAttributedString (xExtension)

-(NSMutableAttributedString*) x_appendImgWithUrl:(NSString*)url size:(CGSize)size alignToFont:(UIFont*)font;

-(NSMutableAttributedString*) x_appendView:(UIView*)view alignToFont:(UIFont*)font;

-(NSMutableAttributedString*) x_appendImgNamed:(NSString*)imgName alignToFont:(UIFont*)font;

-(NSMutableAttributedString*) x_appendImgNamed:(NSString*)imgName size:(CGSize)size alignToFont:(UIFont*)font;

-(NSMutableAttributedString*) x_appendImgNamed:(NSString*)imgName scale:(CGFloat)scale alignToFont:(UIFont*)font;

-(NSMutableAttributedString*) x_appendStr:(NSString*)str foreColor:(UIColor*)foreColor font:(UIFont*)font underline:(BOOL)underline baselineOffset:(CGFloat)baselineOffset;

-(NSMutableAttributedString*) x_appendStr:(NSString*)str foreColor:(UIColor*)foreColor font:(UIFont*)font;

+(NSMutableAttributedString*) x_attrStr:(NSString*)str foreColor:(UIColor*)foreColor font:(UIFont*)font;
@end

@interface UITableView (xExtension)

-(void)scrollToTopAnimated:(BOOL)animated;

-(void)scrollToOffset:(CGPoint)offset animated:(BOOL)animated;

-(void)scrollToBottomAnimated:(BOOL)animated;

@end

@interface UICollectionViewCell (xExtension)

@property(nonatomic) NSIndexPath *x_indexPath;

@property(nonatomic) id x_data;

@end

@interface UITableViewCell (xExtension)

@property(nonatomic) NSIndexPath *x_indexPath;

@property(nonatomic) id x_data;

@end
