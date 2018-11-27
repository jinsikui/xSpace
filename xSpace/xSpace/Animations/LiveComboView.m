//
//  LiveComboView.m
//  xSpace
//
//  Created by JSK on 2018/7/18.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "LiveComboView.h"

#define HEIGHT              200.0
#define FRAMES_PER_SECONDS  24.0
#define TRACK_WIDTH         3
#define TRACK_TIME          5

@interface LiveComboView()
@property(nonatomic,strong) NSArray         *plans;
@property(nonatomic,strong) UIButton        *comboBtn;
@property(nonatomic,strong) CAShapeLayer    *comboTrackLayer;
@property(nonatomic,strong) CADisplayLink   *displayLink;
@property(nonatomic,strong) NSDate          *trackStartTime;
@property(nonatomic,strong) UIButton        *comboPlanBtn1;
@property(nonatomic,strong) UIButton        *comboPlanBtn2;
@property(nonatomic,strong) UIButton        *comboPlanBtn3;
@property(nonatomic,assign) CGPoint         comboCenter;
@end

@implementation LiveComboView

-(instancetype)initWithPlans:(NSArray<NSNumber*>*)plans{
    self = [super init];
    if(self){
        _plans = plans;
        _comboCenter = CGPointMake(xDevice.screenWidth/2, HEIGHT - 50 - 40);
        
        _comboBtn = [xViewFactory imageButton:[UIImage imageNamed:@"live-combo"]];
        _comboBtn.frame = CGRectMake(_comboCenter.x - 40, _comboCenter.y - 40, 80, 80);
        [_comboBtn addTarget:self action:@selector(actionComboBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_comboBtn];
        //倒计时圆环
        _comboTrackLayer = [CAShapeLayer layer];
        _comboTrackLayer.frame = _comboBtn.bounds;
        //设置画笔颜色 即圆环背景色
        _comboTrackLayer.strokeColor = kColorA(0xFFFFFF,0.6).CGColor;
        _comboTrackLayer.lineWidth = TRACK_WIDTH;
        _comboTrackLayer.fillColor = [xColor clearColor].CGColor;
        //设置画笔路径
        [self updateTrackByDuration:0];
        [_comboBtn.layer addSublayer:_comboTrackLayer];
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTiming)];
        _displayLink.paused = YES;
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        //中间文字
        UILabel *label = [xViewFactory labelWithText:@"连击" font:kFontMediumPF(16) color:kColor(0xFFFFFF)];
        [_comboBtn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_comboBtn);
        }];
        _comboBtn.hidden = YES;
        _comboTrackLayer.hidden = YES;
        
        _comboPlanBtn1 = [self addComboPlanBtnWithNum:[_plans[0] intValue]];
        _comboPlanBtn2 = [self addComboPlanBtnWithNum:[_plans[1] intValue]];
        _comboPlanBtn3 = [self addComboPlanBtnWithNum:[_plans[2] intValue]];
        _comboPlanBtn1.hidden = YES;
        _comboPlanBtn2.hidden = YES;
        _comboPlanBtn3.hidden = YES;
        
        [self bringSubviewToFront:_comboBtn];
    }
    return self;
}

-(UIButton*)addComboPlanBtnWithNum:(int)num{
    UIButton *btn = [xViewFactory imageButton:[UIImage imageNamed:@"live-combo-plan"]];
    btn.frame = CGRectMake(_comboCenter.x - 25, _comboCenter.y - 25, 50, 50);
    [btn addTarget:self action:@selector(actionComboPlanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    UILabel *label = [xViewFactory labelWithText:[NSString stringWithFormat:@"%d",num] font:kFontMediumPF(15) color:kColor(0xFFFFFF)];
    [btn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(btn);
    }];
    return btn;
}

-(void)show{
    _comboBtn.hidden = NO;
    _comboBtn.frame = CGRectMake(_comboCenter.x - 40, HEIGHT, 80, 80);
    [UIView animateWithDuration:7/FRAMES_PER_SECONDS animations:^{
        _comboBtn.frame = CGRectMake(_comboCenter.x - 40, _comboCenter.y - 40, 80, 80);
    } completion:^(BOOL finished) {
        _comboPlanBtn1.hidden = NO;
        _comboPlanBtn2.hidden = NO;
        _comboPlanBtn3.hidden = NO;
        [UIView animateWithDuration:7/FRAMES_PER_SECONDS delay:3/FRAMES_PER_SECONDS options:0 animations:^{
            _comboPlanBtn1.frame = CGRectMake(_comboCenter.x + 62, _comboCenter.y - 68, 50, 50);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2/FRAMES_PER_SECONDS animations:^{
                _comboPlanBtn1.frame = CGRectMake(_comboCenter.x + 50, _comboCenter.y - 61, 50, 50);
            }];
        }];
        [UIView animateWithDuration:7/FRAMES_PER_SECONDS delay:5/FRAMES_PER_SECONDS options:0 animations:^{
            _comboPlanBtn2.frame = CGRectMake(_comboCenter.x - 25, _comboCenter.y - 121, 50, 50);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2/FRAMES_PER_SECONDS animations:^{
                _comboPlanBtn2.frame = CGRectMake(_comboCenter.x - 25, _comboCenter.y - 110, 50, 50);
            }];
        }];
        [UIView animateWithDuration:7/FRAMES_PER_SECONDS delay:7/FRAMES_PER_SECONDS options:0 animations:^{
            _comboPlanBtn3.frame = CGRectMake(_comboCenter.x - 112, _comboCenter.y - 68, 50, 50);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2/FRAMES_PER_SECONDS animations:^{
                _comboPlanBtn3.frame = CGRectMake(_comboCenter.x - 100, _comboCenter.y - 61, 50, 50);
            } completion:^(BOOL finished) {
                _comboTrackLayer.hidden = NO;
                [self startTiming];
            }];
        }];
    }];
}

-(void)updateTrackByDuration:(NSTimeInterval)duration{
    float ratio;
    if(duration > TRACK_TIME){
        ratio = 1;
    }
    else{
        ratio = duration/TRACK_TIME;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(40, 40) radius:40-TRACK_WIDTH/2.0 startAngle:-M_PI_2+M_PI*2*ratio endAngle:-M_PI_2+M_PI*2 clockwise:YES];
    _comboTrackLayer.path = path.CGPath;
}

-(void)startTiming{
    _trackStartTime = [NSDate date];
    _displayLink.paused = NO;
}

-(void)updateTiming{
    if(!_trackStartTime){
        return;
    }
    double duration = [[NSDate date] timeIntervalSinceDate:_trackStartTime];
    if(duration >= TRACK_TIME){
        _displayLink.paused = YES;
        [_displayLink invalidate];
        [self updateTrackByDuration:duration];
        [self notifyTimeout];
    }
    else{
        [self updateTrackByDuration:duration];
    }
}

-(void)resetTiming{
    _trackStartTime = [NSDate date];
}

-(void)notifyTimeout{
    LiveComboViewTimeoutCallback callback = self.timeoutCallback;
    if(callback){
        callback();
    }
}

-(void)notifyAmount:(NSInteger)amount{
    LiveComboViewAmountCallback callback = self.amountCallback;
    if(callback){
        callback(amount);
    }
}

-(void)actionComboBtnClick{
    [self resetTiming];
    [self notifyAmount:1];
}

-(void)actionComboPlanBtnClick:(UIButton*)planBtn{
    [self resetTiming];
    NSInteger amount;
    if(planBtn == _comboPlanBtn1){
        amount = [_plans[0] integerValue];
    }
    else if(planBtn == _comboPlanBtn2){
        amount = [_plans[1] integerValue];
    }
    else{
        amount = [_plans[2] integerValue];
    }
    [self notifyAmount:amount];
}

-(void)dealloc{
    _displayLink.paused = YES;
    [_displayLink invalidate];
}

@end
