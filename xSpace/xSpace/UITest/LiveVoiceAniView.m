//
//  LiveVoiceAniView.m
//  xSpace
//
//  Created by JSK on 2018/10/22.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "LiveVoiceAniView.h"

@interface LiveVoiceAniView()
@property(nonatomic,strong) CALayer *layer1;
@property(nonatomic,strong) CALayer *layer2;
@property(nonatomic,assign) CGFloat avatarWidth;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) double duration;
@property(nonatomic,assign) BOOL isAnimationStart;
@end

@implementation LiveVoiceAniView

-(instancetype)initWithAvatarWidth:(CGFloat)avatarWidth{
    self = [super init];
    if(self){
        _avatarWidth = avatarWidth;
        _width = avatarWidth * 144.0/100;
        _duration = 0.8;
        //创建圆环1
        _layer1 = [CALayer layer];
        _layer1.frame = CGRectMake(_width/2 - _avatarWidth/2, _width/2 - _avatarWidth/2, _avatarWidth, _avatarWidth);
        _layer1.cornerRadius = avatarWidth;
        _layer1.borderWidth = 0;
        _layer1.borderColor = kColor(0xFFFFFF).CGColor;
        [self.layer addSublayer:_layer1];
        //创建圆环2
        _layer2 = [CALayer layer];
        _layer2.frame = CGRectMake(_width/2 - _avatarWidth/2, _width/2 - _avatarWidth/2, _avatarWidth, _avatarWidth);
        _layer2.cornerRadius = avatarWidth;
        _layer2.borderWidth = 0;
        _layer2.borderColor = kColor(0xFFFFFF).CGColor;
        [self.layer addSublayer:_layer2];
    }
    return self;
}

-(void)startAnimation{
    if(_isAnimationStart){
        return;
    }
    _isAnimationStart = YES;
    CFTimeInterval beginTime1 = CACurrentMediaTime();
    CFTimeInterval beginTime2 = beginTime1 + _duration / 2;
    [_layer1 addAnimation:[self createAnimation:beginTime1] forKey:@"animation"];
    [_layer2 addAnimation:[self createAnimation:beginTime2] forKey:@"animation"];
}

-(CAAnimation*)createAnimation:(CFTimeInterval)beginTime{
    CABasicAnimation *boundsAni = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAni.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _avatarWidth, _avatarWidth)];
    boundsAni.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _width, _width)];
    
    CABasicAnimation *cornerAni = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerAni.fromValue = @(_avatarWidth/2);
    cornerAni.toValue = @(_width/2);
    
    CABasicAnimation *borderAni = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    borderAni.fromValue = @(0);
    borderAni.toValue = @((_width - _avatarWidth)/2);
    
    CABasicAnimation *opacityAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAni.fromValue = @(0.4);
    opacityAni.toValue = @(0);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = _duration;
    group.beginTime = beginTime;
    group.animations = @[boundsAni, cornerAni, borderAni, opacityAni];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = HUGE_VALF;
    return group;
}

-(void)stopAnimation{
    if(!_isAnimationStart){
        return;
    }
    [_layer1 removeAllAnimations];
    [_layer2 removeAllAnimations];
    _isAnimationStart = NO;
}

-(void)dealloc{
    [self stopAnimation];
    NSLog(@"===== LiveVoiceAniView dealloc =====");
}

@end
