//
//  xBanner.h
//  支持水平和垂直布局，支持循环播放，自动播放
//  QTTourAppStore
//
//  Created by JSK on 2018/4/24.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^xBannerBuildCellBlock)(UICollectionViewCell*);
typedef void (^xBannerSelectCellBlock)(NSInteger, id);
typedef void (^xBannerStopToItemBlock)(NSInteger, id);
typedef void (^xBannerIndexChangeBlock)(NSInteger);

@interface xBanner : UIView

@property(nonatomic) BOOL isCycleScroll;
//仅当 isCycleScroll==YES 时才有意义，这时需要告诉控件显示区域可以装下多少个cell，控件会在前后创建多余的cell来支持循环滚动，另外itemsInScreen可以设的比实际大（会导致多创建一些前后的cell，不影响功能）但不能大于dataList.count，不能比实际小，当banner的显示区域大小有可能动态改变时，可将itemsInScreen设为可能的最大值
@property(nonatomic) NSInteger itemsInScreen;
//仅当 isCycleScroll==YES 时才有意义，只有能够循环播放才能自动播放
@property(nonatomic) BOOL isAutoScroll;
//自动播放时间间隔
@property(nonatomic) int autoScrollIntervalSeconds;
//是否允许用户手动滑（不影响自动播放的滑动）
@property(nonatomic) BOOL scrollEnabled;
//是否支持cell重用（有些情况下比如cell中是webView，不希望重用，这时dataList中每一个data对应一个cell）
@property(nonatomic) BOOL reuseEnabled;
@property(nonatomic) NSArray *dataList;
@property(nonatomic) CGSize itemSize;
@property(nonatomic) UICollectionViewScrollDirection scrollDirection;
@property(nonatomic) Class cellClass;
@property(nonatomic) xBannerBuildCellBlock buildCellCallback;
@property(nonatomic) xBannerSelectCellBlock selectCellCallback;
//稳定的停住后回调
@property(nonatomic) xBannerStopToItemBlock stopToItemCallback;
//页码改变回调
@property(nonatomic) xBannerIndexChangeBlock indexChangeCallback;

-(instancetype)initWithCellClass:(Class)cellClass itemSize:(CGSize)itemSize;

-(void)reloadData;


@end
