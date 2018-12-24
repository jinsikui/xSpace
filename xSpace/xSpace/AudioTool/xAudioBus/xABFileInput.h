//
//  xABFileInput.h
//  xSpace
//
//  Created by JSK on 2018/12/24.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xABFileInput : NSObject
@property(nonatomic) NSString *path;
-(instancetype)initWithPath:(NSString*)path;
@end
