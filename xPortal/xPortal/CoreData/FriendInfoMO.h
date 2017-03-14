//
//  FriendInfoMO+CoreDataClass.h
//  xPortal
//
//  Created by JSK on 2017/3/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PersonMO;

@interface FriendInfoMO : NSManagedObject

@property (nullable, nonatomic, retain) PersonMO *source;
@property (nullable, nonatomic, retain) PersonMO *setAsFriend;

@end
