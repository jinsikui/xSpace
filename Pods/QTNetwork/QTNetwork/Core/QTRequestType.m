//
//  QTHTTPRequestType.m
//  QTNetwork
//
//  Created by Leo on 2017/8/14.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTRequestType.h"

@interface QTRequestTypeUpload()

@property (assign, nonatomic, readwrite) BOOL isMultiPartFormData;

@property (copy, nonatomic, readwrite)void (^constructingBodyBlock)(id <AFMultipartFormData> formData);

@property (strong, nonatomic, readwrite) NSURL * fileURL;

@property (strong, nonatomic, readwrite) NSData * data;

@end

@implementation QTRequestTypeUpload

- (instancetype)initWithFileURL:(NSURL *)fileURL{
    if (self = [super init]) {
        self.fileURL = fileURL;
        self.isMultiPartFormData = NO;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data{
    if (self = [super init]) {
        self.data = data;
        self.isMultiPartFormData = NO;
    }
    return self;
}
@end

@interface QTRequestTypeDownlaod()

@property (strong, nonatomic, readwrite) NSData * resumeData;

@property (strong, nonatomic, readwrite) QTNetworkResponseDownlaodDestination destionation;

@end

@implementation QTRequestTypeDownlaod

- (instancetype)initWithResumeData:(NSData *)data destionation:(QTNetworkResponseDownlaodDestination)destionation{
    if (self = [super init]) {
        self.resumeData = data;
        self.destionation = destionation;
    }
    return self;
}

@end

@implementation QTRequestType

+ (instancetype)data{
    return [[QTRequestType alloc] init];
}

+ (instancetype)uploadFromData:(NSData *)data{
    return (QTRequestType *)[[QTRequestTypeUpload alloc] initWithData:data];
}

+ (instancetype)uploadFromFileURL:(NSURL *)fileURL{
    return (QTRequestType *)[[QTRequestTypeUpload alloc] initWithFileURL:fileURL];
}

+ (instancetype)downlaodWithDestination:(QTNetworkResponseDownlaodDestination)destination{
    return (QTRequestType *)[[QTRequestTypeDownlaod alloc] initWithResumeData:nil
                                                                 destionation:destination];
}

+ (instancetype)downloadWithResumeData:(NSData *)resumeData destination:(QTNetworkResponseDownlaodDestination)destination{
    return (QTRequestType *)[[QTRequestTypeDownlaod alloc] initWithResumeData:resumeData
                                                                 destionation:destination];
}


+ (instancetype)uploadWithMultipartFormConstructingBodyBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block{
    QTRequestTypeUpload * type =  [[QTRequestTypeUpload alloc] init];
    type.constructingBodyBlock = block;
    type.isMultiPartFormData = YES;
    return type;
}
@end

