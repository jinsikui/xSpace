//
//  PopView.m
//  xSpace
//
//  Created by JSK on 2017/11/24.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "PopView.h"

static CGFloat const panelHeight = 200;

@interface PopView()<UIGestureRecognizerDelegate>
@property(nonatomic,strong) UIView  *panel;
@end

@implementation PopView

-(instancetype)init{
    self = [super init];
    if(!self){
        return nil;
    }
    //
    self.backgroundColor = kColorA(0, 0.6);
    UIGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionCoverClick)];
    g.delegate = self;
    [self addGestureRecognizer:g];
    //
    UIImageView *panel = [[UIImageView alloc] init];
    panel.userInteractionEnabled = YES;
    panel.clipsToBounds = YES;
    self.panel = panel;
    //
    UIImage *bgImg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"liveshow-bg" ofType:@"jpg"]];
    panel.image = bgImg;
    panel.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:panel];
    [panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(panelHeight);
        make.top.equalTo(self.mas_bottom);
    }];
    return self;
}

-(void)showInView:(UIView*)view{
    if(self.superview != nil){
        return;
    }
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    [self.panel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(panelHeight);
        make.top.equalTo(self.mas_bottom);
    }];
    [self layoutIfNeeded];
    
    //panel从下往上动画
    [self.panel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(panelHeight);
        make.bottom.mas_equalTo(0);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)hide{
    [self removeFromSuperview];
}

-(void)actionCoverClick{
    [self hide];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return touch.view == gestureRecognizer.view;
}

@end
