//
//  PagedController.m
//  xPortal
//
//  Created by JSK on 2017/6/2.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "PagedController.h"
#import "xPagedView.h"

@interface PagedController ()

@end

@implementation PagedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分页";
    self.view.backgroundColor = kColor(0xFFFFFF);
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    UIView *v;
    v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 200)];
    v.backgroundColor = [UIColor redColor];
    [scrollView addSubview:v];
    v = [[UIView alloc] initWithFrame:CGRectMake(160, 0, 160, 200)];
    v.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:v];
    v = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 160, 200)];
    v.backgroundColor = [UIColor blueColor];
    [scrollView addSubview:v];
    v = [[UIView alloc] initWithFrame:CGRectMake(480, 0, 160, 200)];
    v.backgroundColor = [UIColor yellowColor];
    [scrollView addSubview:v];
    v = [[UIView alloc] initWithFrame:CGRectMake(640, 0, 160, 200)];
    v.backgroundColor = [UIColor cyanColor];
    [scrollView addSubview:v];
    scrollView.contentSize = CGSizeMake(800, 200);
    
    xPagedView *pagedView = [[xPagedView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 200)];
    [self.view addSubview:pagedView];
    pagedView.scrollView = scrollView;
    pagedView.pageWidth = 160;
}

@end
