//
//  EmployeeMO+CoreDataProperties.m
//  xPortal
//
//  Created by JSK on 2017/3/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "EmployeeMO+CoreDataProperties.h"

@implementation EmployeeMO (CoreDataProperties)

+ (NSFetchRequest<EmployeeMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
}

@dynamic hireDate;
@dynamic name;
@dynamic department;
@dynamic managers;
@dynamic reporters;

@end
