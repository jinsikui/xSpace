//
//  GradientController.m
//  xSpace
//
//  Created by JSK on 2018/6/11.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "GradientController.h"

@interface GradientController ()

@end

@implementation GradientController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Gradient";
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 150)];
    v1.backgroundColor = [UIColor redColor];
    [self.view addSubview:v1];
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(100, 250, 200, 150)];
    v2.backgroundColor = [UIColor blueColor];
    v2.clipsToBounds = NO;
    [self.view addSubview:v2];
    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    gradient.frame = CGRectMake(0, -40, 200, 40);
    UIColor *c1 = kColorA(0x0000FF, 0);
    UIColor *c2 = kColorA(0x0000FF, 1);
    gradient.colors = @[(id)c1.CGColor, (id)c2.CGColor];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [v2.layer insertSublayer:gradient atIndex:0];
}

@end
