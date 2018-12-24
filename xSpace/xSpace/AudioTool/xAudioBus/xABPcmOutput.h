//
//  xABPcmOutput.h
//  xSpace
//
//  Created by JSK on 2018/12/24.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xABPcmOutput : NSObject
@property(nonatomic) NSString *path;
@property(nonatomic) BOOL isAppend;
-(instancetype)initWithPath:(NSString*)path isAppend:(BOOL)isAppend;
@end
