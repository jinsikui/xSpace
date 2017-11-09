//
//  QTNetworkAdapter.m
//  QTNetwork
//
//  Created by Leo on 2017/8/14.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTNetworkAdapter.h"
#import "QTNetworkRequest.h"

@implementation QTNetworkRequestDefaultAdapter

- (void)adaptRequestConvertable:(id<QTRequestConvertable>)requestConvertable
                       complete:(void (^)(QTNetworkRequest * ,NSError *  error))complete{
    NSError * error;
    QTNetworkRequest * request = [[QTNetworkRequest alloc]
                                  initWithRequestConvertable:requestConvertable
                                  error:&error];
    complete(request,error);
}

+ (instancetype)adapter{
    return [[QTNetworkRequestDefaultAdapter alloc] init];
}
@end


@implementation QTNetworkURLDefaultAdapter

+ (instancetype)adapter{
    return [[QTNetworkURLDefaultAdapter alloc] init];
}
- (void)adaptRequest:(QTNetworkRequest * )requset
            complete:(void(^)(NSURLRequest *  request,NSError * error))complete{
    NSURLRequest * urlRequest = requset.urlRequest;
    complete(urlRequest,nil);
}

@end
