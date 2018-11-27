//
//  xAVAudioRecorder.h
//  xSpace
//
//  Created by JSK on 2018/6/6.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum xAVAudioRecorderState {
    xAVAudioRecorderStateNone = 0,
    xAVAudioRecorderStateRecording = 1,
    xAVAudioRecorderStatePaused = 2,
    xAVAudioRecorderStateFinished = 3
} xAVAudioRecorderState;

@protocol xAVAudioRecorderDelegate
@optional
-(void)xAVAudioRecorderOnStateChanged:(xAVAudioRecorderState)state recordingTime:(NSTimeInterval)time;
-(void)xAVAudioRecorderOnError:(NSError*)error;
@end

@interface xAVAudioRecorder : NSObject
@property(nonatomic) NSString *filePath;
@property(nonatomic) xAVAudioRecorderState state;
@property(nonatomic,weak) NSObject<xAVAudioRecorderDelegate> *delegate;
@property(nonatomic,readonly) NSTimeInterval curTime;
@property(nonatomic,readonly) NSTimeInterval duration;
-(instancetype)initWithFilePath:(NSString*)filePath;
-(void)prepareForRecord;
-(void)record;
-(void)pause;
-(void)stop;
-(void)dispose;
@end
