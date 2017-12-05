//
//  UITestController.m
//  xSpace
//
//  Created by JSK on 2017/11/22.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "UITestController.h"
#import "Masonry.h"
#import "PopView.h"

@interface UITestController ()
@property(nonatomic,strong) UILabel       *stateLabel;
@end

@implementation UITestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UI Test";
    
    _stateLabel = [xViewFactory labelWithText:@"" font:kFontRegularPF(12) color:kColorA(0x0, 1) alignment:NSTextAlignmentCenter];
    _stateLabel.numberOfLines = 2;
    [self.view addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(100);
        make.width.mas_equalTo(xDevice.screenWidth);
        make.height.mas_equalTo(40);
    }];
    _stateLabel.text = @"abc\n......";
    [_stateLabel sizeToFit];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _stateLabel.text = @"aaaaaa  bbbbbb  cccccc\nhahahhaha";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _stateLabel.text = @"aaaaaa";
        });
    });
    
    UIButton *btn = [xViewFactory buttonWithTitle:@"pop" font:kFontPF(14) titleColor:kColor(0) bgColor:UIColor.clearColor borderColor:kColor(0) borderWidth:0.5];
    [btn addTarget:self action:@selector(actionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stateLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
}

-(void)actionBtnClick{
    [[[PopView alloc] init] showInView:self.view];
}

@end
