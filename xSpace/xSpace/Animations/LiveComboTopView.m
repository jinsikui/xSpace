//
//  LiveComboTopView.m
//  xSpace
//
//  Created by JSK on 2018/7/18.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "LiveComboTopView.h"
#import "xHeaders.h"

#define FRAMES_PER_SECONDS  24.0
#define WIDTH               30.0


@interface LiveComboTopView()
@property(nonatomic,strong) UIView          *container;
@property(nonatomic,strong) UILabel         *numLabel;
@property(nonatomic,strong) CALayer         *circleLayer;
@property(nonatomic,strong) NSMutableArray  *lineLayers;
@property(nonatomic,strong) NSArray         *degrees;
@end

@implementation LiveComboTopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _container = [UIView new];
        [self addSubview:_container];
        [_container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        //创建数字
        _numLabel = [xViewFactory labelWithText:@"x1" font:kFontSemiboldPF(12) color:kColor(0xFFE548)];
        [_container addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        //创建圆环
        _circleLayer = [CALayer layer];
        _circleLayer.frame = CGRectMake(WIDTH/2 - 15, WIDTH/2 - 15, 30, 30);
        _circleLayer.cornerRadius = 15;
        _circleLayer.borderWidth = 2.5;
        _circleLayer.borderColor = kColor(0xFFE548).CGColor;
        [_container.layer addSublayer:_circleLayer];
        
        //创建线
        _degrees = @[@30, @90, @150, @210, @270, @330];
        _lineLayers = [NSMutableArray array];
        for(NSNumber *degreeNum in _degrees){
            CALayer *lineLayer = [CALayer layer];
            lineLayer.anchorPoint = CGPointMake(-0.25, 0.5);
            lineLayer.frame = CGRectMake(WIDTH/2 + 10, WIDTH/2 - 1, 40, 2);
            lineLayer.backgroundColor = kColor(0xFFE548).CGColor;
            lineLayer.transform = CATransform3DMakeRotation(degreeNum.floatValue * M_PI/180.0, 0, 0, 1);
            [_container.layer addSublayer:lineLayer];
            [_lineLayers addObject:lineLayer];
        }
        _container.hidden = YES;
    }
    return self;
}

-(void)setInitNum:(NSInteger)num{
    _container.hidden = NO;
    _circleLayer.hidden = YES;
    for(CALayer *layer in _lineLayers){
        layer.hidden = YES;
    }
    _numLabel.text = [NSString stringWithFormat:@"x%ld", (long)num];
    _numLabel.layer.transform = CATransform3DMakeScale(18.0/12, 18.0/12, 1);
}

-(void)refreshByNum:(NSInteger)num{
    
    _container.hidden = NO;
    CFTimeInterval beginTime = CACurrentMediaTime();
    
    _numLabel.text = [NSString stringWithFormat:@"x%ld", (long)num];
    [_numLabel.layer removeAllAnimations];
    CAKeyframeAnimation *labelAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    labelAni.values = @[@(12.0/12),@(24.0/12),@(15.0/12),@(18.0/12)];
    labelAni.keyTimes = @[@(0),@(3.0/10),@(7.0/10),@(10.0/10)];
    labelAni.duration = 10.0/FRAMES_PER_SECONDS;
    labelAni.beginTime = beginTime;
    labelAni.removedOnCompletion = NO;
    labelAni.fillMode = kCAFillModeForwards;
    [_numLabel.layer addAnimation:labelAni forKey:@"labelAnimation"];
    
    _circleLayer.hidden = NO;
    [_circleLayer removeAllAnimations];
    NSArray *keyTimes = @[@(0), @(3.0/5.0), @(1)];
    CAKeyframeAnimation *boundsAni = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    boundsAni.values = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 30, 30)],
                         [NSValue valueWithCGRect:CGRectMake(0, 0, 60, 60)],
                         [NSValue valueWithCGRect:CGRectMake(0, 0, 72, 72)]];
    boundsAni.keyTimes = keyTimes;
    
    CAKeyframeAnimation *cornerAni = [CAKeyframeAnimation animationWithKeyPath:@"cornerRadius"];
    cornerAni.values = @[@15, @30, @36];
    cornerAni.keyTimes = keyTimes;
    
    CAKeyframeAnimation *borderAni = [CAKeyframeAnimation animationWithKeyPath:@"borderWidth"];
    borderAni.values = @[@2.5, @1, @1];
    borderAni.keyTimes = keyTimes;
    
    CAKeyframeAnimation *opacityAni = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAni.values = @[@1, @1, @0];
    opacityAni.keyTimes = keyTimes;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 5.0/FRAMES_PER_SECONDS;;
    group.beginTime = beginTime;
    group.animations = @[boundsAni, cornerAni, borderAni, opacityAni];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [_circleLayer addAnimation:group forKey:@"circleAnimation"];
    
    for(int i=0; i<_degrees.count; i++){
        float degree = [_degrees[i] floatValue];
        CALayer *lineLayer = _lineLayers[i];
        lineLayer.hidden = NO;
        [lineLayer removeAllAnimations];
        CAAnimation *ani = [self getLineAnimationWithDegree:degree beginTime:beginTime];
        [lineLayer addAnimation:ani forKey:@"lineAnimation"];
    }
}

-(CAAnimation*)getLineAnimationWithDegree:(float)degree beginTime:(CFTimeInterval)beginTime{
    
    //rotation on z axis
    NSArray *scaleSpecs = @[@[@0,@0],@[@0.1,@0.4],@[@0.3,@0.7],@[@0.9,@1],@[@1,@1]];
    NSArray *keyTimes = @[@(0.0),@(3.0/8),@(5.0/8),@(7.0/8),@(8.0/8)];
    NSMutableArray *transforms = [NSMutableArray new];
    for(NSArray *spec in scaleSpecs){
        CATransform3D transform = CATransform3DIdentity;
        //先缩放scale，再沿x平移moveX
        float startPercent = [spec[0] floatValue];
        float endPercent = [spec[1] floatValue];
        float scale = endPercent - startPercent;
        float startXAfterScale = 10 * scale;
        float startX = 10 + 40 * startPercent;
        float moveX = startX - startXAfterScale;
        transform = CATransform3DRotate(transform, degree * M_PI/180.0, 0, 0, 1);
        transform = CATransform3DTranslate(transform, moveX, 0, 0);
        transform = CATransform3DScale(transform, scale, 1, 1);
        [transforms addObject:[NSValue valueWithCATransform3D:transform]];
    }
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    ani.values = transforms;
    ani.keyTimes = keyTimes;
    ani.duration = 8.0/FRAMES_PER_SECONDS;
    ani.beginTime = beginTime;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    return ani;
}

@end
