//
//  QTNetworkAsyncOperation.m
//  QTNetwork
//
//  Created by Leo on 2017/8/18.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTNetworkAsyncOperation.h"

@interface QTNetworkAsyncOperation(){
    BOOL finished;
    BOOL executing;
}

@end

@implementation QTNetworkAsyncOperation

- (void)start{
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = NO;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main{
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        finished = NO;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    [self execute];
}

- (void)execute{}

- (BOOL)isFinished{
    return finished;
}

- (BOOL)isExecuting{
    return executing;
}
- (void)finishOperation{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing = NO;
    finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isAsynchronous{
    return YES;
}

@end
