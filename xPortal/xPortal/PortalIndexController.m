

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

@interface PortalIndexController ()
@property(nonatomic,strong)UIView *affineShowingPanel;
@end

@implementation PortalIndexController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = kColor_FFFFFF;
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentHeight)];
    contentView.alwaysBounceVertical = YES;
    [self.view addSubview:contentView];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 30, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"图片浏览" font:kFontPF(14) target:self selector:@selector(actionShowPhotoBrowser)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 90, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"AutoLayout" font:kFontPF(14) target:self selector:@selector(actionShowAutoLayout)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 150, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"OC语法" font:kFontPF(14) target:self selector:@selector(actionShowOC)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 210, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"事件处理" font:kFontPF(14) target:self selector:@selector(actionShowEvent)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 270, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"CoreData" font:kFontPF(14) target:self selector:@selector(actionShowCoreData)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 330, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"FMDB" font:kFontPF(14) target:self selector:@selector(actionFMDB)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 390, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"下拉刷新" font:kFontPF(14) target:self selector:@selector(actionRefresh)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 450, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"其他App交互" font:kFontPF(14) target:self selector:@selector(actionInterApp)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 510, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"JSBridge" font:kFontPF(14) target:self selector:@selector(actionJSBridge)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 570, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"分页" font:kFontPF(14) target:self selector:@selector(actionPaged)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 630, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"Banner Loading" font:kFontPF(12) target:self selector:@selector(actionBannerLoading)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 690, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"runtime" font:kFontPF(12) target:self selector:@selector(actionRuntime)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 750, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"affine showing" font:kFontPF(12) target:self selector:@selector(actionAffineShowing)]];
    contentView.contentSize = CGSizeMake(kScreenWidth, 830);
}

-(void)actionAffineShowing{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIColor *windowColor = window.backgroundColor;
    window.backgroundColor = [UIColor blackColor];
    
    UIView *rootView = window.rootViewController.view;
    _affineShowingPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth, kScreenHeight)];
    [_affineShowingPanel addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 150, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"返回" font:kFontPF(14) target:self selector:@selector(actionBackFromAffineShowing)]];
    _affineShowingPanel.backgroundColor = kColor_FD8238;
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
