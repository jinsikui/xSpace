//
//  VoiceViewController.m
//  xSpace
//
//  Created by JSK on 2018/8/20.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "VoiceViewController.h"
#import "xVoiceView.h"

@interface VoiceViewController ()
@property(nonatomic,strong) xVoiceView *voiceView;
@end

@implementation VoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _voiceView = [[xVoiceView alloc] initWithBoxSize:CGSizeMake(27, 24)];
    [self.view addSubview:_voiceView];
    [_voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(24);
    }];
    [_voiceView startAnimation];
    [xTask asyncMainAfter:4 task:^{
        [_voiceView pauseAnimation];
        [xTask asyncMainAfter:4 task:^{
            [_voiceView resumeAnimation];
            [xTask asyncMainAfter:4 task:^{
                [_voiceView reset];
                [xTask asyncMainAfter:4 task:^{
                    [_voiceView startAnimation];
                }];
            }];
        }];
    }];
}

@end
