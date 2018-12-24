//
//  AudioToolController.m
//  xSpace
//
//  Created by JSK on 2018/12/17.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "AudioBusController.h"
#import <AVFoundation/AVFoundation.h>
#import "xAudioBus.h"

@interface AudioBusController ()
@end

@implementation AudioBusController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Audio Bus";
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [self createBtn:@"开始录制" frame:CGRectMake(50, 20, 70, 30) selector:@selector(actionRecord)];
    [self createBtn:@"暂停" frame:CGRectMake(140, 20, 70, 30) selector:@selector(actionPause)];
    [self createBtn:@"继续" frame:CGRectMake(230, 20, 70, 30) selector:@selector(actionContinue)];
    [self createBtn:@"停止" frame:CGRectMake(50, 60, 70, 30) selector:@selector(actionStop)];
    [self createBtn:@"播放" frame:CGRectMake(140, 60, 70, 30) selector:@selector(actionPlay)];
}

-(void)createBtn:(NSString*)title frame:(CGRect)frame selector:(SEL)selector{
    UIButton *btn = [xViewFactory buttonWithTitle:title font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:frame];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)actionRecord{
    [[xAudioBus shared] reset];
    [[xAudioBus shared] addMicInput:[[xABMicInput alloc] init]];
    [[xAudioBus shared] addFileInput:[[xABFileInput alloc] initWithPath:[xFile bundlePath:@"test.pcm"]]];
    [[xAudioBus shared] addPcmOutput:[[xABPcmOutput alloc] initWithPath:[xFile documentPath:@"record.pcm"] isAppend:YES]];
    [[xAudioBus shared] run];
    NSLog(@"===== actionRecord =====");
}

-(void)actionPause{
    [[xAudioBus shared] pause];
    NSLog(@"===== actionPause =====");
}

-(void)actionContinue{
    [[xAudioBus shared] run];
    NSLog(@"===== actionContinue =====");
}

-(void)actionStop{
    [[xAudioBus shared] stop];
    NSLog(@"===== actionStop =====");
}

-(void)actionPlay{
    [[xAudioBus shared] reset];
    [[xAudioBus shared] addFileInput:[[xABFileInput alloc] initWithPath:[xFile documentPath:@"record.pcm"]]];
    [[xAudioBus shared] run];
    NSLog(@"===== actionPlay =====");
}

@end
