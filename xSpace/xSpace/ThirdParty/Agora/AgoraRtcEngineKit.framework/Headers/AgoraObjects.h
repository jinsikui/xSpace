//
//  AgoraLiveKit.h
//  AgoraLiveKit
//
//  Created by Junhao Wang
//  Copyright (c) 2017 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraEnumerates.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
typedef UIView VIEW_CLASS;
typedef UIColor COLOR_CLASS;
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
typedef NSView VIEW_CLASS;
typedef NSColor COLOR_CLASS;
#endif

// channel
__attribute__((visibility("default"))) @interface AgoraChannelStats: NSObject
@property (assign, nonatomic) NSInteger duration;
@property (assign, nonatomic) NSInteger txBytes;
@property (assign, nonatomic) NSInteger rxBytes;
@property (assign, nonatomic) NSInteger txAudioKBitrate;
@property (assign, nonatomic) NSInteger rxAudioKBitrate;
@property (assign, nonatomic) NSInteger txVideoKBitrate;
@property (assign, nonatomic) NSInteger rxVideoKBitrate;
@property (assign, nonatomic) NSInteger userCount;
@property (assign, nonatomic) double cpuAppUsage;
@property (assign, nonatomic) double cpuTotalUsage;
@end

__attribute__((visibility("default"))) @interface AgoraLiveTranscodingUser: NSObject
@property (assign, nonatomic) NSUInteger uid;
@property (assign, nonatomic) CGRect rect;
@property (assign, nonatomic) NSInteger zOrder; //optional, [0, 100] //0 (default): bottom most, 100: top most
@property (assign, nonatomic) double alpha; //optional, [0, 1.0] where 0 denotes throughly transparent, 1.0 opaque
@end

__attribute__((visibility("default"))) @interface AgoraLiveTranscoding: NSObject
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) NSInteger videoBitrate;
@property (assign, nonatomic) NSInteger videoFramerate;
@property (assign, nonatomic) BOOL lowLatency;

@property (assign, nonatomic) NSInteger videoGop;
@property (assign, nonatomic) AgoraVideoCodecProfileType videoCodecProfile;

@property (strong, nonatomic) COLOR_CLASS *_Nullable backgroundColor;
@property (copy, nonatomic) NSArray<AgoraLiveTranscodingUser *> *_Nullable transcodingUsers;
@property (copy, nonatomic) NSString *_Nullable transcodingExtraInfo;

@property (assign, nonatomic) AgoraAudioSampleRateType audioSampleRate;
@property (assign, nonatomic) NSInteger audioBitrate;  //kbps
@property (assign, nonatomic) AgoraAudioChannelType audioChannel;

+(AgoraLiveTranscoding *_Nonnull) defaultTranscoding;
@end

