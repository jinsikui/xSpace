//
//  QtAgoraEngine.h
//  QTRadio
//
//  Created by JSK on 2017/11/20.
//  Copyright © 2017年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcEngineKit/AgoraLiveKit.h>


extern NSString *const QtAgoraEventConnectStatusChanged;
extern NSString *const QtAgoraEventConnectStatusKey;
extern NSString *const QtAgoraEventNetworkStatusChanged;
extern NSString *const QtAgoraEventNetworkStatusKey;
extern NSString *const QtAgoraEventConnectionLost;
extern NSString *const QtAgoraEventRequestChannelKey;
extern NSString *const QtAgoraEventSDKError;
extern NSString *const QtAgoraEventSDKErrorCodeKey;
extern NSString *const QtAgoraEventSelfConnected;
extern NSString *const QtAgoraEventMasterCutoff;
extern NSString *const QtAgoraEventPublisherConnected;
extern NSString *const QtAgoraEventPublisherUidKey;
extern NSString *const QtAgoraEventPublisherDisconnected;
extern NSString *const QtAgoraEventSelfVolumeInfo;
extern NSString *const QtAgoraEventSelfVolumeInfoKey;
extern NSString *const QtAgoraEventOthersVolumesInfo;
extern NSString *const QtAgoraEventOthersVolumesInfoKey;

typedef enum QtAgoraConnectStatus{
    QtAgoraConnectStatusStop = 0,
    QtAgoraConnectStatusConnecting = 1,
    QtAgoraConnectStatusConnected = 2
} QtAgoraConnectStatus;

typedef enum QtAgoraNetworkStatus{
    QtAgoraNetworkStatusUnknown = 0,
    QtAgoraNetworkStatusGood = 1,
    QtAgoraNetworkStatusBad = 2,
    QtAgoraNetworkStatusDown = 3
} QtAgoraNetworkStatus;

@protocol QtAgoraEnginDelegate <NSObject>

-(BOOL)shouldSubscribeUid:(NSUInteger)uid;

@end

@interface QtAgoraEngine : NSObject

@property(nonatomic,copy)   NSString        *agoraKey;
@property(nonatomic,assign) QtAgoraConnectStatus    status;

- (instancetype)initWithChannel:(NSString*)channel uid:(NSUInteger)uid agoraKey:(NSString*)agoraKey;

// 外部获取到新的 agoraKey 之后调用
- (void)renewChannelKey:(NSString*)agoraKey;

//静音／关闭静音
-(void)setMuted:(BOOL)isMuted;

-(void)unsubscribeUser:(NSUInteger)uid;

-(void)startHostin;

-(void)stopHostin;

@end
