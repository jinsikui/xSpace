//
//  DepartmentMO+CoreDataProperties.h
//  xPortal
//
//  Created by JSK on 2017/3/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "DepartmentMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DepartmentMO (CoreDataProperties)

+ (NSFetchRequest<DepartmentMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) NSSet<EmployeeMO *> *employees;

@end

@interface DepartmentMO (CoreDataGeneratedAccessors)

- (void)addEmployeesObject:(EmployeeMO *)value;
- (void)removeEmployeesObject:(EmployeeMO *)value;
- (void)addEmployees:(NSSet<EmployeeMO *> *)values;
- (void)removeEmployees:(NSSet<EmployeeMO *> *)values;

@end

NS_ASSUME_NONNULL_END
