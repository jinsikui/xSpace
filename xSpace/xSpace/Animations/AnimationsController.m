//
//  AnimationsController.m
//  xSpace
//
//  Created by JSK on 2018/7/17.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "AnimationsController.h"
#import "LiveComboTopView.h"
#import "LiveComboView.h"

#define PANEL_WIDTH         200.0
#define PANEL2_HEIGHT       200.0


@interface AnimationsController ()
@property(nonatomic,strong) LiveComboTopView    *comboTopView;
@property(nonatomic,strong) LiveComboView       *comboView;
@property(nonatomic,assign) NSInteger           totalAmount;
@end

@implementation AnimationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Animations";
    self.view.backgroundColor = kColor(0);
    
    UIView *panel = [UIView new];
    [self.view addSubview:panel];
    [panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-200);
        make.width.height.mas_equalTo(PANEL_WIDTH);
    }];
    _comboTopView = [[LiveComboTopView alloc] init];
    [panel addSubview:_comboTopView];
    [_comboTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(panel);
        make.width.height.mas_equalTo(30);
    }];
    [_comboTopView setInitNum:1];
    
    panel = [UIView new];
    [self.view addSubview:panel];
    [panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(PANEL2_HEIGHT);
    }];
    _comboView = [[LiveComboView alloc] initWithPlans:@[@10,@20,@30]];
    __weak typeof(self) weak = self;
    _comboView.timeoutCallback = ^{
        [weak.comboView removeFromSuperview];
    };
    _comboView.amountCallback = ^(NSInteger amount) {
        weak.totalAmount += amount;
        [weak.comboTopView refreshByNum:weak.totalAmount];
    };
    [panel addSubview:_comboView];
    [_comboView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [_comboView show];
    _totalAmount = 1;
}

@end
