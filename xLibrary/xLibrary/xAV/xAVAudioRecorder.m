//
//  xAVAudioRecorder.m
//  xSpace
//
//  Created by JSK on 2018/6/6.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "xAVAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

#define ERROR_DOMAIN @"xAVAudioRecorder"

@interface xAVAudioRecorder()<AVAudioRecorderDelegate>
@property(nonatomic) NSURL              *fileUrl;
@property(nonatomic) BOOL               hasPreparedForRecord;
@property(nonatomic) AVAudioRecorder    *recorder;
@property(nonatomic) xTimer             *recordingTimeTimer;
@end

@implementation xAVAudioRecorder

-(instancetype)initWithFilePath:(NSString *)filePath{
    self = [super init];
    if(self){
        _filePath = filePath;
    }
    return self;
}

-(void)dealloc{
    [self dispose];
}

-(void)dispose{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)prepareForRecord{
    if(_hasPreparedForRecord){
        return;
    }
    //电话打断
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
    _hasPreparedForRecord = YES;
}

#pragma mark - System Audio Process

- (void)sessionInterruption:(NSNotification *)notification {
    AVAudioSessionInterruptionType interruptionType = [[[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (AVAudioSessionInterruptionTypeBegan == interruptionType) {
        //begin interruption
        //直接停止播放
        [self stop];
    }
    else if (AVAudioSessionInterruptionTypeEnded == interruptionType) {
        //end interruption
    }
}

//AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    self.state = xAVAudioRecorderStateFinished;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    [self postError:error];
}

#pragma mark - Interfaces

-(void)record{
    if(!_hasPreparedForRecord || _state == xAVAudioRecorderStateRecording){
        return;
    }
    NSError *error = nil;
    if(![[AVAudioSession sharedInstance] setActive:YES error:&error]){
        [self postError:error];
        return;
    }
    if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]){
        [self postError:error];
        return;
    }
    if(_state != xAVAudioRecorderStatePaused){
        //删除之前的录音
        [[NSFileManager defaultManager]removeItemAtPath:_filePath error:nil];
    }
    if(!_recorder){
        _fileUrl = [NSURL fileURLWithPath:_filePath];
        //设置录音的音频参数
        /*
         1 ID号:acc
         2 采样率(HZ):每秒从连续的信号中提取并组成离散信号的采样个数
         3 通道的个数:(1 单声道 2 立体声)
         4 采样位数(8 16 24 32) 衡量声音波动变化的参数
         5 大端或者小端 (内存的组织方式)
         6 采集信号是整数还是浮点数
         7 音频编码质量
         */
        NSDictionary *info = @{
                               AVFormatIDKey:[NSNumber numberWithInt:kAudioFormatMPEG4AAC],//音频格式
                               AVSampleRateKey:@1000,//采样率
                               AVNumberOfChannelsKey:@2,//声道数
                               AVLinearPCMBitDepthKey:@8,//采样位数
                               AVLinearPCMIsBigEndianKey:@NO,
                               AVLinearPCMIsFloatKey:@NO,
                               AVEncoderAudioQualityKey:[NSNumber numberWithInt:AVAudioQualityMedium],
                               
                               };
        
        /*
         url:录音文件保存的路径
         settings: 录音的设置
         error:错误
         */
        _recorder = [[AVAudioRecorder alloc]initWithURL:_fileUrl settings:info error:nil];
        _recorder.delegate = self;
        if(error){
            [self postError:error];
            _recorder = nil;
            return;
        }
        BOOL preparedOK = [_recorder prepareToRecord];
        if(!preparedOK){
            [self postError:[NSError errorWithDomain:ERROR_DOMAIN code:-1 userInfo:nil]];
            return;
        }
    }
    BOOL recordOK = [_recorder record];
    if(!recordOK){
        [self postError:[NSError errorWithDomain:ERROR_DOMAIN code:-1 userInfo:nil]];
        return;
    }
    self.state = xAVAudioRecorderStateRecording;
    
}

-(void)setState:(xAVAudioRecorderState)state{
    if(_state != state){
        _state = state;
        [self postState];
        if(state == xAVAudioRecorderStateRecording){
            if(!_recordingTimeTimer){
                __weak typeof(self) weak = self;
                _recordingTimeTimer = [xTimer timerOnMainWithIntervalSeconds:1 fireOnStart:YES action:^{
                    __strong typeof(weak) s = weak;
                    if(s.state == xAVAudioRecorderStateRecording){
                        [self postState];
                    }
                }];
            }
            [_recordingTimeTimer start];
        }
        else{
            [_recordingTimeTimer stop];
        }
    }
}

-(void)pause{
    if(_state != xAVAudioRecorderStateRecording){
        return;
    }
    [self postState];
    [_recorder pause];
    self.state = xAVAudioRecorderStatePaused;
}

-(void)stop{
    if(_state != xAVAudioRecorderStateRecording && _state != xAVAudioRecorderStatePaused){
        return;
    }
    [_recorder stop];
}

-(NSTimeInterval)curTime{
    if(!_recorder){
        return 0;
    }
    return _recorder.currentTime;
}

-(void)postState{
    NSObject<xAVAudioRecorderDelegate> *delegate = self.delegate;
    if(delegate && [delegate respondsToSelector:@selector(xAVAudioRecorderOnStateChanged:recordingTime:)]){
        [delegate xAVAudioRecorderOnStateChanged:_state recordingTime:_recorder.currentTime];
    }
}

-(void)postError:(NSError*)error{
    NSObject<xAVAudioRecorderDelegate> *delegate = self.delegate;
    if(delegate && [delegate respondsToSelector:@selector(xAVAudioRecorderOnError:)]){
        [delegate xAVAudioRecorderOnError:error];
    }
}

@end
