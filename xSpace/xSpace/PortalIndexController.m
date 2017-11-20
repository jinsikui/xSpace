

#import "PortalIndexController.h"
#import "xPhotoBrowserController.h"
#import "AutoLayoutController.h"
#import "OCController.h"
#import "PortalNavigationController.h"
#import "EventController.h"
#import "CoreDataController.h"
#import "RefreshController.h"
#import "FMDBController.h"
#import "InterAppController.h"
#import "WVJBController.h"
#import "UIImageView+WebCache.h"
#import "PagedController.h"
#import "BannerLoadingController.h"
#import "RuntimeController.h"
#import "PhotoBannerController.h"
#import "PlayerController.h"
#import "QTNetworkController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface PortalIndexController ()
@property(nonatomic,strong)UIView *affineShowingPanel;
@end

@implementation PortalIndexController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = kColor(0xFFFFFF);
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentHeight)];
    contentView.alwaysBounceVertical = YES;
    [self.view addSubview:contentView];
    UIButton *btn = [xViewFactory buttonWithTitle:@"图片浏览" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 30, 100, 40)];
    [btn addTarget:self action:@selector(actionShowPhotoBrowser) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"AutoLayout" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 90, 100, 40)];
    [btn addTarget:self action:@selector(actionShowAutoLayout) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"OC语法" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 150, 100, 40)];
    [btn addTarget:self action:@selector(actionShowOC) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"事件处理" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 210, 100, 40)];
    [btn addTarget:self action:@selector(actionShowEvent) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"CoreData" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 270, 100, 40)];
    [btn addTarget:self action:@selector(actionShowCoreData) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"FMDB" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 330, 100, 40)];
    [btn addTarget:self action:@selector(actionFMDB) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"下拉刷新" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 390, 100, 40)];
    [btn addTarget:self action:@selector(actionRefresh) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"其他App交互" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 450, 100, 40)];
    [btn addTarget:self action:@selector(actionInterApp) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"JSBridge" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 510, 100, 40)];
    [btn addTarget:self action:@selector(actionJSBridge) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"分页" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 570, 100, 40)];
    [btn addTarget:self action:@selector(actionPaged) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"Banner Loading" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 630, 100, 40)];
    [btn addTarget:self action:@selector(actionBannerLoading) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"runtime" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 690, 100, 40)];
    [btn addTarget:self action:@selector(actionRuntime) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"affine showing" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 750, 100, 40)];
    [btn addTarget:self action:@selector(actionAffineShowing) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"图片Banner" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 810, 100, 40)];
    [btn addTarget:self action:@selector(actionPhotoBanner) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"播放http视频" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 870, 100, 40)];
    [btn addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    btn = [xViewFactory buttonWithTitle:@"QTNetwork" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 930, 100, 40)];
    [btn addTarget:self action:@selector(actionQTNetwork) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    contentView.contentSize = CGSizeMake(kScreenWidth, 1110);
}

-(void)actionQTNetwork{
    [self.navigationController pushViewController:[[QTNetworkController alloc] init] animated:YES];
}

-(void)actionPlay{
    NSURL *url = [NSURL URLWithString:@"http://devimages.apple.com.edgekey.net/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8"];
    AVPlayer *player = [AVPlayer playerWithURL:url];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    controller.player = player;
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

-(void)actionPhotoBanner{
    [self.navigationController pushViewController:[[PhotoBannerController alloc] init] animated:YES];
}

-(void)actionAffineShowing{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIColor *windowColor = window.backgroundColor;
    window.backgroundColor = [UIColor blackColor];
    
    UIView *rootView = window.rootViewController.view;
    _affineShowingPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth, kScreenHeight)];
    UIButton *btn = [xViewFactory buttonWithTitle:@"返回" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 150, 100, 40)];
    [_affineShowingPanel addSubview:btn];
    _affineShowingPanel.backgroundColor = kColor(0xFD8238);
    [window addSubview:_affineShowingPanel];
    
    [UIView animateWithDuration:0.3 animations:^{
        _affineShowingPanel.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        rootView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        rootView.transform = CGAffineTransformMakeScale(1, 1);
        window.backgroundColor = windowColor;
    }];
}

-(void)actionBackFromAffineShowing{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIColor *windowColor = window.backgroundColor;
    window.backgroundColor = [UIColor blackColor];
    
    UIView *rootView = window.rootViewController.view;
    rootView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    [UIView animateWithDuration:0.3 animations:^{
        _affineShowingPanel.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        rootView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [_affineShowingPanel removeFromSuperview];
        window.backgroundColor = windowColor;
    }];
}

-(void)actionRuntime{
    [self.navigationController pushViewController:[[RuntimeController alloc] init] animated:YES];
}

-(void)actionBannerLoading{
    [self.navigationController pushViewController:[[BannerLoadingController alloc] init] animated:YES];
}

-(void)actionPaged{
    [self.navigationController pushViewController:[[PagedController alloc] init] animated:YES];
}

-(void)actionJSBridge{
    [self.navigationController pushViewController:[[WVJBController alloc] init] animated:YES];
}

-(void)actionInterApp{
    [self.navigationController pushViewController:[[InterAppController alloc] init] animated:YES];
}

-(void)actionFMDB{
    [self.navigationController pushViewController:[[FMDBController alloc] init] animated:YES];
}

-(void)actionRefresh{
    [self.navigationController pushViewController:[[RefreshController alloc] init] animated:YES];
}

-(void)actionShowCoreData{
    [self.navigationController pushViewController:[[CoreDataController alloc] init] animated:YES];
}

-(void)actionShowPhotoBrowser{
    [self.navigationController pushViewController:[[xPhotoBrowserController alloc] init] animated:YES];
}

-(void)actionShowAutoLayout{
    [self.navigationController pushViewController:[[AutoLayoutController alloc] init] animated:YES];
}

-(void)actionShowOC{
    [self.navigationController pushViewController:[[OCController alloc] init] animated:YES];
}

-(void)actionShowEvent{
    [self.navigationController pushViewController:[[EventController alloc] init] animated:YES];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
