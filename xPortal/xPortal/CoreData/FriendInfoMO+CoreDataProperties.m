//
//  FriendInfoMO+CoreDataProperties.m
//  xPortal
//
//  Created by JSK on 2017/3/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "FriendInfoMO+CoreDataProperties.h"

@implementation FriendInfoMO (CoreDataProperties)

+ (NSFetchRequest<FriendInfoMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FriendInfo"];
}

@dynamic setAsFriend;
@dynamic source;

@end
