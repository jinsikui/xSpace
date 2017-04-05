//
//  Employee.h
//  xPortal
//
//  Created by JSK on 2017/4/5.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject

@property(nonatomic, assign) NSInteger  Id;
@property(nonatomic, strong) NSString   *name;
@property(nonatomic, assign) NSInteger  fk_department_id;

@end
