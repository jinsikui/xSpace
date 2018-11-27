//
//  AudioRecordController.m
//  xSpace
//
//  Created by JSK on 2018/6/5.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "AudioController.h"
#import "xAVAudioPlayer.h"
#import "xAVPlayer.h"
#import "xAVAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioController ()<xAVAudioPlayerDelegate,xAVAudioRecorderDelegate, xAVPlayerDelegate>

@property(nonatomic) UIButton *startBtn;
@property(nonatomic) UIButton *pauseBtn;
@property(nonatomic) UIButton *resumeBtn;
@property(nonatomic) UIButton *stopBtn;
@property(nonatomic) UIButton *playBtn;
@property(nonatomic) UIButton *pausePlayBtn;
@property(nonatomic) UIButton *resumePlayBtn;
@property(nonatomic) UIButton *stopPlayBtn;
@property(nonatomic) UIButton *seekBtn;
@property(nonatomic) UIButton *md5Btn;
@property(nonatomic) UIButton *sha1Btn;
@property(nonatomic) UIButton *clearBtn;
@property(nonatomic) xAVAudioRecorder *recorder;
//@property(nonatomic) xAVAudioPlayer *player;
@property(nonatomic) xAVPlayer *player;
@property(nonatomic) NSString *filePath;
@property(nonatomic) NSURL    *fileUrl;

@property(nonatomic) UITextView *textView;
@property(nonatomic) UITextField *textField;
@property(nonatomic) BOOL hasSetDuration;
@end

@implementation AudioController

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Audio Record";
    
    
    _startBtn = [xViewFactory buttonWithTitle:@"Record" font:kFontRegularPF(14) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _startBtn.frame = CGRectMake(15, 20, 70, 30);
    [_startBtn addTarget:self action:@selector(actionRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBtn];
    
    _pauseBtn = [xViewFactory buttonWithTitle:@"Pause" font:kFontRegularPF(14) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _pauseBtn.frame = CGRectMake(100, 20, 70, 30);
    [_pauseBtn addTarget:self action:@selector(actionPause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pauseBtn];
    
    _resumeBtn = [xViewFactory buttonWithTitle:@"Resume" font:kFontRegularPF(14) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _resumeBtn.frame = CGRectMake(185, 20, 70, 30);
    [_resumeBtn addTarget:self action:@selector(actionResume) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resumeBtn];
    
    _stopBtn = [xViewFactory buttonWithTitle:@"Stop" font:kFontRegularPF(14) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _stopBtn.frame = CGRectMake(270, 20, 70, 30);
    [_stopBtn addTarget:self action:@selector(actionStop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopBtn];
    
    
    _playBtn = [xViewFactory buttonWithTitle:@"Play" font:kFontRegularPF(14) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _playBtn.frame = CGRectMake(15, 60, 70, 30);
    [_playBtn addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
    
    _pausePlayBtn = [xViewFactory buttonWithTitle:@"pause play" font:kFontRegularPF(13) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _pausePlayBtn.frame = CGRectMake(100, 60, 70, 30);
    [_pausePlayBtn addTarget:self action:@selector(actionPausePlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pausePlayBtn];
    
    _resumePlayBtn = [xViewFactory buttonWithTitle:@"resum play" font:kFontRegularPF(13) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _resumePlayBtn.frame = CGRectMake(185, 60, 70, 30);
    [_resumePlayBtn addTarget:self action:@selector(actionResumePlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resumePlayBtn];
    
    _stopPlayBtn = [xViewFactory buttonWithTitle:@"stop play" font:kFontRegularPF(13) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _stopPlayBtn.frame = CGRectMake(270, 60, 70, 30);
    [_stopPlayBtn addTarget:self action:@selector(actionStopPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopPlayBtn];
    
    _seekBtn = [xViewFactory buttonWithTitle:@"seek" font:kFontRegularPF(14) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _seekBtn.frame = CGRectMake(15, 100, 70, 30);
    [_seekBtn addTarget:self action:@selector(actionSeek) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_seekBtn];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 70, 30)];
    _textField.font = kFontRegularPF(14);
    _textField.layer.borderColor = [UIColor grayColor].CGColor;
    _textField.layer.borderWidth = 0.5;
    _textField.placeholder = @"  seek to?";
    [self.view addSubview:_textField];
    
    _md5Btn = [xViewFactory buttonWithTitle:@"md5" font:kFontRegularPF(14) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _md5Btn.frame = CGRectMake(185, 100, 70, 30);
    [_md5Btn addTarget:self action:@selector(actionMD5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_md5Btn];
    
    _sha1Btn = [xViewFactory buttonWithTitle:@"sha1" font:kFontRegularPF(14) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _sha1Btn.frame = CGRectMake(270, 100, 70, 30);
    [_sha1Btn addTarget:self action:@selector(actionSHA1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sha1Btn];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 140, [UIScreen mainScreen].bounds.size.width - 30, 400)];
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = UIColor.blackColor.CGColor;
    _textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_textView];
    
    _clearBtn = [xViewFactory buttonWithTitle:@"clear" font:kFontRegularPF(14) titleColor:[UIColor blueColor] bgColor:[UIColor clearColor] borderColor:[UIColor blueColor] borderWidth:0.5];
    _clearBtn.frame = CGRectMake(15, 550, 70, 30);
    [_clearBtn addTarget:self action:@selector(actionClear) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearBtn];
    
    _filePath = [xFile documentPath:@"recorder.aac"];
    _fileUrl = [NSURL fileURLWithPath:_filePath];
}

-(void)actionMD5{
    NSData *data = [xFile getDataFromFileOfPath:_filePath];
    NSString *md5 = [data x_MD5];
    [self appendLog:md5];
}

-(void)actionSHA1{
    
}

-(void)actionClear{
    _textView.text = nil;
}

-(void)actionRecord{
    _recorder = [[xAVAudioRecorder alloc] initWithFilePath:_filePath];
    _recorder.delegate = self;
    [_recorder prepareForRecord];
    [_recorder record];
    [self appendLog:@"record"];
}

-(void)actionPause{
    [_recorder pause];
    [self appendLog:@"pause"];
}

-(void)actionResume{
    [self appendLog:@"record"];
    [_recorder record];
}

-(void)actionStop{
    [self appendLog:@"stop"];
    [_recorder stop];
}

-(void)actionPlay{
    [self appendLog:@"play"];
    //_player = [[xAVPlayer alloc] initWithUrl:[NSURL URLWithString:@"http://www.haomuren.org/Upload/NewsAttach/070829P.mp3"]];
    //_player = [[xAVPlayer alloc] initWithUrl:[NSURL URLWithString:@"http://media.haomuren.org/AudioBible/NT%2025%203Jn/3jn%2001.mp3"]];
//    _player = [[xAVPlayer alloc] initWithUrl:[NSURL URLWithString:@"https://appuploader.oss-cn-hangzhou.aliyuncs.com/user/000e7e217a9d78edbfeef87e99cd6cc2/recordFile.aac"]];
    _player = [[xAVPlayer alloc] initWithUrl:[NSURL URLWithString:@"https://qt-zhibo.oss-cn-hangzhou.aliyuncs.com/test/testsikui1.mp3"]];
    _player.delegate = self;
    [_player prepareForPlay];
    [_player play];
    
    
//    _player = [[xAVAudioPlayer alloc] initWithUrl:_fileUrl];
//    _player.delegate = self;
//    [_player prepareForPlay];
//    [_player play];
//    [self appendLog:[NSString stringWithFormat:@"duration:%f",_player.duration]];
}

-(void)actionPausePlay{
    [self appendLog:@"pause play"];
    [_player pause];
}

-(void)actionResumePlay{
    [self appendLog:@"resume play"];
    [_player play];
}

-(void)actionStopPlay{
    [self appendLog:@"stop play"];
    [_player stop];
}

-(void)actionSeek{
    [self appendLog:@"seek"];
    if(_textField.text.length <= 0){
        return;
    }
    NSTimeInterval time = [_textField.text doubleValue];
    [_player seek:time];
}

-(void)appendLog:(NSString*)log{
    __weak typeof(self) weak = self;
    [xTask asyncMain:^{
        weak.textView.text = [[_textView.text stringByAppendingString:log] stringByAppendingString:@"\n"];
    }];
}

-(void)xAVAudioPlayerOnStateChanged:(xAVAudioPlayerState)state curTime:(NSTimeInterval)curTime duration:(NSTimeInterval)duration{
    [self appendLog:[NSString stringWithFormat:@"xAVAudioPlayerOnStateChanged:%d curTime:%f duration:%f", state, curTime, duration]];
}

-(void)xAVAudioPlayerOnError:(NSError*)error{
    [self appendLog:[NSString stringWithFormat:@"xAVAudioPlayerOnError:%@", error]];
}

-(void)xAVAudioRecorderOnStateChanged:(xAVAudioRecorderState)state recordingTime:(NSTimeInterval)time{
    [self appendLog:[NSString stringWithFormat:@"xAVAudioRecorderOnStateChanged:%d recordingTime:%f", state, time]];
}

-(void)xAVAudioRecorderOnError:(NSError*)error{
    [self appendLog:[NSString stringWithFormat:@"xAVAudioRecorderOnError:%@", error]];
}

//===================================================

-(void)xAVPlayerOnStateChanged:(xAVPlayerState)state curTime:(NSTimeInterval)curTime duration:(NSTimeInterval)duration{
    if(duration > 0 && !_hasSetDuration){
        _textField.text = [NSString stringWithFormat:@"%f", duration - 5];
        _hasSetDuration = YES;
    }
    [self appendLog:[NSString stringWithFormat:@"xAVPlayerOnStateChanged:%d, curTime:%f, duration:%f", state, curTime, duration]];
}

-(void)xAVPlayerOnError:(NSError*)error{
    [self appendLog:[NSString stringWithFormat:@"xAVPlayerOnError:%@", error]];
}
@end
