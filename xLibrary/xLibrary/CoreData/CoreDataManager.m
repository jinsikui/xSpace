//
//  CoreDataManager.m
//  xLibrary
//
//  Created by JSK on 2017/3/13.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "CoreDataManager.h"

static CoreDataManager *_manager = nil;

@implementation CoreDataManager

@synthesize context = context_;

+ (void) initialize
{
    _manager = [[CoreDataManager alloc] initWithDBName:@"DataModel.sqlite"];
}

+ (CoreDataManager *) sharedInstance
{
    return _manager;
}

- (id) initWithDBName:(NSString *)name
{
    self = [super init];
    if (self) {
        
        NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                              inDomains:NSUserDomainMask] lastObject]
                                            URLByAppendingPathComponent:name];

        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        NSError *error = nil;
        NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error];
        if (!store)
        {
            NSLog(@"addPersistentStoreWithType error:%@, userInfo:%@", error, [error userInfo]);
            abort();
        }
        context_ = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [context_ setPersistentStoreCoordinator:coordinator];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(save)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(save)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    
    return self;
}

- (NSManagedObject*) objectForInsert:(NSString*)entityName{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:context_];
}

- (void) addObject:(NSManagedObject *)obj
{
    if (obj) {
        [context_ insertObject:obj];
    }
}

- (void) removeObject:(NSManagedObject *)obj
{
    if (obj) {
        [context_ deleteObject:obj];
    }
}

- (void) save
{
    @try {
        NSError *err = nil;
        if ([context_ hasChanges] && ![context_ save:&err]) {
            NSLog(@"%@",[err userInfo]);
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    } @finally {
        
    }
}


- (void) removeObjectsForEntity:(NSString *)name predicate:(NSPredicate *)predicate
{
    [context_ performBlockAndWait:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        if (predicate) {
            [fetchRequest setPredicate:predicate];
        }
        
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:name inManagedObjectContext:context_];
        [fetchRequest setEntity:entityDesc];
        
        NSArray *result = [context_ executeFetchRequest:fetchRequest error:nil];
        
        for (NSManagedObject *obj in result) {
            //[context_ deleteObject:obj];
            [context_ deleteObject:[context_ objectWithID:[obj objectID]]];
        }
        
        [context_ save:nil];
    }];
}

- (NSUInteger)getCountForEntity:(NSString *)name predicate:(NSPredicate *)predicate
{
    __block NSUInteger count = 0;
    
    [context_ performBlockAndWait:^{

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

        if (predicate) {
            fetchRequest.predicate = predicate;
        }

        fetchRequest.entity = [NSEntityDescription entityForName:name inManagedObjectContext:context_];

        count = [context_ countForFetchRequest:fetchRequest error:nil];
    }];
    
    return count;
}

- (NSArray *)executeResultByPredicate:(NSPredicate *)predicate
                                limit:(NSInteger)limit
                               offset:(NSInteger)offset
                           entityName:(NSString *)name
                        descriptorKey:(NSString *)key
                            ascending:(BOOL)ascending
{
    __block NSArray *result;
    
    [context_ performBlockAndWait:^{

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:name inManagedObjectContext:context_];
        [fetchRequest setEntity:entityDesc];
        
        if(predicate) {
            [fetchRequest setPredicate:predicate];
        }
        
        if (limit > 0) {
            [fetchRequest setFetchLimit:limit];
        }
        
        if (offset > 0) {
            [fetchRequest setFetchOffset:offset];
        }
        
        if (key != nil) {
            NSArray *keys = [key componentsSeparatedByString:@","];
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[keys count]];
            for (int i = 0; i < [keys count]; i++) {
                NSSortDescriptor *descriptor  = [[NSSortDescriptor alloc] initWithKey:[keys objectAtIndex:i] ascending:ascending];
                [array addObject:descriptor];
            }
            [fetchRequest setSortDescriptors:array];
        }
        
        NSError *error = nil;
        result = [context_ executeFetchRequest:fetchRequest error:&error];
        
        if (error) {
            result = nil;
        }
    }];
    
    return result;
}

- (NSArray *)getDistinctResults:(NSString *)entityName
                      predicate:(NSPredicate *)predicate
                         column:(NSString *)col
                          limit:(NSInteger)limit
                         offset:(NSInteger)offset
                  descriptorKey:(NSString *)key
                      ascending:(BOOL)ascending
                     resultType:(NSFetchRequestResultType)type
{
    __block NSArray *objects;
    
    [context_ performBlockAndWait:^{

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:context_];
        [fetchRequest setEntity:entityDesc];
        
        if(predicate) {
            [fetchRequest setPredicate:predicate];
        }
        
        if (limit > 0) {
            [fetchRequest setFetchLimit:limit];
        }
        
        if (offset > 0) {
            [fetchRequest setFetchOffset:offset];
        }

        [fetchRequest setResultType:type];
        [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:col]];
        [fetchRequest setReturnsDistinctResults:YES];

        if (key != nil) {
            NSSortDescriptor *descriptor  = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
            [fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
        }

        NSError *error;
        NSArray *objects = [context_ executeFetchRequest:fetchRequest error:&error];
        if (objects == nil || error) {
            return;
        }
        
        if (type == NSDictionaryResultType) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:[objects count]];
            for(NSDictionary *obj in objects) {
                [dataArray addObject:[obj objectForKey:col]];
            }
            objects = dataArray;
        }
        
    }];
    
    return objects;
}

@end
