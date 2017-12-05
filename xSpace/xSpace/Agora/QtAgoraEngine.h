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
extern NSString *const QtAgoraEventSelfConnected;
extern NSString *const QtAgoraEventMasterCutoff;
extern NSString *const QtAgoraEventPublisherConnected;
extern NSString *const QtAgoraEventPublisherUidKey;
extern NSString *const QtAgoraEventPublisherDisconnected;
extern NSString *const QtAgoraEventSelfVolumeInfo;
extern NSString *const QtAgoraEventSelfVolumeInfoKey;
extern NSString *const QtAgoraEventAudienceVolumesInfo;
extern NSString *const QtAgoraEventAudienceVolumesInfoKey;

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

- (instancetype)initWithChannel:(NSString*)channel uid:(NSUInteger)uid;

//静音／关闭静音
-(void)setMuted:(BOOL)isMuted;

-(void)unsubscribeUser:(NSUInteger)uid;

-(void)startHostin;

-(void)stopHostin;

@end
