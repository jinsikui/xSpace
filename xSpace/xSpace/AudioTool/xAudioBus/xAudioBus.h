//
//  xAudioBus.h
//  xSpace
//
//  Created by JSK on 2018/12/24.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "xABMicInput.h"
#import "xABFileInput.h"
#import "xABPcmOutput.h"
#import "xABFilter.h"
#import "xABConverter.h"
#import "xABWaveRecorder.h"

typedef enum xAudioBusState{
    xAudioBusStateStop,
    xAudioBusStateRunning,
    xAudioBusStatePaused
} xAudioBusState;

@interface xAudioBus : NSObject

+(instancetype)shared;

-(void)addMicInput:(xABMicInput*)micInput;

-(void)addFileInput:(xABFileInput*)fileInput;

-(void)addPcmOutput:(xABPcmOutput*)pcmOutput;

-(void)addFilter:(xABFilter*)filter;

-(void)addWaveRecorder:(xABWaveRecorder*)waveRecorder;

-(void)run;

-(void)pause;

-(void)stop;

-(void)reset;

@end
