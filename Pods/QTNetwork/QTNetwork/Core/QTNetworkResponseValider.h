//
//  QTNetworkJSONValider.h
//  QTNetwork
//
//  Created by Leo on 2017/8/17.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const QTNetworkResponseValiderErrorDomain;

@protocol QTNetworkResponseValider<NSObject>

- (BOOL)validResponse:(id)json error:(NSError **)error;


@end

/**
 对JSON的Schema进行验证
 */
@interface QTJSONSchemaValider : NSObject <QTNetworkResponseValider>

/**
 对JSON Array进行验证，

 @param scheme JSON的Scheme
 */
+ (instancetype)arrayValiderWithScheme:(NSArray *)scheme;

/**
 对JSON Object进行验证，
 
 @param scheme JSON的Scheme
 */
+ (instancetype)objectValiderWithScheme:(NSDictionary *)scheme;

@end
