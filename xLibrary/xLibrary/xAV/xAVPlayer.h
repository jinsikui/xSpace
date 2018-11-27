//
//  xAVPlayer.h
//  xSpace
//
//  Created by JSK on 2018/6/6.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum xAVPlayerState {
    xAVPlayerStateNone = 0,
    xAVPlayerStateLoading = 1,
    xAVPlayerStatePlaying = 2,
    xAVPlayerStatePaused = 3,
    xAVPlayerStateFinished = 4
} xAVPlayerState;

@protocol xAVPlayerDelegate
@optional
-(void)xAVPlayerOnStateChanged:(xAVPlayerState)state curTime:(NSTimeInterval)curTime duration:(NSTimeInterval)duration;
-(void)xAVPlayerOnError:(NSError*)error;
@end

@interface xAVPlayer : NSObject
@property(nonatomic) NSURL *url;
@property(nonatomic) xAVPlayerState state;
@property(nonatomic,weak) NSObject<xAVPlayerDelegate> *delegate;
@property(nonatomic) NSTimeInterval curTime;
@property(nonatomic,readonly) NSTimeInterval duration;
-(instancetype)initWithUrl:(NSURL*)url;
-(void)prepareForPlay;
-(void)play;
-(void)pause;
-(void)stop;
-(void)seek:(NSTimeInterval)time;
-(void)dispose;
@end
