//
//  MyDelegate.h
//  xSpace
//
//  Created by JSK on 2017/12/7.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogDelegate.h"

@interface MyDelegate : NSObject<LogDelegate>

-(instancetype)initWithNum:(NSInteger)num;

@property(nonatomic,assign) NSInteger num;

@end
