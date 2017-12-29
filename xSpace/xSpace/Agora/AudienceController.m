//
//  AudienceController.m
//  xSpace
//
//  Created by JSK on 2017/11/24.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "AudienceController.h"
#import "QtAgoraEngine.h"
#import <AVFoundation/AVAudioSession.h>

@interface AudienceController ()
@property(nonatomic,strong) QtAgoraEngine   *agoraEngine;
@end

@implementation AudienceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Agora Audience";
    
    ///测试
    if(_agoraEngine == nil){
        _agoraEngine = [[QtAgoraEngine alloc] initWithChannel:@"100000000" uid:1000 agoraKey:nil];
        [[xNotice shared] registerEvent:QtAgoraEventSelfConnected lifeIndicator:self action:^(id param) {
            NSLog(@"===== SelfConnected =====");
        }];
        [[xNotice shared] registerEvent:QtAgoraEventPublisherConnected lifeIndicator:self action:^(id param) {
            NSUInteger uid = [param[QtAgoraEventPublisherUidKey] unsignedIntegerValue];
            NSLog(@"===== PublisherConnected:%lu =====", (unsigned long)uid);
        }];
        [[xNotice shared] registerEvent:QtAgoraEventPublisherDisconnected lifeIndicator:self action:^(id param) {
            NSLog(@"===== PublisherDisconnected =====");
        }];
        [[xNotice shared] registerEvent:QtAgoraEventMasterCutoff lifeIndicator:self action:^(id param) {
            NSLog(@"===== MasterCutoff =====");
        }];
    }
    [_agoraEngine startHostin];
}

-(void)dealloc{
    [_agoraEngine stopHostin];
}

@end
