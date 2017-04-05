//
//  xRefreshFooter.m
//  xPortal
//
//  Created by JSK on 2017/3/21.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xRefreshFooter.h"

@interface xRefreshFooter()
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@property (weak, nonatomic) UIImageView *noDataView;
@end

@implementation xRefreshFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 20;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
    // no data
    UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata_icon"]];
    [self addSubview:noDataView];
    self.noDataView = noDataView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.loading.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
    self.noDataView.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            self.noDataView.hidden = YES;
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            self.noDataView.hidden = YES;
            break;
        case MJRefreshStateRefreshing:
            [self.loading startAnimating];
            self.noDataView.hidden = YES;
            break;
        case MJRefreshStateNoMoreData:
            [self.loading stopAnimating];
            self.noDataView.hidden = NO;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}

@end
