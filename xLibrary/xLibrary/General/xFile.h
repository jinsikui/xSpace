//
//  xFile.h
//  QTTourAppStore
//
//  Created by JSK on 2018/4/9.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xFile : NSObject

+ (NSString *)documentPath:(NSString *)filename;

+ (NSString *)tmpPath:(NSString *)filename;

+ (NSString *)bundlePath:(NSString *)filename;

+ (NSString *)cachePath:(NSString *)filename;

+ (NSString *)appSupportPath:(NSString *)filename;

+ (BOOL)fileExistsAtPath:(NSString *)path;

+ (BOOL)folderExistsAtPath:(NSString *)path;

+ (BOOL)hasDocumentFile:(NSString*)filename;

+ (BOOL)hasCacheFile:(NSString*)filename;

+ (BOOL)hasAppSupportFile:(NSString*)filename;

+ (NSData*)getDataFromFileOfPath:(NSString*)path;

+ (NSData*)getDataFromFileUrl:(NSURL*)url;

+ (id)jsonDataToObject:(NSData*)data;

+ (id)jsonStrToObject:(NSString*)str;

+ (NSData*)objectToJsonData:(id)object;

+ (NSString*)objectToJsonStr:(id)object;

+ (NSData*)base64ToData:(NSString*)base64;

+ (NSString*)dataToBase64:(NSData*)data;

+ (NSString*)strToMD5:(NSString*)str;

+ (NSString*)dataToMD5:(NSData*)data;

+ (NSDictionary*)getDicFromFileOfPath:(NSString*)path;

+ (BOOL)saveData:(NSData*)data toPath:(NSString*)path;

+ (BOOL)saveDic:(NSDictionary*)dic toPath:(NSString*)path;

+ (BOOL)deleteFileOfPath:(NSString*)path;

+ (BOOL)createFolder:(NSString *)path;

+ (BOOL)deleteFolder:(NSString *)path;

+ (unsigned long long) folderSize:(NSString *)path;

+ (BOOL) removeFilesAtFolderPath:(NSString *)path;

@end
