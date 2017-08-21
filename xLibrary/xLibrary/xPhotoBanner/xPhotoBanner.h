

#import <UIKit/UIKit.h>
#import "xPhotoBannerData.h"
#import "TAAbstractDotView.h"


@interface xPhotoBannerCell : UICollectionViewCell

@property(nonatomic,strong)xPhotoBannerData *photoData;

@end


typedef NS_ENUM(NSUInteger,xPhotoBannerPagePosition)
{
    /// 不显示分页控件
    xPhotoBannerPagePositionNone = 0,
    /// 左侧
    xPhotoBannerPagePositionLeft = 1,
    /// 居中
    xPhotoBannerPagePositionCenter = 2,
    /// 右侧
    xPhotoBannerPagePositionRight = 3,
};

@interface xPhotoBanner : UIView
// 是否循环滚动
@property(nonatomic)BOOL isCycleScroll;
// 是否自动滚动（只有循环滚动时才支持自动滚动）
@property(nonatomic)BOOL isAutoScroll;
// 自动滚动间隔
@property(nonatomic)CGFloat autoScrollIntervalSeconds;
// 分页控件样式
@property(nonatomic)xPhotoBannerPagePosition pagePosition;

@property(nonatomic,strong)NSArray <xPhotoBannerData *>*photoDataList;
// 分页控件距底部距离，默认是15
@property(nonatomic)CGFloat pageOffsetBottom;
// 分页控件居左或右时距侧边距离，默认是15
@property(nonatomic)CGFloat pageOffsetLeftOrRight;
// 如果此赋值并返回NO，点击图片则不响应默认跳转事件，执行此block
@property(nonatomic,copy)BOOL(^tapPhoto)(xPhotoBannerData *data,NSInteger index);
@property(nonatomic,copy)void(^scrollToPhoto)(xPhotoBannerData *data,NSInteger index);

@end



