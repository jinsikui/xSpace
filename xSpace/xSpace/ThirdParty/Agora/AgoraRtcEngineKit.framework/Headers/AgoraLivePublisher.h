//
//  AgoraLiveKit.h
//  AgoraLiveKit
//
//  Created by Sting Feng on 2015-8-11.
//  Copyright (c) 2015 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraObjects.h"

@class AgoraLiveKit;
@class AgoraLivePublisher;

@protocol AgoraLivePublisherDelegate <NSObject>
@optional

-(void)publisher: (AgoraLivePublisher *_Nonnull)publisher streamPublishedWithUrl:(NSString *_Nonnull)url error:(AgoraErrorCode)error;
-(void)publisher: (AgoraLivePublisher *_Nonnull)publisher streamUnpublishedWithUrl:(NSString *_Nonnull)url;
-(void)publisherTranscodingUpdated: (AgoraLivePublisher *_Nonnull)publisher;

-(void)publisher: (AgoraLivePublisher *_Nonnull)publisher publishingRequestReceivedFromUid:(NSUInteger)uid;
@end


__attribute__((visibility("default"))) @interface AgoraLivePublisher: NSObject

-(void)setDelegate:(_Nullable id<AgoraLivePublisherDelegate>)delegate;

-(instancetype _Nonnull)initWithLiveKit:(AgoraLiveKit * _Nonnull)kit;

- (void)setVideoResolution:(CGSize)resolution andFrameRate:(NSInteger)frameRate bitrate: (NSInteger)bitrate;

-(void)setLiveTranscoding:(AgoraLiveTranscoding *_Nullable) transcoding;

-(void)setMediaType:(AgoraMediaType)mediaType;

-(void)addStreamUrl:(NSString *_Nullable)url transcodingEnabled:(BOOL)transcodingEnabled;

-(void)removeStreamUrl:(NSString *_Nullable)url;

-(void)publishWithPermissionKey:(NSString *_Nullable) permissionKey;

-(void)unpublish;

- (int)answerPublishingRequestOfUid:(NSUInteger) uid accepted:(bool)accepted;

- (int)sendUnpublishingRequestToUid:(NSUInteger) uid;

-(void)switchCamera;

//-(void)setExternalVideoSource:(AgoraLiveExteranalVideoSource *)source;
@end
