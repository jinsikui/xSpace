//
//  FriendInfoMO+CoreDataProperties.h
//  xPortal
//
//  Created by JSK on 2017/3/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "FriendInfoMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FriendInfoMO (CoreDataProperties)

+ (NSFetchRequest<FriendInfoMO *> *)fetchRequest;

@property (nullable, nonatomic, retain) PersonMO *setAsFriend;
@property (nullable, nonatomic, retain) PersonMO *source;

@end

NS_ASSUME_NONNULL_END
