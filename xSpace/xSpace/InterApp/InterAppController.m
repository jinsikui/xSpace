//
//  InterAppController.m
//  xPortal
//
//  Created by JSK on 2017/5/2.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "InterAppController.h"
#import "AppDelegate.h"

@interface InterAppController ()

@end

@implementation InterAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"其他App交互";
    self.view.backgroundColor = kColor(0xFFFFFF);
    self.latitude = 39.978077422708985;
    self.longitude = 116.48346795506615;
    //
    UIButton *btn = [xViewFactory buttonWithTitle:@"打开地图" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) borderColor:kColor(0xFF6600) borderWidth:0.5];
    btn.frame = CGRectMake(0.5*(kScreenWidth - 100), 30, 100, 40);
    [btn addTarget:self action:@selector(actionMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)actionMap{
    NSString *urlString = [@"http://maps.apple.com/?ll=39.978077422708985,116.48346795506615&q=北京" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

@end
