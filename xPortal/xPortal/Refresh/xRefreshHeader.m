//
//  xRefreshHeader.m
//  xPortal
//
//  Created by JSK on 2017/3/21.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xRefreshHeader.h"
#import "FLAnimatedImage.h"

@interface xRefreshHeader(){
}
@property(nonatomic, strong) UIImage             *staticImage;
@property(nonatomic, strong) FLAnimatedImage     *gifImage;
@property(nonatomic, strong) FLAnimatedImageView *imageView;
@property(nonatomic, assign) BOOL                isAnimating;
@property(nonatomic, strong) UILabel             *label;
@end
@implementation xRefreshHeader

- (void)prepare
{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 77;
    //
    NSString *path = [[NSBundle mainBundle] pathForResource:@"refresh" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _gifImage = [FLAnimatedImage animatedImageWithGIFData:data];
    _staticImage = _gifImage.posterImage;
    //
    _imageView = [[FLAnimatedImageView alloc] init];
    _imageView.image = _staticImage;
    [self addSubview:_imageView];
    //
    _label = [[UILabel alloc] init];
    _label.textColor = kColor_333333;
    _label.font = kFontPF(11);
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
    __weak typeof(self) weak = self;
    self.endRefreshingCompletionBlock = ^{
        weak.label.text = @"下拉刷新";
    };
}

-(void)startAnimation{
    if(!_isAnimating){
        _imageView.image = nil;
        _imageView.animatedImage = _gifImage;
        _isAnimating = YES;
    }
}

-(void)stopAnimation{
    if(_isAnimating){
        _imageView.image = _staticImage;
        _imageView.animatedImage = nil;
        _isAnimating = NO;
    }
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    _imageView.frame = CGRectMake(0.5*(kScreenWidth - _gifImage.size.width/2.0), 0, _gifImage.size.width/2.0, _gifImage.size.height/2.0);
    _label.frame = CGRectMake(0, self.mj_h - 31, self.mj_w, 31);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    CGFloat y = [change[@"new"] CGPointValue].y;
    if(y<=-self.ignoredScrollViewContentInsetTop-40){
        if([self.label.text isEqualToString:@"下拉刷新"]){
            self.label.text = @"继续下拉";
        }
    }
    else{
        if([self.label.text isEqualToString:@"继续下拉"]){
            self.label.text = @"下拉刷新";
        }
    }
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
            if(oldState == MJRefreshStateRefreshing){
                self.label.text = @"";
            }
            else{
                self.label.text = @"下拉刷新";
            }
            [self stopAnimation];
            break;
        case MJRefreshStatePulling:
            self.label.text = @"松开立即刷新";
            [self stopAnimation];
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在刷新";
            [self startAnimation];
            break;
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
