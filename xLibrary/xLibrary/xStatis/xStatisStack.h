//
//  xStatisStack.h
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xStatisStackData : NSObject

@property (nonatomic, strong) NSString  *pageId;
@property (nonatomic, strong) NSString  *pageName;
@property (nonatomic, strong) NSString  *refPageId;
@property (nonatomic, strong) NSString  *refPageName;
@property (nonatomic, weak) id key;

@end

@interface xStatisStack : NSObject

+(instancetype)sharedInstance;

@property (nonatomic, readonly) xStatisStackData *topData;

- (void) push:(id)key pageName:(NSString *)pageName;

- (void) push:(id)key pageName:(NSString *)pageName clearStatck:(BOOL)clearStack;

- (void) push:(id)key pageName:(NSString *)pageName clearStatck:(BOOL)clearStack isSystem:(BOOL)isSystem;

- (void) pop;

- (void) pop:(id)key;

- (void) popToSystem;

- (void) popToKey:(id)key;

- (void) popToRoot;

@end
