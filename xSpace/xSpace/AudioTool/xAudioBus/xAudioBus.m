//
//  xAudioBus.m
//  xSpace
//
//  Created by JSK on 2018/12/24.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "xAudioBus.h"

@interface xAudioBus()
@property(nonatomic) xAudioBusState *state;
@property(nonatomic) xABMicInput *micInput;
@property(nonatomic) NSMutableArray *fileInputList;
@property(nonatomic) NSMutableArray *filterList;
@property(nonatomic) xABPcmOutput *pcmOutput;

@end

@implementation xAudioBus{
    
}

+(instancetype)shared{
    static xAudioBus *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[xAudioBus alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if(!self) return nil;
    _fileInputList = [NSMutableArray array];
    _fileInputList = [NSMutableArray array];
    return self;
}

-(void)addMicInput:(xABMicInput*)micInput{
    self.micInput = micInput;
}

-(void)addFileInput:(xABFileInput*)fileInput{
    [_fileInputList addObject:fileInput];
}

-(void)addPcmOutput:(xABPcmOutput*)pcmOutput{
    self.pcmOutput = pcmOutput;
}

-(void)addFilter:(xABFilter*)filter{
    
}

-(void)addWaveRecorder:(xABWaveRecorder*)waveRecorder{
    
}

-(void)run{
    
}

-(void)pause{
    
}

-(void)stop{
    
}

-(void)reset{
    
}

@end
