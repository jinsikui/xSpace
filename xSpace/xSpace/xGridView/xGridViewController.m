//
//  xGridViewController.m
//  xSpace
//
//  Created by JSK on 2018/4/28.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "xGridViewController.h"
#import "xGridView.h"
#import "LivePresentCell.h"
#import "LivePresent.h"
#import "LiveExtensions.h"

#define GRID_TAG 1234
#define GRID_EDGE 3

@interface xGridViewController ()

@end

@implementation xGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray<LivePresent*> *dataList = [[NSMutableArray<LivePresent*> alloc] init];
    LivePresent *p = [[LivePresent alloc] initWithDic:@{
                                                        @"id":@(1016),
                                                        @"index":@(4),
                                                        @"name":@"金话筒",
                                                        @"reward_type":@(0),
                                                        @"price":@(520),
                                                        @"unit_price":@(52),
                                                        @"start_time":@"2018-04-22T16:00:00.000Z",
                                                        @"end_time":@"2018-05-06T16:00:00.000Z",
                                                        @"img_url":@"http://pic.qingting.fm/2017/07/16/partner_4afada39f02be569cb5542a4e7d553fd.PNG",
                                                        @"animation_url":[NSNull null],
                                                        @"combo":@(false),
                                                        @"combo_plans":[NSNull null],
                                                        @"alias_id":[NSNull null],
                                                        @"label_text":[NSNull null],
                                                        @"reward_template_id":[NSNull null],
                                                        @"priv":@(0),
                                                        @"week_star":@(true)
                                                        }];
    [dataList addObject:p];
    p = [[LivePresent alloc] initWithDic:@{
                                                        @"id":@(1016),
                                                        @"index":@(4),
                                                        @"name":@"金话筒",
                                                        @"reward_type":@(0),
                                                        @"price":@(520),
                                                        @"unit_price":@(52),
                                                        @"start_time":@"2018-04-22T16:00:00.000Z",
                                                        @"end_time":@"2018-05-06T16:00:00.000Z",
                                                        @"img_url":@"http://pic.qingting.fm/2017/07/16/partner_4afada39f02be569cb5542a4e7d553fd.PNG",
                                                        @"animation_url":[NSNull null],
                                                        @"combo":@(false),
                                                        @"combo_plans":[NSNull null],
                                                        @"alias_id":[NSNull null],
                                                        @"label_text":[NSNull null],
                                                        @"reward_template_id":[NSNull null],
                                                        @"priv":@(0),
                                                        @"week_star":@(true)
                                                        }];
    
    [dataList addObject:p];
    
    
    
    
    
    
    
    xGridView *grid = [[xGridView alloc] initWithCellClass:LivePresentCell.class];
    grid.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.view addSubview:grid];
    [grid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GRID_EDGE);
        make.top.mas_equalTo(200);
        make.right.mas_equalTo(-GRID_EDGE);
        make.height.mas_equalTo(200);
    }];
    grid.tag = GRID_TAG;
    grid.itemSize = CGSizeMake(([xDevice screenWidth]-2*GRID_EDGE)/4, 100);
    grid.buildCellCallback = ^(UICollectionViewCell *cell) {
        LivePresent *present = cell.x_data;
        [((LivePresentCell*)cell) refreshByPresent:present isBig:NO];
    };
    grid.selectCellCallback = ^(UICollectionViewCell *cell) {
        
    };
    [grid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    grid.dataList = dataList;
    [grid reloadData];
}

@end
