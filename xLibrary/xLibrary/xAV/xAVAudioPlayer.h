//
//  xAVAudioPlayer.h
//  本类采用系统的AVAudioPlayer播放音频
//
//  Created by JSK on 2018/6/6.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum xAVAudioPlayerState {
    xAVAudioPlayerStateNone = 0,
    xAVAudioPlayerStatePlaying = 1,
    xAVAudioPlayerStatePaused = 2,
    xAVAudioPlayerStateFinished = 3
} xAVAudioPlayerState;

@protocol xAVAudioPlayerDelegate
@optional
-(void)xAVAudioPlayerOnStateChanged:(xAVAudioPlayerState)state curTime:(NSTimeInterval)curTime duration:(NSTimeInterval)duration;
-(void)xAVAudioPlayerOnError:(NSError*)error;
@end

@interface xAVAudioPlayer : NSObject
@property(nonatomic) NSURL *url;
@property(nonatomic) xAVAudioPlayerState state;
@property(nonatomic,weak) NSObject<xAVAudioPlayerDelegate> *delegate;
@property(nonatomic,readonly) NSTimeInterval curTime;
@property(nonatomic,readonly) NSTimeInterval duration;
-(instancetype)initWithUrl:(NSURL*)url;
-(void)prepareForPlay;
-(void)play;
-(void)pause;
-(void)stop;
-(void)seek:(NSTimeInterval)time;
-(void)dispose;
@end
