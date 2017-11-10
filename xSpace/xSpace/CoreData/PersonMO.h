//
//  PersonMO+CoreDataClass.h
//  xPortal
//
//  Created by JSK on 2017/3/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FriendInfoMO;

@interface PersonMO : NSManagedObject

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<FriendInfoMO *> *beFriendedBy;
@property (nullable, nonatomic, retain) NSSet<FriendInfoMO *> *friends;

@end
