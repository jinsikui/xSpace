

#import <UIKit/UIKit.h>
#import "xPhotoBannerData.h"
#import "TAAbstractDotView.h"


@interface xPhotoBannerCell : UICollectionViewCell

-(void)setPhotoUrl:(NSString*)photoUrl placeholderImage:(UIImage*)placeholderImage;

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
@property(nonatomic) BOOL isCycleScroll;
// 是否自动滚动（只有循环滚动时才支持自动滚动）
@property(nonatomic) BOOL isAutoScroll;
// 自动滚动间隔
@property(nonatomic) CGFloat autoScrollIntervalSeconds;
// 分页控件位置
@property(nonatomic) xPhotoBannerPagePosition pagePosition;
// 分页控件距底部距离，默认是15
@property(nonatomic) CGFloat pageOffsetBottom;
// 分页控件居左或右时距侧边距离，默认是15
@property(nonatomic) CGFloat pageOffsetLeftOrRight;
// 点击图片回调方法，如果此赋值并返回NO，点击图片不执行默认跳转方法，执行此block
@property(nonatomic,copy) BOOL(^tapPhoto)(xPhotoBannerData *data,NSInteger index);
// 默认跳转方法
-(void)navToPhoto:(xPhotoBannerData*)data index:(NSInteger)index;
// 滚动到图片回调方法
@property(nonatomic,copy) void(^scrollToPhoto)(xPhotoBannerData *data,NSInteger index);
// 图片未加载时显示的image
@property(nonatomic,strong) UIImage *placeholderImage;
// 图片数据列表，最后设置
@property(nonatomic,strong) NSArray <xPhotoBannerData *>*photoDataList;

@end



