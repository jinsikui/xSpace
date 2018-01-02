//
//  BlurViewController.m
//  xSpace
//
//  Created by JSK on 2017/12/30.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "BlurViewController.h"
#import "xBlurView.h"

@interface BlurViewController ()

@end

@implementation BlurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = kColor(0xFFFFFF);
    
//    UIImage *bgImg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pic" ofType:@"jpg"]];
//    //
//    xBlurView *blurView = [[xBlurView alloc] init];
//    [blurView setContentImage:bgImg frame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) alpha:0];
//    [self.view addSubview:blurView];
//    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(0);
//    }];
    
    UIImage *bgImg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pic" ofType:@"jpg"]];
    UIImageView *imgview = [[UIImageView alloc] initWithImage:bgImg];
    [self.view addSubview:imgview];
    [imgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    //
    UIView *panel = [[UIView alloc] init];
    panel.backgroundColor = xColor.clearColor;
    [self.view addSubview:panel];
    [panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(200);
        make.height.mas_equalTo(200);
    }];
    /*
    UIBlurEffectStyleExtraLight,
    UIBlurEffectStyleLight,
    UIBlurEffectStyleDark
     */
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [panel addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}
@end
