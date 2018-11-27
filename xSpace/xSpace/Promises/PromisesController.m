//
//  PromisesController.m
//  xSpace
//
//  Created by JSK on 2018/4/10.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "PromisesController.h"
#import "FBLPromises.h"
#import "LiveError.h"

@interface PromisesController ()
@property(nonatomic) FBLPromise<id> *myPromise;
@property(nonatomic) FBLPromise<id> *promise1;
@property(nonatomic) FBLPromise<id> *promise2;
@property(nonatomic) FBLPromise<id> *compoPromise;
@end

@implementation PromisesController

-(void)dealloc{
    NSLog(@"===== promise controller dealloc =====");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Promises Test";
    /**
     1. promise中的过程何时执行，then时？还是创建后立刻执行？- 创建后立即执行
     2. 创建promise时传入的queue是执行过程时的queue还是observer(then)的queue？- 可以用asyncOn，和thenOn分别控制执行和观察所在的queue
     **/
    FBLPromise<NSDictionary*> *promise1 = FBLPromise.asyncOn(dispatch_get_main_queue(), ^(FBLPromiseFulfillBlock fulfill,
                                                                                          FBLPromiseRejectBlock reject) {
        NSLog(@"===== now is in the promise1 task, thread: %@ =====", NSThread.currentThread);
        fulfill(nil);
    });
    FBLPromise<NSDictionary*> *promise2 = FBLPromise.asyncOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(FBLPromiseFulfillBlock fulfill,
                                                                                                                              FBLPromiseRejectBlock reject) {
        NSLog(@"===== now is in the promise2 task, thread: %@ =====", NSThread.currentThread);
        fulfill(nil);
    });
    FBLPromise<NSDictionary*> *promise3 = FBLPromise.asyncOn(dispatch_get_main_queue(), ^(FBLPromiseFulfillBlock fulfill,
                                                                                          FBLPromiseRejectBlock reject) {
        NSLog(@"===== now is in the promise3 task, thread: %@ =====", NSThread.currentThread);
        fulfill(nil);
    }).thenOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^id(NSDictionary* dic){
        NSLog(@"===== now is in the promise3 then, thread: %@ =====", NSThread.currentThread);
        return nil;
    });
    FBLPromise<NSDictionary*> *promise4 = FBLPromise.asyncOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(FBLPromiseFulfillBlock fulfill,
                                                                                                                              FBLPromiseRejectBlock reject) {
        NSLog(@"===== now is in the promise4 task, thread: %@ =====", NSThread.currentThread);
        fulfill(nil);
    }).then(^id(NSDictionary *dic){
        NSLog(@"===== now is in the promise4 then, thread: %@ =====", NSThread.currentThread);
        int r = arc4random();
        if(r%2 == 0){
            NSLog(@"===== promise4 then1 return nil =====");
            return nil;
        }
        else{
            NSLog(@"===== promise4 then1 return dic =====");
            return @{@"msg":@"I love you"};
        }
    }).then(^id(NSDictionary *dic){
        if(dic == nil){
            NSLog(@"===== promise4 then2 receive nil =====");
        }
        else{
            NSLog(@"===== promise4 then2 receive dic =====");
            NSLog(@"===== %@ =====", dic[@"msg"]);
        }
        return nil;
    });
    
    
    FBLPromise<NSDictionary*> *promise5 = FBLPromise.asyncOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(FBLPromiseFulfillBlock fulfill,
                                                                                                                              FBLPromiseRejectBlock reject) {
        NSLog(@"===== now is in the promise5 task =====");
        fulfill(nil);
    }).then(^id(NSDictionary *dic){
        
        return FBLPromise.asyncOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(FBLPromiseFulfillBlock fulfill,
                                                                                                   FBLPromiseRejectBlock reject) {
            NSLog(@"===== now is in the promise5 inner promise task =====");
            reject([NSError errorWithDomain:@"PromiseTest" code:0 userInfo:nil]);
            //fulfill(nil);
            
        }).then(^id(NSDictionary *dic){
            NSLog(@"===== now is in the promise5 inner then =====");
            //return [NSError errorWithDomain:@"PromiseTest" code:0 userInfo:nil];
            return nil;
        });
        
    }).catch(^(NSError *error){
        NSLog(@"===== promise5 catch an error =====");
    });
    
    _myPromise = FBLPromise.asyncOn(dispatch_get_main_queue(), ^(FBLPromiseFulfillBlock fulfill, FBLPromiseRejectBlock reject) {
        [xTask asyncGlobalAfter:5 task:^{
            fulfill(nil);
        }];
    });
    _myPromise.then(^id(id ret){
        NSLog(@"===== myPromise fulfilled =====");
        return nil;
    }).catch(^(NSError *error){
        NSLog(@"===== myPromise reject =====");
    });
    [xTask asyncGlobalAfter:1 task:^{
        //[self.myPromise fulfill:nil];
        [self.myPromise reject:[LiveError errorWithCode:-1 msg:nil]];
    }];
    
    _promise1 = FBLPromise.asyncOn(dispatch_get_main_queue(), ^(FBLPromiseFulfillBlock fulfill, FBLPromiseRejectBlock reject) {
        [xTask asyncGlobalAfter:3 task:^{
            NSLog(@"===== compo promise1 fulfill =====");
            fulfill(nil);
        }];
    });
    _promise2 = FBLPromise.asyncOn(dispatch_get_main_queue(), ^(FBLPromiseFulfillBlock fulfill, FBLPromiseRejectBlock reject) {
        [xTask asyncGlobalAfter:5 task:^{
            NSLog(@"===== compo promise2 reject =====");
            reject([LiveError errorWithCode:-1 msg:nil]);
        }];
    });
    _compoPromise = FBLPromise.anyOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), @[_promise1, _promise2]).then(^id(id ret){
        NSLog(@"===== compoPromise then =====");
        return nil;
    }).catch(^(NSError *error){
        NSLog(@"===== compoPromise reject =====");
    });
    
}

@end
