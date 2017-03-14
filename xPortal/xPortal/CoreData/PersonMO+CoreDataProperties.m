//
//  PersonMO+CoreDataProperties.m
//  xPortal
//
//  Created by JSK on 2017/3/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "PersonMO+CoreDataProperties.h"

@implementation PersonMO (CoreDataProperties)

+ (NSFetchRequest<PersonMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic name;
@dynamic beFriendedBy;
@dynamic friends;

@end
