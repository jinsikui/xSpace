//
//  xABFileInput.m
//  xSpace
//
//  Created by JSK on 2018/12/24.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "xABFileInput.h"

@implementation xABFileInput

-(instancetype)initWithPath:(NSString*)path{
    self = [super init];
    if(self){
        self.path = path;
    }
    return self;
}

@end
