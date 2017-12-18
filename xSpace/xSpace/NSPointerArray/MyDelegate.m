//
//  MyDelegate.m
//  xSpace
//
//  Created by JSK on 2017/12/7.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "MyDelegate.h"

@implementation MyDelegate

-(instancetype)initWithNum:(NSInteger)num{
    self = [super init];
    if(self == nil){
        return nil;
    }
    self.num = num;
    return self;
}

-(void)log:(NSString *)msg{
    NSLog(@"%@ %ld", msg, (long)self.num);
}

@end
