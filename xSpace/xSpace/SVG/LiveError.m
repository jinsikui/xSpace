//
//  LiveError.m
//  QTTourAppStore
//
//  Created by JSK on 2018/4/11.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "LiveError.h"

@implementation LiveError

+(instancetype)errorWithCode:(NSInteger)code msg:(NSString*)msg{
    LiveError *error = [[LiveError alloc] initWithCode:code msg:msg];
    return error;
}

-(instancetype)initWithCode:(NSInteger)code msg:(NSString*)msg{
    self = [super initWithDomain:LIVE_ERROR_DOMAIN code:code userInfo:nil];
    if(self){
        _msg = msg;
    }
    return self;
}
@end
