//
//  SVGAController.m
//  xSpace
//
//  Created by JSK on 2018/11/26.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "SVGAController.h"
#import "SVGA.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface SVGAController ()<SVGAPlayerDelegate>
@property(nonatomic)    UIView     *box;
@property(nonatomic)    SVGAPlayer *player;
@property(nonatomic)    SVGAParser *parser;
@end

@implementation SVGAController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    _box = [UIView new];
    [self.view addSubview:_box];
    [_box mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kScreenWidth);
        make.center.equalTo(self.view);
    }];
    
    UIButton *btn = [xViewFactory buttonWithTitle:@"press" font:kFontPF(18) titleColor:kColor(0) bgColor:[UIColor clearColor] borderColor:kColor(0) borderWidth:0.5];
    [btn addTarget:self action:@selector(actionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(30);
        make.top.equalTo(self.box.mas_bottom).offset(30);
    }];
    
    _parser = [[SVGAParser alloc] init];
    _player = [[SVGAPlayer alloc] init];
    _player.delegate = self;
    _player.loops = 1;
    [_box addSubview:_player];
    __weak typeof(self) weak = self;
    [_parser parseWithURL:[NSURL URLWithString:@"https://appuploader.oss-cn-hangzhou.aliyuncs.com/user/83db6b696119934562ede26849edb9e9/love.svga"] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        if (videoItem != nil) {
            NSLog(@"===== time:%f =====", ((double)videoItem.frames) / videoItem.FPS);
            CGFloat rate = videoItem.videoSize.height / videoItem.videoSize.width;
            CGFloat width = kScreenWidth;
            CGFloat height = rate * width;
            CGFloat x = 0;
            CGFloat y = 0.5 * (kScreenWidth - height);
            weak.player.frame = CGRectMake(x,y,width,height);
            weak.player.videoItem = videoItem;
            [weak.player startAnimation];
        }
    } failureBlock:^(NSError *error){
        NSLog(@"===== svga error: %@ =====", error);
    }];
}

- (void)actionBtnClick{
    NSLog(@"===== btn click =====");
}

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
    NSLog(@"===== svgaPlayerDidFinishedAnimation: =====");
}


@end
