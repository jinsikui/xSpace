

#import "PortalIndexController.h"
#import "xPhotoBrowserController.h"
#import "AutoLayoutController.h"
#import "OCController.h"
#import "PortalNavigationController.h"
#import "EventController.h"

@interface PortalIndexController ()
@end

@implementation PortalIndexController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = kColor_FFFFFF;
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentHeight)];
    [self.view addSubview:contentView];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 30, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"图片浏览" font:kFontPF(14) target:self selector:@selector(actionShowPhotoBrowser)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 90, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"AutoLayout" font:kFontPF(14) target:self selector:@selector(actionShowAutoLayout)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 150, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"OC语法" font:kFontPF(14) target:self selector:@selector(actionShowOC)]];
    [contentView addSubview:[xViewTools createBorderBtn:CGRectMake(0.5*(kContentWidth - 100), 210, 100, 40) borderColor:kRed_FF6600 bgColor:kColor_FFFFFF titleColor:kRed_FF6600 title:@"事件处理" font:kFontPF(14) target:self selector:@selector(actionShowEvent)]];
    contentView.contentSize = CGSizeMake(kScreenWidth, kContentHeight + 1);
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
