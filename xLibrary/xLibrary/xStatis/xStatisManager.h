//
//  xStatisManager.h
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "xStatisActionData.h"

@interface xStatisManager : NSObject

+(instancetype)sharedInstance;

@property(nonatomic,copy) void(^actionDataHandler)(xStatisActionData*);

-(void)logActionData:(xStatisActionData*)actionData;

-(void)pushPageWithKey:(id)key pageName:(NSString*)pageName;

-(void)popPageWithKey:(id)key;

@end
