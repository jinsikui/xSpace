//
//  QTNetworkResponse.m
//  QTNetwork
//
//  Created by Leo on 2017/8/14.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTNetworkResponse.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

NSString * const QTNetworkErrorDomain = @"com.qt.network.error";

@interface QTNetworkResponse()

@property (strong, nonatomic, readwrite)NSData * originalData;

@property (strong, nonatomic, readwrite) id responseObject;

@property (strong, nonatomic, readwrite) NSURLResponse * urlResponse;

@property (strong, nonatomic, readwrite) NSError * error;

@property (strong, nonatomic, readwrite) NSURL * filePath;

@property (strong, nonatomic, readwrite) id <QTRequestConvertable> requestConvertable;

@property (assign, nonatomic, readwrite) QTNetworkResponseSource source;

@property (assign, nonatomic, readwrite) NSInteger statusCode;

@end

@implementation QTNetworkResponse

- (instancetype)initWithResponse:(QTNetworkResponse *)response udpatedError:(NSError *)error{
    if (self = [super init]) {
        self.originalData = response.originalData;
        self.responseObject = response.responseObject;
        self.urlResponse = response.urlResponse;
        self.error = error;
        self.filePath = response.filePath;
        self.source = response.source;
        self.statusCode = response.statusCode;
        self.requestConvertable = response.requestConvertable;
    }
    return self;
}

- (instancetype)initWithResponse:(QTNetworkResponse *)response adpatedObject:(id)object{
    if (self = [super init]) {
        self.originalData = response.originalData;
        self.responseObject = object;
        self.urlResponse = response.urlResponse;
        self.error = response.error;
        self.filePath = response.filePath;
        self.source = response.source;
        self.statusCode = response.statusCode;
        self.requestConvertable = response.requestConvertable;
    }
    return self;
}
- (instancetype)initWithRequest:(id<QTRequestConvertable>)request
                    urlResponse:(NSURLResponse *)urlResponse
                   responseData:(NSData *)data
                          error:(NSError *)error{
    return [self initWithRequest:request
                     urlResponse:urlResponse
                    responseData:data
                           error:error
                          source:QTNetworkResponseSourceURLLoadingSystem];
}

- (instancetype)initWithRequest:(id<QTRequestConvertable>)request
                    urlResponse:(NSURLResponse *)urlResponse
                       filePath:(NSURL *)filePath
                          error:(NSError *)error{
    return [self initWithRequest:request
                     urlResponse:urlResponse
                        filePath:filePath
                           error:error
                          source:QTNetworkResponseSourceURLLoadingSystem];
}

- (instancetype)initWithRequest:(id<QTRequestConvertable>)request
                    urlResponse:(NSURLResponse *)urlResponse
                       filePath:(NSURL *)filePath error:(NSError *)error
                         source:(QTNetworkResponseSource)source{
    if (self = [super init]) {
        self.filePath = filePath;
        self.urlResponse = urlResponse;
        self.requestConvertable = request;
        self.error = error;
        self.source = source;
        if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse * httpResp = (NSHTTPURLResponse *)urlResponse;
            self.statusCode = httpResp.statusCode;
        }
    }
    return self;
}

- (instancetype)initWithRequest:(id<QTRequestConvertable>)request
                    urlResponse:(NSURLResponse *)urlResponse
                   responseData:(NSData *)data
                          error:(NSError *)error
                         source:(QTNetworkResponseSource)source{
    if (self = [super init]) {
        self.originalData = data;
        self.urlResponse = urlResponse;
        self.requestConvertable = request;
        self.error = error;
        self.source = source;
        if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse * httpResp = (NSHTTPURLResponse *)urlResponse;
            self.statusCode = httpResp.statusCode;
        }
        [self decodeResponse];
        BOOL responseValid = YES;
        NSError * validError;
        if ([request respondsToSelector:@selector(responseValider)]) {
            id<QTNetworkResponseValider> valider = [request responseValider];
            responseValid = [valider validResponse:self.responseObject error:&validError];
        }
        if (!responseValid) {//验证失败
            if (!validError) {
                NSString * reason = [NSString stringWithFormat:@"Failed to valid the response with UnKnown error"];
                NSDictionary * userInfo = @{@"InvalidReason":reason};
                validError =   [NSError errorWithDomain:QTNetworkResponseValiderErrorDomain
                                                   code:-1
                                               userInfo:userInfo];
            }
            self.error = validError;
            self.responseObject = nil;
        }
    }
    return self;
}

- (instancetype)initStubResponseWithRequest:(id<QTRequestConvertable>)request data:(QTNetworkSub *)data{
    if (self = [super init]) {
        self.requestConvertable = request;
        self.error = nil;
        self.source = QTNetworkResponseSourceStub;
        self.originalData = data.sampleData;
        self.statusCode = data.statusCode;
        [self decodeResponse];
    }
    return self;
}
- (void)decodeResponse{
    QTResponseDecncoding decodeType = [self.requestConvertable respondsToSelector:@selector(decodingType)] ? [self.requestConvertable decodingType] : QTResponseDecncodingJSON;
    id<AFURLResponseSerialization> decoder;
    switch (decodeType) {
        case QTResponseDecncodingHTTP:
            decoder = [AFHTTPResponseSerializer serializer];
            break;
        case QTResponseDecncodingJSON:
            decoder = [AFJSONResponseSerializer serializer];
            break;
        case QTResponseDecncodingXML:
            decoder = [AFXMLParserResponseSerializer serializer];
            break;
        default:
            break;
    }
    NSError * error;
    self.responseObject = [decoder responseObjectForResponse:self.urlResponse
                                                        data:self.originalData
                                                       error:&error];
    if (error) {
        self.error = error;
    }
}
@end
