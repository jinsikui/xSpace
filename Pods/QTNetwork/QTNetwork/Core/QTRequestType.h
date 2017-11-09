//
//  QTHTTPRequestType.h
//  QTNetwork
//
//  Created by Leo on 2017/8/14.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFMultipartFormData;

NS_ASSUME_NONNULL_BEGIN

typedef NSURL *_Nonnull(^QTNetworkResponseDownlaodDestination)(NSURL *targetPath, NSURLResponse *response);

/**
 标示请求的类型
 */
@interface QTRequestType : NSObject

/**
 拉数据到内存
 */
+ (instancetype)data;

/**
 上传文件
 */
+ (instancetype)uploadFromFileURL:(NSURL *)fileURL;

/**
 MultipartForm类型的Upload
 */
+ (instancetype)uploadWithMultipartFormConstructingBodyBlock:(void (^)(id <AFMultipartFormData> formData))block;
/**
  上传NSData
 */
+ (instancetype)uploadFromData:(NSData *)data;


/**
 下载到路径，要在QTNetworkResponseDownlaodDestination代码块中返回想要存储文件的URL地址
 */
+ (instancetype)downlaodWithDestination:(QTNetworkResponseDownlaodDestination)destination;


/**
 断点续传，要在QTNetworkResponseDownlaodDestination代码块中返回想要存储文件的URL地址
 */
+ (instancetype)downloadWithResumeData:(NSData *)resumeData
                           destination:(QTNetworkResponseDownlaodDestination)destination;


@end

@interface QTRequestTypeUpload : QTRequestType

@property (strong, nonatomic, readonly) NSURL * fileURL;

@property (strong, nonatomic, readonly) NSData * data;

@property (copy, nonatomic, readonly)void (^constructingBodyBlock)(id <AFMultipartFormData> formData);

@property (assign, nonatomic, readonly) BOOL isMultiPartFormData;

@end

@interface QTRequestTypeDownlaod : QTRequestType

@property (strong, nonatomic, readonly) NSData * resumeData;

@property (strong, nonatomic, readonly) QTNetworkResponseDownlaodDestination destionation;

@end


NS_ASSUME_NONNULL_END
