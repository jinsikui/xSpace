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
    self.view.backgroundColor = kColor_FFFFFF;
    self.latitude = 39.978077422708985;
    self.longitude = 116.48346795506615;
    //
    [self.view addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 30, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"打开地图" font:kFontPF(14) target:self selector:@selector(actionMap)]];
}

- (void)actionMap{
    NSString *urlString = [@"http://maps.apple.com/?ll=39.978077422708985,116.48346795506615&q=北京" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

@end
