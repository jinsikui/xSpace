//
//  KVOController.m
//  xSpace
//
//  Created by JSK on 2017/11/22.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "KVOTestController.h"

@interface KVOInnerModel : NSObject
@property(nonatomic) NSString *innerName;
@end

@implementation KVOInnerModel
@end

@interface KVOModel:NSObject
@property(nonatomic, assign)    HostinState state;
@property(nonatomic, assign)    NSUInteger  talkingTime; //seconds
@property(nonatomic, strong) NSMutableArray *arr;
@property(nonatomic) int i1;
@property(nonatomic) NSString *s1;
@property(nonatomic,strong) xTimer  *timer;
@property(nonatomic,strong) KVOInnerModel *innerModel;
@end

@implementation KVOModel

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
@end

@interface KVOTestController ()
@property(nonatomic,strong) KVOModel *model;
@property(nonatomic,strong) UILabel *stateLabel;
@end

@implementation KVOTestController

-(instancetype)init{
    self = [super init];
    if(!self)
        return nil;
    self.model = [[KVOModel alloc] init];
    self.model.state = HostinStateInit;
    self.model.s1 = @"";
    self.model.innerModel = [[KVOInnerModel alloc] init];
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KVO test";
    
    _model.arr = [NSMutableArray array];
    [_model.arr addObject:@(1)];
    [_model.arr addObject:@(2)];

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
    UIButton *btn2 = [xViewFactory buttonWithTitle:@"change i1" font:kFontPF(17) titleColor:kColor(0x0) bgColor:UIColor.clearColor];
    [btn2 addTarget:self action:@selector(actionChange2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stateLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];

    __weak typeof(self) weak = self;
    [self.KVOController observe:self.model keyPath:@"arr" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        NSLog(@"===== arr change: %lu =====", (unsigned long)weak.model.arr.count);
    }];
    [self.KVOController observe:self.model keyPath:@"state" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        [xTask asyncMain:^{
            if(weak.model.state == HostinStateTalking){
                weak.stateLabel.text = [weak makeTalkingTimeStr];
            }
            else{
                weak.stateLabel.text = @"hello world";
            }
        }];
        NSLog(@"===== state change: %d =====", weak.model.state);
    }];
    [self.KVOController observe:self.model keyPath:@"talkingTime" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        if(weak.model.state == HostinStateTalking){
            [xTask asyncMain:^{
                weak.stateLabel.text = [weak makeTalkingTimeStr];
            }];
        }
        NSLog(@"===== talkingTimeChange change: %lu =====", (unsigned long)weak.model.talkingTime);
    }];
    [self.KVOController observe:self.model keyPath:@"i1" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        NSLog(@"===== block1 detect i1 change: %d =====", weak.model.i1);
    }];
    [self.KVOController observe:self.model keyPath:@"i1" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        NSLog(@"===== block2 detect i1 change: %d =====", weak.model.i1);
    }];
    [self.KVOController observe:self.model keyPaths:@[@"i1",@"s1"] options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        NSLog(@"===== block3 detect i1 or s1 change: %d %@ =====", weak.model.i1, weak.model.s1);
    }];
    //结论，当i1改变时，block1，block2，block3谁在前面谁被调用，所以只有block1被调用，但当s1改变时，block3被调用，所以说block1，block2，block3都注册成功了，但当一个值改变时，只触发最早监听这个值的block
    
    [self.KVOController observe:self.model keyPath:@"innerModel.innerName" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        NSLog(@"===== innerModel.innerName changed =====");
    }];
    
    [self.KVOController observe:self.model keyPath:@"innerModel" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        NSLog(@"===== innerModel changed =====");
    }];
    //结论：当父节点改变时，子节点的监听也会触发
}

-(void)actionChange{
    NSMutableArray *newValue = self.model.arr;
    [newValue addObject:@(3)];
    self.model.arr = newValue;
    self.model.state = HostinStateTalking;
    self.model.innerModel = [[KVOInnerModel alloc] init];
    [xTask asyncGlobalAfter:5 task:^{
        self.model.innerModel.innerName = @"JSK";
    }];
}

-(void)actionChange2{
    self.model.i1 += 1;
}

-(NSString*)makeTalkingTimeStr{
    NSUInteger hours = 0, minis = 0, seconds = 0;
    hours = self.model.talkingTime / 3600;
    minis = (self.model.talkingTime % 3600) / 60;
    seconds = self.model.talkingTime % 60;
    return [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)hours,(unsigned long)minis,(unsigned long)seconds];
}

-(void)dealloc{
    NSLog(@"===== KVOTestController dealloc =====");
}

@end
