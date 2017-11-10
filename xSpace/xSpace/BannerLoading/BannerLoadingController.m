//
//  BannerLoadingController.m
//  xPortal
//
//  Created by JSK on 2017/6/14.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "BannerLoadingController.h"
#import "UIView+xBannerLoading.h"
#import <objc/runtime.h>

@interface BannerLoadingController ()

@end

@implementation BannerLoadingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Banner Loading";
    self.view.backgroundColor = [UIColor whiteColor];
    //
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    v.backgroundColor = [UIColor redColor];
    [self.view addSubview:v];
    //
    [v startBannerLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [v stopBannerLoading];
    });
}

@end
