//
//  xAVPlayer.m
//  xSpace
//
//  Created by JSK on 2018/6/6.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "xAVPlayer.h"
#import <AVFoundation/AVFoundation.h>

#define ERROR_DOMAIN @"xAVPlayer"

@interface xAVPlayer()
@property(nonatomic) BOOL           hasPreparedForPlay;
@property(nonatomic) BOOL           isProximityMonitoringEnabledBefore;
@property(nonatomic) AVPlayer       *player;
@property(nonatomic) AVPlayerItem   *playerItem;
@property(nonatomic) xTimer         *playingTimeTimer;
@end

@implementation xAVPlayer

-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if(self){
        _url = url;
        _isProximityMonitoringEnabledBefore = [UIDevice currentDevice].isProximityMonitoringEnabled;
    }
    return self;
}

-(void)dealloc{
    [self dispose];
}

-(void)dispose{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"duration"];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:_isProximityMonitoringEnabledBefore];
}

-(void)prepareForPlay{
    if(_hasPreparedForPlay){
        return;
    }
    //开启红外感应(贴耳感应)
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    //注册使用近距离传感器,红外感应
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
    //监听输出设备变化（耳机插拔，蓝牙设备连接和断开等）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionRouteChange:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
    //电话打断
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
    _hasPreparedForPlay = YES;
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

- (void)sessionRouteChange:(NSNotification *)notification {
    AVAudioSessionRouteChangeReason routeChangeReason = [notification.userInfo[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    if (AVAudioSessionRouteChangeReasonNewDeviceAvailable == routeChangeReason) {//新设备插入
        if ([self isNotUseBuiltInPort]) {
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        }
    }
    else if (AVAudioSessionRouteChangeReasonOldDeviceUnavailable == routeChangeReason) { //新设备拔出
        if (![self isNotUseBuiltInPort]) {
            [self sensorStateChange:nil];
        }
    } else {
        //没有设备音频变化
    }
}

-(void)sensorStateChange:(NSNotification*)notification{
    if ([UIDevice currentDevice].isProximityMonitoringEnabled){
        if ([[UIDevice currentDevice] proximityState] == YES){
            //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        }
        else{
            //正常状态下，扬声器模式
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        }
    }
}

//检测是否有耳机，只需在route中是否有Headphone或Headset存在
- (BOOL)hasHeadset {
#if TARGET_IPHONE_SIMULATOR
    // #warning *** Simulator mode: audio session code works only on a device
    return NO;
#else
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    return [self isHeadsetPluggedIn];
#else
    CFStringRef route;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    if((route == NULL) || (CFStringGetLength(route) == 0)){
        // Silent Mode
    } else {
        NSString* routeStr = (__bridge NSString*)route;
        //    NSLog(@"AudioRoute: %@", routeStr);
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
        if (headphoneRange.location != NSNotFound) {
            return YES;
        } else if(headsetRange.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
#endif
    
#endif
}

//设备是否存在，耳麦，耳机等
- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription *desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]) {
            return YES;
        }
        else  if([[desc portType] isEqualToString:AVAudioSessionPortHeadsetMic]) {
            return YES;
        }else {
            continue;
        }
    }
    return NO;
}

- (BOOL)isNotUseBuiltInPort{
    NSArray *outputs = [[AVAudioSession sharedInstance] currentRoute].outputs;
    if (outputs.count <= 0) {
        return NO;
    }
    AVAudioSessionPortDescription *port = (AVAudioSessionPortDescription*)outputs[0];
    return ![port.portType isEqualToString:AVAudioSessionPortBuiltInReceiver]&&![port.portType isEqualToString:AVAudioSessionPortBuiltInSpeaker];
}

#pragma mark - Interfaces

-(void)play{
    if(!_hasPreparedForPlay || _state == xAVPlayerStateLoading || _state == xAVPlayerStatePlaying){
        return;
    }
    NSError *error = nil;
    if(![[AVAudioSession sharedInstance] setActive:YES error:&error]){
        [self postError:error];
        return;
    }
    if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error]){
        [self postError:error];
        return;
    }
    if(!_player){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        _playerItem = [AVPlayerItem playerItemWithURL:_url];
        [_playerItem addObserver:self forKeyPath:@"status" options:0 context:nil];
        [_playerItem addObserver:self forKeyPath:@"duration" options:0 context:nil];
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    }
    if(_state == xAVPlayerStatePaused){
        self.state = xAVPlayerStatePlaying;
    }
    else{
        self.state = xAVPlayerStateLoading;
    }
    [_player play];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    NSLog(@"===== playerItemDidReachEnd =====");
    self.state = xAVPlayerStateFinished;
    [_player seekToTime:kCMTimeZero];
    self.state = xAVPlayerStateNone;
}

-(void)setState:(xAVPlayerState)state{
    if(_state != state){
        _state = state;
        [self postState];
        if(state == xAVPlayerStateLoading || state == xAVPlayerStatePlaying){
            if(!_playingTimeTimer){
                __weak typeof(self) weak = self;
                _playingTimeTimer = [xTimer timerOnMainWithIntervalSeconds:1 fireOnStart:YES action:^{
                    __strong typeof(weak) s = weak;
                    if(s.state == xAVPlayerStateLoading){
                        NSTimeInterval currentTime = CMTimeGetSeconds(s.player.currentTime);
                        if(currentTime > 0){
                            s.state = xAVPlayerStatePlaying;
                        }
                    }
                    else if(s.state == xAVPlayerStatePlaying){
                        [s postState];
                    }
                }];
            }
            [_playingTimeTimer start];
        }
        else{
            [_playingTimeTimer stop];
        }
    }
}

-(void)pause{
    if(_state != xAVPlayerStatePlaying){
        return;
    }
    [self postState];
    [_player pause];
    self.state = xAVPlayerStatePaused;
}

-(void)stop{
    [_player seekToTime:kCMTimeZero];
    [_player pause];
    self.state = xAVPlayerStateNone;
}

-(NSTimeInterval)curTime{
    if(!_player){
        return 0;
    }
    return CMTimeGetSeconds(_player.currentTime);
}

-(void)seek:(NSTimeInterval)time{
    CMTime seekingCM = CMTimeMakeWithSeconds(time, 1000000);
    [_player seekToTime:seekingCM];
    [self postState];
}

-(NSTimeInterval)duration{
    if(!_playerItem){
        return 0;
    }
    return CMTimeGetSeconds(_playerItem.duration);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if(object == _playerItem){
        if([keyPath isEqualToString:@"status"]){
            NSLog(@"===== kvo playerItem.status changed to: %ld =====", (long)((AVPlayerItem *)object).status);
            if (_playerItem.status == AVPlayerItemStatusFailed) {
                NSError *error = [_playerItem error];
                [self postError:error];
                [self stop];
            }
            else if(_playerItem.status == AVPlayerItemStatusReadyToPlay){
             
            }
        }
        else if([keyPath isEqualToString:@"duration"]){
            NSLog(@"===== kvo playerItem.duration changed to: %f =====", CMTimeGetSeconds(((AVPlayerItem *)object).duration));
            [self postState];
        }
    }
}

-(void)postState{
    xAVPlayerState state = _state;
    NSTimeInterval curTime = CMTimeGetSeconds(_player.currentTime);
    NSTimeInterval duration;
    if(CMTIME_IS_INDEFINITE(_playerItem.duration)){
        duration = 0;
    }
    else{
        duration = CMTimeGetSeconds(_playerItem.duration);
    }
    NSLog(@"===== postState:%d, curTime:%f, duration:%f", state, curTime, duration);
    NSObject<xAVPlayerDelegate> *delegate = self.delegate;
    if(delegate && [delegate respondsToSelector:@selector(xAVPlayerOnStateChanged:curTime:duration:)]){
        [delegate xAVPlayerOnStateChanged:state curTime:curTime duration:duration];
    }
}

-(void)postError:(NSError*)error{
    NSObject<xAVPlayerDelegate> *delegate = self.delegate;
    if(delegate && [delegate respondsToSelector:@selector(xAVPlayerOnError:)]){
        [delegate xAVPlayerOnError:error];
    }
}


@end
