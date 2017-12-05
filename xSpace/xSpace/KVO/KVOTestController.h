//
//  KVOController.h
//  xSpace
//
//  Created by JSK on 2017/11/22.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "PortalBaseController.h"

typedef enum HostinState{
    HostinStateInit = 0,
    HostinStateRequest = 1,
    HostinStateTalking = 2,
    HostinStateHangOffByMaster = 3,
    HostinStateHangOffBySelf = 4,
    HostinStateError = 5
} HostinState;

@interface KVOTestController : PortalBaseController

@property(nonatomic, assign)    HostinState state;
@property(nonatomic, assign)    NSUInteger  talkingTime; //seconds

@end
