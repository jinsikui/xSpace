//
//  DepartmentMO+CoreDataProperties.m
//  xPortal
//
//  Created by JSK on 2017/3/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "DepartmentMO+CoreDataProperties.h"

@implementation DepartmentMO (CoreDataProperties)

+ (NSFetchRequest<DepartmentMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Department"];
}

@dynamic title;
@dynamic employees;

@end
