//
//  CoreDataManager.h
//  xLibrary
//
//  Created by JSK on 2017/3/13.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject
{
    NSManagedObjectContext  *context_;
}

@property (nonatomic, readonly) NSManagedObjectContext *context;

+ (CoreDataManager *) sharedInstance;

- (id) initWithDBName:(NSString *)name;

- (NSManagedObject*) objectForInsert:(NSString*)entityName;

- (void) addObject:(NSManagedObject *)obj;

- (void) removeObject:(NSManagedObject *)obj;

- (void) removeObjectsForEntity:(NSString *)name predicate:(NSPredicate *)predicate;

- (void) save;

- (NSArray *)executeResultByPredicate:(NSPredicate *)predicate
                                limit:(NSInteger)limit
                               offset:(NSInteger)offset
                           entityName:(NSString *)name
                        descriptorKey:(NSString *)key
                            ascending:(BOOL)ascending;
/*!
 *  @brief  获取单列非重复数据
 */
- (NSArray *)getDistinctResults:(NSString *)entityName
                      predicate:(NSPredicate *)predicate
                         column:(NSString *)col
                          limit:(NSInteger)limit
                         offset:(NSInteger)offset
                  descriptorKey:(NSString *)key
                      ascending:(BOOL)ascending
                     resultType:(NSFetchRequestResultType)type;

- (NSUInteger)getCountForEntity:(NSString *)name predicate:(NSPredicate *)predicate;

@end
