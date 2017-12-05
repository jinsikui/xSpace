//
//  BeaconAPI.m
//  xSpace
//
//  Created by JSK on 2017/11/30.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "BeaconAPI.h"
#import "AFNetworking.h"

@implementation BeaconAPI

-(instancetype)initWithName:(NSString*)name event:(NSString*)event commonParams:(NSDictionary*)commonParams{
    self = [super init];
    if(!self)
        return nil;
    self.name = name;
    self.event = event;
    self.params = [[NSMutableDictionary alloc] init];
    self.commonParams = [[NSMutableDictionary alloc] initWithDictionary:commonParams];
    return self;
}

-(void)sendRequest{
    NSMutableString *url = [[NSMutableString alloc] initWithString: @"http://b.zhibo.qingting.fm/v1/b.gif?"];
    [url appendFormat:@"b=%@&e=%@", self.name, self.event];
    for(id key in _params.allKeys){
        [url appendFormat:@"&%@=%@",key, _params[key]];
    }
    UInt64 time = [[NSDate date] timeIntervalSince1970]*1000;
    _commonParams[@"ts"] = [NSString stringWithFormat:@"%llu", time];
    for(id key in _commonParams.allKeys){
        [url appendFormat:@"&%@=%@",key, _commonParams[key]];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil success:nil failure:nil];
}

+(void)send:(NSString*)name event:(NSString*)event params:(NSDictionary*)params commonParams:(NSDictionary*)commonParams{
    BeaconAPI *b = [[BeaconAPI alloc] initWithName:name event:event commonParams:commonParams];
    [b.params setValuesForKeysWithDictionary:params];
    [b sendRequest];
}

@end
