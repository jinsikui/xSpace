//
//  AudioToolController.m
//  xSpace
//
//  Created by JSK on 2018/12/17.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "AudioToolController.h"
#import "AEAudioController.h"
#import "AERecorder.h"
#import <AVFoundation/AVFoundation.h>

// 保存的录音文件名字
static NSString *RECORD_FILE_NAME = @"record.wav";

@interface AudioToolController ()
@property(nonatomic) AEAudioController *audio;
@property(nonatomic) AERecorder *recorder;
@property(nonatomic) AEAudioFilePlayer *recordPlayer;
@end

@implementation AudioToolController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Audio Tool";
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [self createBtn:@"开始录音" frame:CGRectMake(20, 20, 70, 30) selector:@selector(actionRecord)];
    [self createBtn:@"停止录音" frame:CGRectMake(110, 20, 70, 30) selector:@selector(actionStopRecord)];
    [self createBtn:@"继续录音" frame:CGRectMake(200, 20, 70, 30) selector:@selector(actionContinueRecord)];
    [self createBtn:@"播放" frame:CGRectMake(20, 60, 70, 30) selector:@selector(actionPlay)];
    
    _audio = [[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleavedFloatStereoAudioDescription] inputEnabled:YES];
    _audio.preferredBufferDuration = 0.005f;
    _audio.useMeasurementMode = YES;
}

-(void)createBtn:(NSString*)title frame:(CGRect)frame selector:(SEL)selector{
    UIButton *btn = [xViewFactory buttonWithTitle:title font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:frame];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)actionRecord{
    [self startRecording];
    NSLog(@"===== actionRecord =====");
}

-(void)actionStopRecord{
    [self stopRecording];
    NSLog(@"===== actionStopRecord =====");
}

-(void)actionContinueRecord{
    [self startRecording];
    NSLog(@"===== actionContinueRecord =====");
}

-(void)actionPlay{
    [self playRecord];
    NSLog(@"===== actionPlay =====");
}

#pragma mark - 开始录音
- (void)startRecording {
    //实例化AERecorder对象
    _recorder = [[AERecorder alloc] initWithAudioController:_audio];
    
    //获取录制后文件存放的路径
    NSString *filePath = [xFile documentPath:RECORD_FILE_NAME];
    NSError *error = nil;
    if (![_recorder beginRecordingToFileAtPath:filePath fileType:kAudioFileM4AType error:&error]) {
        return;
    }
    //同时录制输入及输出通道的声音(即既录人声,也录手机播放的声音)
    [_audio addInputReceiver:_recorder];
    [_audio addOutputReceiver:_recorder];
    [_audio start:NULL];
}

#pragma mark - 停止录音
- (void)stopRecording {
    if (_recorder) {
        [_recorder finishRecording];
        [_audio stop];
        [_audio removeInputReceiver:_recorder];
        [_audio removeOutputReceiver:_recorder];
        _recorder = nil;
    }
}

#pragma mark - 播放录音
- (void)playRecord {
    NSString *filePath = [xFile documentPath:RECORD_FILE_NAME];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        return;
    }
    NSError *error = nil;
    _recordPlayer = [[AEAudioFilePlayer alloc] initWithURL:[NSURL fileURLWithPath:filePath] error:&error];
    if (!_recordPlayer) {
        NSLog(@"===== init player fail =====");
        return;
    }
    _recordPlayer.completionBlock = ^{
        NSLog(@"===== play complete =====");
    };
    //进行播放
    [_audio addChannels:@[_recordPlayer]];
    [_audio start:NULL];
}

@end
