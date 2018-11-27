//
//  RetryController.m
//  xSpace
//
//  Created by JSK on 2018/5/19.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "RetryController.h"
#import "xAlert.h"

@interface RetryController ()
@property(nonatomic) BOOL       isRetryPlaying;
@property(nonatomic) xTaskHandle *retryHandle;
@property(nonatomic) NSString   *state; //loading playing error
@end

@implementation RetryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retryPlaying];
}

-(void)retryPlaying{
    if(_isRetryPlaying){
        return;
    }
    _isRetryPlaying = YES;
    __weak typeof(self) weak = self;
    NSLog(@"===== play1 =====");
    [self play];
    self.retryHandle = [xTask asyncMainAfter:4 task:^{
        NSLog(@"===== play2 =====");
        [weak play];
        weak.retryHandle = [xTask asyncMainAfter:4 task:^{
            NSLog(@"===== play3 =====");
            [weak play];
            weak.retryHandle = [xTask asyncMainAfter:4 task:^{
                NSLog(@"===== play4 =====");
                [weak play];
                weak.retryHandle = [xTask asyncMainAfter:4 task:^{
                    NSLog(@"===== play5 =====");
                    [weak play];
                    weak.retryHandle = [xTask asyncMainAfter:4 task:^{
                        [xAlert showWithTitle:@"音频获取失败" message:@"当前音频获取失败，请稍后重试" cancelTitle:@"" confirmTitle:@"知道了" completionHandler:nil];
                        [weak clearRetryPlaying];
                    }];
                }];
            }];
        }];
    }];
}

-(void)clearRetryPlaying{
    [_retryHandle cancel];
    _retryHandle = nil;
    _isRetryPlaying = NO;
}

-(void)play{
    [xTask asyncMainAfter:7 task:^{
        [self clearRetryPlaying];
    }];
}

@end
