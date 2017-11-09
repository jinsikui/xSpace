//
//  TestAPI.m
//  QTNetwork
//
//  Created by JSK on 2017/11/9.
//Copyright © 2017年 QT. All rights reserved.
//

#import "TestAPI.h"

@interface TestAPI()

@end

@implementation TestAPI

#pragma mark - QTNetwork Reqeust

-(instancetype)initWithId:(NSString*)Id{
    self = [super init];
    if(!self){
        return nil;
    }
    self.Id = Id;
    return self;
}

- (NSString *)baseURL{
    return @"http://api.zhibo.qingting.fm";
}

- (NSString *)path{
    return [NSString stringWithFormat:@"/v2/rooms/%@/entry", self.Id];
}

- (QTHTTPMethod)httpMethod{
    return HTTP_GET;
}

- (NSDictionary *)parameters{
    //GET & Delete 会被作为Query添加到path中，POST & PUT会被添加到Body中
    return nil;
}

#pragma mark - QTNetwork Response

- (Class)classTypeForResponse{
    return [NSDictionary class];
}

- (QTNetworkResponse *)adaptResponse:(QTNetworkResponse *)networkResponse{
    if (networkResponse.error) {//出错了
        return [[QTNetworkResponse alloc] initWithResponse:networkResponse adpatedObject:nil];
    }
    NSDictionary * responseObject = networkResponse.responseObject[@"ret"];
    //进行responseObject到最后TestAPIResult的数据映射
    return [[QTNetworkResponse alloc] initWithResponse:networkResponse adpatedObject:responseObject];
}

@end

