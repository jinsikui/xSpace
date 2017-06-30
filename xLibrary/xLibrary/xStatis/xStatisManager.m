//
//  xStatisManager.m
//  xLibrary
//
//  Created by JSK on 2017/6/29.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xStatisManager.h"
#import "xStatisStack.h"

@interface xStatisManager(){
}
@end

@implementation xStatisManager

+(instancetype)sharedInstance{
    static xStatisManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)logActionData:(xStatisActionData *)actionData{
    if(self.actionDataHandler){
        self.actionDataHandler(actionData);
    }
}

-(void)pushPageWithKey:(id)key pageName:(NSString*)pageName{
    [[xStatisStack sharedInstance] push:key pageName:pageName];
}

-(void)popPageWithKey:(id)key{
    [[xStatisStack sharedInstance] pop:key];
}

@end
