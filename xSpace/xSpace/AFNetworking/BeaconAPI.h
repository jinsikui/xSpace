//
//  BeaconAPI.h
//  xSpace
//
//  Created by JSK on 2017/11/30.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconAPI:NSObject

@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) NSString *event;

@property(nonatomic, strong) NSMutableDictionary *commonParams;

@property(nonatomic, strong) NSMutableDictionary *params;

-(instancetype)initWithName:(NSString*)name event:(NSString*)event commonParams:(NSDictionary*)commonParams;

-(void)sendRequest;

+(void)send:(NSString*)name event:(NSString*)event params:(NSDictionary*)params commonParams:(NSDictionary*)commonParams;

@end
