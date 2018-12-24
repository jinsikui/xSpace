//
//  xABPcmOutput.m
//  xSpace
//
//  Created by JSK on 2018/12/24.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "xABPcmOutput.h"

@implementation xABPcmOutput

-(instancetype)initWithPath:(NSString*)path isAppend:(BOOL)isAppend{
    self = [super init];
    if(self){
        self.path = path;
        self.isAppend = isAppend;
    }
    return self;
}

@end
