//
//  xTaskController.m
//  xSpace
//
//  Created by JSK on 2018/4/3.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "xTaskController.h"


@interface xTaskController (){
    xCompositeTask *_ct;
}

@end

@implementation xTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = @"xTask test";
    self.view.backgroundColor = kColor(0xFFFFFF);
    //========================================================
    xDelayTask *t1 = [xTask delayTaskWithDelay:3];
    xCustomTask *t2 = [xTask customTaskWithHandler:^(xTaskHandle *handle) {
        handle.status = xTaskStatusExecuting;
        [xTask asyncGlobalAfter:0.5 task:^{
            [handle complete:@"OK done."];
        }];
    }];
    _ct = [xTask all:@[t1,t2] callback:^(NSArray<id<xTaskProtocol>> *tasks) {
        NSLog(@"=====%@=====", tasks[1].handle.result);
    }];
    //========================================================
    xTaskHandle *handle = [xTask asyncGlobalAfter:5 task:^{
        NSLog(@"===== async global after 5 secs =====");
    }];
    [xTask asyncGlobalAfter:4 task:^{
        [handle cancel];
    }];
    [xTask asyncMain:^{
        NSLog(@"%@", self);
    }];
}

-(void)dealloc{
    NSLog(@"===== xTaskController dealloc =====");
}

@end
