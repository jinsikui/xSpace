//
//  xUrlHelper.m
//  QTTourAppStore
//
//  Created by JSK on 2018/10/26.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "xUrlHelper.h"

@implementation xUrlHelper

+(NSString*)urlEncode:(NSString*)input{
    NSString *outputStr =
    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes
                                  (kCFAllocatorDefault, (CFStringRef)input,
                                   NULL, (CFStringRef)@"!*'();:@&=+$/?%#[]",
                                   kCFStringEncodingUTF8)
                                  );
    return outputStr;
}

+(NSString*)addToInput:(NSString*)input queryParams:(NSDictionary*)params{
    if (params.count == 0 || !input) {
        return input;
    }
    NSURLComponents * components = [NSURLComponents componentsWithString:input];
    NSMutableArray * queryItems = [[NSMutableArray alloc] initWithArray:components.queryItems ?: @[]];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSURLQueryItem * item = [NSURLQueryItem queryItemWithName:[self urlEncode:key] value:[self urlEncode:obj]];
        [queryItems addObject:item];
    }];
    components.queryItems = queryItems;
    return components.string;
}

@end
