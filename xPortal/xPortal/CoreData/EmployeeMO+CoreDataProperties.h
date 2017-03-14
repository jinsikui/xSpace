//
//  EmployeeMO+CoreDataProperties.h
//  xPortal
//
//  Created by JSK on 2017/3/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "EmployeeMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface EmployeeMO (CoreDataProperties)

+ (NSFetchRequest<EmployeeMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *hireDate;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) DepartmentMO *department;
@property (nullable, nonatomic, retain) NSSet<EmployeeMO *> *managers;
@property (nullable, nonatomic, retain) NSSet<EmployeeMO *> *reporters;

@end

@interface EmployeeMO (CoreDataGeneratedAccessors)

- (void)addManagersObject:(EmployeeMO *)value;
- (void)removeManagersObject:(EmployeeMO *)value;
- (void)addManagers:(NSSet<EmployeeMO *> *)values;
- (void)removeManagers:(NSSet<EmployeeMO *> *)values;

- (void)addReportersObject:(EmployeeMO *)value;
- (void)removeReportersObject:(EmployeeMO *)value;
- (void)addReporters:(NSSet<EmployeeMO *> *)values;
- (void)removeReporters:(NSSet<EmployeeMO *> *)values;

@end

NS_ASSUME_NONNULL_END
