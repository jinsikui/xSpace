//
//  xExtensions.h
//  xLibrary
//
//  Created by JSK on 2017/11/20.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (xExtension)

-(CGSize)x_sizeWithFont:(UIFont*)font;

-(CGSize)x_sizeWithFont:(UIFont*)font maxWidth:(CGFloat)maxWidth;

@end

@interface NSNull (JSON)

@end

@interface UIImage (xExtension)

+(UIImage*)imageWithColor:(UIColor*)color rect:(CGRect)rect;

+(UIImage*)imageWithColor:(UIColor*)color height:(CGFloat)height;

+(UIImage*)imageWithShadowColor:(UIColor*)color;

@end

@interface NSArray<ObjectType> (xOperations)

- (NSArray<ObjectType> *)filter:(BOOL(^)(ObjectType item))predicate;

- (NSArray *)map:(id(^)(ObjectType item))selector;

- (NSArray *)mapWithIndex:(id(^)(ObjectType item,NSInteger idx))selector;

- (ObjectType)first:(BOOL(^)(ObjectType item))predicate;

- (NSArray<ObjectType> *)reverse;

- (BOOL)all:(BOOL(^)(ObjectType item))predicate;

- (BOOL)any:(BOOL(^)(ObjectType item))predicate;

- (void)each:(void(^)(ObjectType item))action;

- (void)eachWithIndex:(void(^)(ObjectType item,NSInteger idx))action;

// first index of.
- (NSInteger)indexOf:(BOOL(^)(ObjectType item))predicate;

@end
