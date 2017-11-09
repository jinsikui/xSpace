//
//  QTNetworkSub.m
//  QTNetwork
//
//  Created by Leo on 2017/8/14.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTNetworkSub.h"

@interface QTNetworkSub ()

@property (nonatomic, strong, readwrite) NSData * sampleData;

@property (nonatomic, assign, readwrite) NSInteger statusCode;

@property (nonatomic, assign, readwrite) NSTimeInterval delay;

@property (nonatomic, assign, readwrite) NSString * filePath;

@end


@implementation QTNetworkSub

- (instancetype)initWithSampleData:(NSData *)sampleData statusCode:(NSInteger)statusCode delay:(NSTimeInterval)delay{
    if (self = [super init]) {
        self.sampleData = sampleData;
        self.statusCode = statusCode;
        self.delay = delay;
    }
    return self;
}

- (instancetype)initWithSampleFilePath:(NSString *)filePath statusCode:(NSInteger)statusCode delay:(NSTimeInterval)delay{
    if (self = [super init]) {
        self.filePath = filePath;
        self.statusCode = statusCode;
        self.delay = delay;
    }
    return self;
}
- (instancetype)initWithJson:(id)json statisCode:(NSInteger)statusCode delay:(NSTimeInterval)delay{
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:nil];
    if (!jsonData) {
        return nil;
    }
    return [self initWithSampleData:jsonData statusCode:statusCode delay:delay];
}
@end
