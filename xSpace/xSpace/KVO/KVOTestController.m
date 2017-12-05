//
//  KVOController.m
//  xSpace
//
//  Created by JSK on 2017/11/22.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "KVOTestController.h"

@interface KVOTestController ()
@property(nonatomic,strong) NSMutableArray *arr;
@property(nonatomic,strong) xTimer  *timer;
@property(nonatomic,strong) UILabel *stateLabel;
@end

@implementation KVOTestController

-(instancetype)init{
    self = [super init];
    if(!self)
        return nil;
    self.state = HostinStateInit;
    return self;
}

-(void)setState:(HostinState)state{
    NSLog(@"===== HostinState:%ld =====", (long)state);
    if(state == HostinStateTalking){
        if(_state != HostinStateTalking){
            self.talkingTime = 0;
            if(self.timer == nil){
                __weak typeof(self) weak = self;
                self.timer = [xTimer timerOnGlobalWithIntervalSeconds:1 fireOnStart:NO action:^{
                    weak.talkingTime += 1;
                    [[xNotice shared] postEvent:@"HostinEventTalkingElapsed" userInfo:@{@"HostinEventTalkingDurationKey":@(weak.talkingTime)}];
                }];
            }
            [self.timer start];
        }
    }
    else{
        [self.timer stop];
    }
    _state = state;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KVO test";
    
    _arr = [NSMutableArray array];
    [_arr addObject:@(1)];
    [_arr addObject:@(2)];
    
    UIButton *btn = [xViewFactory buttonWithTitle:@"change" font:kFontPF(17) titleColor:kColor(0x0) bgColor:UIColor.clearColor];
    [btn addTarget:self action:@selector(actionChange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    self.stateLabel = [xViewFactory labelWithText:@"" font:kFontPF(14) color:kColor(0)];
    [self.view addSubview:self.stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    __weak typeof(self) weak = self;
    [self.KVOController observe:self keyPath:@"arr" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        NSLog(@"===== arr change: %lu =====", (unsigned long)_arr.count);
    }];
    [self.KVOController observe:self keyPath:@"state" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        [xTask asyncMain:^{
            if(weak.state == HostinStateTalking){
                weak.stateLabel.text = [weak makeTalkingTimeStr];
            }
            else{
                weak.stateLabel.text = @"hello world";
            }
        }];
        NSLog(@"===== state change: %d =====", self.state);
    }];
    [self.KVOController observe:self keyPath:@"talkingTime" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        if(weak.state == HostinStateTalking){
            [xTask asyncMain:^{
                weak.stateLabel.text = [weak makeTalkingTimeStr];
            }];
        }
        NSLog(@"===== talkingTimeChange change: %lu =====", (unsigned long)self.talkingTime);
    }];
}

-(void)actionChange{
    NSMutableArray *newValue = self.arr;
    [newValue addObject:@(3)];
    self.arr = newValue;
    self.state = HostinStateTalking;
}

-(NSString*)makeTalkingTimeStr{
    NSUInteger hours = 0, minis = 0, seconds = 0;
    hours = self.talkingTime / 3600;
    minis = (self.talkingTime % 3600) / 60;
    seconds = self.talkingTime % 60;
    return [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)hours,(unsigned long)minis,(unsigned long)seconds];
}

@end
