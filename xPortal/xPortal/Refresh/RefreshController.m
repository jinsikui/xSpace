//
//  RefreshController.m
//  xPortal
//
//  Created by JSK on 2017/3/20.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "RefreshController.h"
#import "FLAnimatedImage.h"
#import "xRefreshHeader.h"
#import "xRefreshFooter.h"
#import "MJRefresh.h"

@interface RefreshController ()<UIScrollViewDelegate>{
}
@property(nonatomic, strong) UIScrollView   *scroll;
@end

@implementation RefreshController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上下拉刷新";
    self.view.backgroundColor = [UIColor whiteColor];
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentHeight)];
    [self.view addSubview:_scroll];
    _scroll.alwaysBounceVertical = YES;
    _scroll.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentHeight+100)];
    view.backgroundColor = kColor_FD8238;
    [_scroll addSubview:view];
    _scroll.contentSize = CGSizeMake(0, kContentHeight+100);
    //
    _scroll.mj_header = [xRefreshHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_scroll.mj_header endRefreshing];
        });
    }];
    _scroll.mj_footer = [xRefreshFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_scroll.mj_footer endRefreshing];
            // 结束刷新并设置没有更多数据
            //[_scroll.mj_footer endRefreshingWithNoMoreData];
            // 重新变为有数据状态
            //[_scroll.mj_footer resetNoMoreData];
        });
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

@end
