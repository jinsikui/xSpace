//
//  PersonMO+CoreDataProperties.h
//  xPortal
//
//  Created by JSK on 2017/3/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "PersonMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PersonMO (CoreDataProperties)

+ (NSFetchRequest<PersonMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<FriendInfoMO *> *beFriendedBy;
@property (nullable, nonatomic, retain) NSSet<FriendInfoMO *> *friends;

@end

@interface PersonMO (CoreDataGeneratedAccessors)

- (void)addBeFriendedByObject:(FriendInfoMO *)value;
- (void)removeBeFriendedByObject:(FriendInfoMO *)value;
- (void)addBeFriendedBy:(NSSet<FriendInfoMO *> *)values;
- (void)removeBeFriendedBy:(NSSet<FriendInfoMO *> *)values;

- (void)addFriendsObject:(FriendInfoMO *)value;
- (void)removeFriendsObject:(FriendInfoMO *)value;
- (void)addFriends:(NSSet<FriendInfoMO *> *)values;
- (void)removeFriends:(NSSet<FriendInfoMO *> *)values;

@end

NS_ASSUME_NONNULL_END
