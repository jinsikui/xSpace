//
//  EmployeeMO+CoreDataClass.h
//  xPortal
//
//  Created by JSK on 2017/3/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DepartmentMO;

@interface EmployeeMO : NSManagedObject

@property (nullable, nonatomic, copy) NSDate *hireDate;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) DepartmentMO *department;
@property (nullable, nonatomic, retain) NSSet<EmployeeMO *> *managers;
@property (nullable, nonatomic, retain) NSSet<EmployeeMO *> *reporters;

@end
