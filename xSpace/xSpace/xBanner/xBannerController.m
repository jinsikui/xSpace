//
//  xBannerController.m
//  xSpace
//
//  Created by JSK on 2018/4/24.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "xBannerController.h"
#import "xBanner.h"

#define PANEL_TAG 1234
#define LABEL_TAG 4321

@interface xBannerController ()

@property(nonatomic) xBanner *banner;

@end

@implementation xBannerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"xBanner Test";
    _banner = [[xBanner alloc] initWithCellClass:UICollectionViewCell.class itemSize:CGSizeMake(100, 150)];
    _banner.scrollDirection = UICollectionViewScrollDirectionVertical;
    _banner.dataList = @[@(0),@(1),@(2),@(3),@(4),@(5)];
    _banner.isCycleScroll = YES;
    _banner.isAutoScroll = YES;
    _banner.itemsInScreen = 2;
    _banner.reuseEnabled = NO;
    _banner.scrollEnabled = NO; //禁止用户手动滑，只能自动滑
    _banner.backgroundColor = [xColor grayColor];
    _banner.buildCellCallback = ^(UICollectionViewCell *cell){
        int num = [cell.x_data intValue];
        UIView *panel = [cell viewWithTag:PANEL_TAG];
        if(!panel){
            panel = [[UIView alloc] init];
            panel.backgroundColor = [xColor redColor];
            panel.frame = CGRectMake(0, 10, 100, 130);
            [cell addSubview:panel];
            
            UILabel *label = [xViewFactory labelWithText:@"" font:kFontRegularPF(30) color:[xColor blueColor]];
            label.tag = LABEL_TAG;
            [panel addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(panel);
            }];
        }
        UILabel *label = (UILabel*)[panel viewWithTag:LABEL_TAG];
        label.text = [NSString stringWithFormat:@"%d", num];
    };
    [self.view addSubview:_banner];
    [_banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(300);
    }];
    
    [_banner reloadData];
}


@end
