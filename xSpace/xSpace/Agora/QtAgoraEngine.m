//
//  QtAgoraEngine.m
//  QTRadio
//
//  Created by JSK on 2017/11/20.
//  Copyright © 2017年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "QtAgoraEngine.h"

#define kSpeakerVolumesCallbackInterval 1000    //milliseconds

NSString *const QtAgoraEventConnectStatusChanged = @"QtAgoraEvent.ConnectStatusChanged";
NSString *const QtAgoraEventConnectStatusKey = @"QtAgoraEvent.ConnectStatusKey";
NSString *const QtAgoraEventNetworkStatusChanged = @"QtAgoraEvent.NetworkStatusChanged";
NSString *const QtAgoraEventNetworkStatusKey = @"QtAgoraEvent.NetworkStatusKey";
NSString *const QtAgoraEventConnectionLost = @"QtAgoraEvent.ConnectionLost";
NSString *const QtAgoraEventRequestChannelKey = @"QtAgoraEvent.RequestChannelKey";
NSString *const QtAgoraEventSDKError = @"QtAgoraEvent.SDKError";
NSString *const QtAgoraEventSDKErrorCodeKey = @"QtAgoraEvent.SDKErrorCodeKey";
NSString *const QtAgoraEventSelfConnected = @"QtAgoraEvent.SelfConnected";
NSString *const QtAgoraEventMasterCutoff = @"QtAgoraEvent.MasterCutoff";
NSString *const QtAgoraEventPublisherConnected = @"QtAgoraEvent.PublisherConnected";
NSString *const QtAgoraEventPublisherUidKey = @"QtAgoraEvent.PublisherUidKey";
NSString *const QtAgoraEventPublisherDisconnected = @"QtAgoraEvent.PublisherDisconnected";
NSString *const QtAgoraEventSelfVolumeInfo = @"QtAgoraEvent.SelfVolumeInfo";
NSString *const QtAgoraEventSelfVolumeInfoKey = @"QtAgoraEvent.SelfVolumeInfoKey";
NSString *const QtAgoraEventOthersVolumesInfo = @"QtAgoraEvent.OthersVolumesInfo";
NSString *const QtAgoraEventOthersVolumesInfoKey = @"QtAgoraEvent.OthersVolumesInfoKey";
//#ifdef DEBUG
//static NSString *const agoraAppId = @"3107d20858804bc0b86df192bd663be9";    //测试环境
//#else
//static NSString *const agoraAppId = @"523204405737451bac7ccb7d306afe57";    //正式环境
//#endif
static NSString *const agoraAppId = @"e113311f89174445a7d20f79662ef006";    //demo环境

@interface QtAgoraEngine()<AgoraLiveDelegate,AgoraLivePublisherDelegate,AgoraLiveSubscriberDelegate,AgoraRtcEngineDelegate>{
    QtAgoraConnectStatus    _status;
    QtAgoraNetworkStatus    _networkStatus;
}

@property(nonatomic,copy)   NSString        *channel;
@property(nonatomic,assign) NSUInteger      uid;
@property(nonatomic,assign) QtAgoraNetworkStatus    networkStatus;
@property(nonatomic,strong) AgoraLiveKit    *liveKit;
@property(nonatomic,strong) AgoraLiveChannelConfig  *channelConfig;
@property(nonatomic,strong) AgoraLivePublisher      *publisher;
@property(nonatomic,strong) AgoraLiveSubscriber     *subscriber;
@property(nonatomic,weak)   id<QtAgoraEnginDelegate>    delegate;

@end

@implementation QtAgoraEngine

- (void)dealloc
{
    [self stopHostin];
}

- (instancetype)initWithChannel:(NSString*)channel uid:(NSUInteger)uid agoraKey:(NSString*)agoraKey{
    self = [super init];
    if(self){
        self.channel = channel;
        self.agoraKey = agoraKey;
        self.uid = uid;
        //
        self.liveKit = [AgoraLiveKit sharedLiveKitWithAppId:agoraAppId];
        _liveKit.delegate = self;
        [_liveKit getRtcEngineKit].delegate = self;
        [[_liveKit getRtcEngineKit] enableAudioVolumeIndication:kSpeakerVolumesCallbackInterval smooth:3];
        
        //
        self.publisher = [[AgoraLivePublisher alloc] initWithLiveKit:self.liveKit];
        [_publisher setMediaType:AgoraMediaTypeAudioOnly];
        _publisher.delegate = self;
        //
        self.subscriber = [[AgoraLiveSubscriber alloc] initWithLiveKit:self.liveKit];
        _subscriber.delegate = self;
        //
        self.channelConfig = [AgoraLiveChannelConfig defaultConfig];
        _channelConfig.videoEnabled = false;
    }
    return self;
}

-(QtAgoraConnectStatus)status{
    return _status;
}

-(void)setStatus:(QtAgoraConnectStatus)status{
    NSLog(@"===== status change to: %d =====", (int)status);
    _status = status;
    [[xNotice shared] postEvent:QtAgoraEventConnectStatusChanged userInfo:@{QtAgoraEventConnectStatusKey:@((NSInteger)status)}];
}

-(QtAgoraNetworkStatus)networkStatus{
    return _networkStatus;
}

-(void)setNetworkStatus:(QtAgoraNetworkStatus)networkStatus{
    //NSLog(@"===== networkStatus change to: %d =====", (int)networkStatus);
    _networkStatus = networkStatus;
    [[xNotice shared] postEvent:QtAgoraEventNetworkStatusChanged userInfo:@{QtAgoraEventNetworkStatusKey:@((NSInteger)networkStatus)}];
}

//静音／关闭静音
-(void)setMuted:(BOOL)isMuted{
    NSLog(@"===== setMuted: %@ =====", isMuted?@"true":@"false");
    [[self.liveKit getRtcEngineKit] muteLocalAudioStream:isMuted];
}

// 应该可重入
-(void)startHostin{
    NSLog(@"===== startHostin =====");
    if(self.status == QtAgoraConnectStatusStop){
        self.status = QtAgoraConnectStatusConnecting;
        [self.liveKit joinChannel:self.channel key:self.agoraKey config:self.channelConfig uid:self.uid];
    }
}

// 应该可重入
-(void)stopHostin{
    NSLog(@"===== stopHostin =====");
    if(self.status == QtAgoraConnectStatusStop){
        return;
    }
    self.status = QtAgoraConnectStatusStop;
    [self.publisher unpublish];
    [self.liveKit leaveChannel];
}

-(void)unsubscribeUser:(NSUInteger)uid{
    NSLog(@"===== unsubscribeUser: %lu =====", (unsigned long)uid);
    [self.subscriber unsubscribeToHostUid:uid];
}

#pragma mark - Agora Delegate

// 加入频道成功 SDK 在加入频道失败时会自动进行重试。
- (void)liveKit:(AgoraLiveKit *)kit didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    NSLog(@"===== liveKit didJoinChannel: %@ uid: %lu =====", channel, (unsigned long)uid);
    // uid: 用户 uid 。如果在 joinChannel 时使用了 0，这里回返回服务器分配的 uid 。
    [self.publisher publishWithPermissionKey:nil];
    self.status = QtAgoraConnectStatusConnected;
    [[xNotice shared] postEvent:QtAgoraEventSelfConnected userInfo:nil];
}

// 重新加入频道成功
- (void)liveKit:(AgoraLiveKit *)kit didRejoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    NSLog(@"===== liveKit didRejoinChannel: %@ uid: %lu =====", channel, (unsigned long)uid);
    [self.publisher publishWithPermissionKey:nil];
    self.status = QtAgoraConnectStatusConnected;
    [[xNotice shared] postEvent:QtAgoraEventSelfConnected userInfo:nil];
}

// SDK 遇到错误
- (void)liveKit:(AgoraLiveKit *)kit didOccurError:(AgoraErrorCode)errorCode {
    NSLog(@"===== liveKit didOccurError: %d =====", (int)errorCode);
    if(errorCode == AgoraErrorCodeChannelKeyExpired ||
       errorCode == AgoraErrorCodeInvalidChannelKey){
        //在liveKitRequestChannelKey回调中处理
        return;
    }
    self.status = QtAgoraConnectStatusStop;
    [[xNotice shared] postEvent:QtAgoraEventSDKError userInfo:@{QtAgoraEventSDKErrorCodeKey: @((int)errorCode)}];
}

/**
 * when channel key is enabled, and specified channel key is invalid or expired, this function will be called.
 * APP should generate a new channel key and call renewChannelKey() to refresh the key.
 * NOTE: to be compatible with previous version, ERR_CHANNEL_KEY_EXPIRED and ERR_INVALID_CHANNEL_KEY are also reported via onError() callback.
 * You should move renew of channel key logic into this callback.
 *  @param kit The live kit
 */
- (void)liveKitRequestChannelKey:(AgoraLiveKit *_Nonnull)kit{
    NSLog(@"===== liveKitRequestChannelKey =====");
    [[xNotice shared] postEvent:QtAgoraEventRequestChannelKey userInfo:nil];
}

// 外部获取到新的 agoraKey 之后调用
- (void)renewChannelKey:(NSString*)agoraKey{
    NSLog(@"===== renewChannelKey: %@ =====", agoraKey);
    self.agoraKey = agoraKey;
    [self.liveKit renewChannelKey:agoraKey];
}

/**
 *  Event of disconnected with server. This event is reported at the moment SDK loses connection with server.
 *  In the mean time SDK automatically tries to reconnect with the server until APP calls leaveChannel.
 *
 *  @param kit    The live kit
 */
- (void)liveKitConnectionDidInterrupted:(AgoraLiveKit *_Nonnull)kit{
    NSLog(@"===== liveKit ConnectionDidInterrupted =====");
}

/**
 *  Event of loss connection with server. This event is reported after the connection is interrupted and exceed the retry period (10 seconds by default).
 *  In the mean time SDK automatically tries to reconnect with the server until APP calls leaveChannel.
 *
 *  @param kit    The live kit
 */
- (void)liveKitConnectionDidLost:(AgoraLiveKit *_Nonnull)kit{
    NSLog(@"===== liveKit ConnectionDidLost =====");
    [[xNotice shared] postEvent:QtAgoraEventConnectionLost userInfo:nil];
}

/**
 *  The network quality of local user.
 *
 *  @param kit     The live kit
 *  @param uid     The id of user
 *  @param txQuality The sending network quality
 *  @param rxQuality The receiving network quality
 */
- (void)liveKit:(AgoraLiveKit *_Nonnull)kit networkQuality:(NSUInteger)uid txQuality:(AgoraNetworkQuality)txQuality rxQuality:(AgoraNetworkQuality)rxQuality{
    //NSLog(@"===== liveKit networkQuality uid:%lu sendingQuality:%d receivingQuality:%d =====", (unsigned long)uid, (int)txQuality, (int)rxQuality);
    switch (txQuality){
        case AgoraNetworkQualityUnknown:
            self.networkStatus = QtAgoraNetworkStatusUnknown;
            break;
        case AgoraNetworkQualityExcellent:
        case AgoraNetworkQualityGood:
            self.networkStatus = QtAgoraNetworkStatusGood;
            break;
        case AgoraNetworkQualityPoor:
        case AgoraNetworkQualityBad:
        case AgoraNetworkQualityVBad:
            self.networkStatus = QtAgoraNetworkStatusBad;
            break;
        case AgoraNetworkQualityDown:
            self.networkStatus = QtAgoraNetworkStatusDown;
            break;
    }
}

// 收到主播踢人请求
- (void)liveKit:(AgoraLiveKit *_Nonnull)kit unpublishingRequestReceivedFromOwner:(NSUInteger)uid{
    NSLog(@"===== liveKit unpublishingRequestReceivedFromOwner: %lu =====", (unsigned long)uid);
    [[xNotice shared] postEvent:QtAgoraEventMasterCutoff userInfo:nil];
}

// 频道内主播信息
- (void)subscriber:(AgoraLiveSubscriber *)subscriber publishedByHostUid:(NSUInteger)uid streamType:(AgoraMediaType)type {
    NSLog(@"===== subscriber publishedByHostUid: %lu =====", (unsigned long)uid);
    // uid: 主播 uid 。
    if(self.delegate == nil){
        [subscriber subscribeToHostUid:uid                       // uid: 主播 uid
                             mediaType:AgoraMediaTypeAudioOnly  // mediaType: 订阅的数据类型
                                  view:nil                  // view: 视频数据渲染显示的视图
                            renderMode:AgoraVideoRenderModeHidden   // renderMode: 视频数据渲染方式
                             videoType:AgoraVideoStreamTypeHigh];   // videoType: 视频大小流
        [[xNotice shared] postEvent:QtAgoraEventPublisherConnected userInfo:@{QtAgoraEventPublisherUidKey: @(uid)}];
    }
    else{
        if([self.delegate shouldSubscribeUid:uid]){
            [subscriber subscribeToHostUid:uid                       // uid: 主播 uid
                                 mediaType:AgoraMediaTypeAudioOnly  // mediaType: 订阅的数据类型
                                      view:nil                  // view: 视频数据渲染显示的视图
                                renderMode:AgoraVideoRenderModeHidden   // renderMode: 视频数据渲染方式
                                 videoType:AgoraVideoStreamTypeHigh];   // videoType: 视频大小流
            [[xNotice shared] postEvent:QtAgoraEventPublisherConnected userInfo:@{QtAgoraEventPublisherUidKey: @(uid)}];
        }
        else{
            [_publisher sendUnpublishingRequestToUid:uid];
        }
    }
}

// 频道内主播结束直播
- (void)subscriber:(AgoraLiveSubscriber *)subscriber unpublishedByHostUid:(NSUInteger)uid {
    NSLog(@"===== subscriber unpublishedByHostUid: %lu =====", (unsigned long)uid);
    // uid: 主播uid
    [subscriber unsubscribeToHostUid:uid];
    [[xNotice shared] postEvent:QtAgoraEventPublisherDisconnected userInfo:@{QtAgoraEventPublisherUidKey: @(uid)}];
}

/**
 *  The sdk reports the volume of a speaker. The interface is disable by default, and it could be enable by API "enableAudioVolumeIndication"
 *
 *  @param engine      The engine kit
 *  @param speakers    AgoraRtcAudioVolumeInfos array
 *  @param totalVolume The total volume of speakers
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportAudioVolumeIndicationOfSpeakers:(NSArray*)speakers totalVolume:(NSInteger)totalVolume{
    //NSLog(@"===== rtcEngine reportAudioVolumeIndicationOfSpeakers =====");
    if(speakers == nil)
        return;
    if(speakers.count == 1 && ((AgoraRtcAudioVolumeInfo*)speakers[0]).uid == 0){
        //自己说话信息
        AgoraRtcAudioVolumeInfo *info = speakers[0];
        info.uid = self.uid;
        [[xNotice shared] postEvent:QtAgoraEventSelfVolumeInfo userInfo:@{QtAgoraEventSelfVolumeInfoKey:info}];
        return;
    }
    else{
        NSMutableArray<AgoraRtcAudioVolumeInfo*> *audienceArr = [[NSMutableArray<AgoraRtcAudioVolumeInfo*> alloc] init];
        for(AgoraRtcAudioVolumeInfo* info in speakers){
            if(info.uid == 0){
                //自己说话信息
                info.uid = self.uid;
                [[xNotice shared] postEvent:QtAgoraEventSelfVolumeInfo userInfo:@{QtAgoraEventSelfVolumeInfoKey:info}];
            }
            else{
                [audienceArr addObject:info];
            }
        }
        [[xNotice shared] postEvent:QtAgoraEventOthersVolumesInfo userInfo:@{QtAgoraEventOthersVolumesInfoKey:audienceArr}];
    }
}

@end
