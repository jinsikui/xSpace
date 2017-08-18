

#import <UIKit/UIKit.h>
#import "TJCyclePhotoConfig.h"

@interface xPhotoBannerCell : UICollectionViewCell

@property(nonatomic,strong)xPhotoBannerData *photoData;

@end


typedef NS_ENUM(NSUInteger,TJCyclePhotoViewStyle)
{
    /// 不显示分页控件
    TJCyclePhotoViewNone = 0,
    /// 左侧
    TJCyclePhotoViewLeft = 1,
    /// 居中
    TJCyclePhotoViewCenter = 2,
    /// 右侧
    TJCyclePhotoViewRight,
};

@interface TJCyclePhotoView : UIView
// 当数组为空的时候现在此view
@property(nonatomic,strong)UIView *backgroundImageView;
//是否自动滚动
@property(nonatomic)BOOL autoScroll;
// 分页控件样式 默认不显示
@property(nonatomic)TJCyclePhotoViewStyle style;
// 当前的显示view
@property(nonatomic,strong)UIImageView *currentImageView;
// 当前的index
@property(nonatomic,readonly)NSInteger currentImageIndex;
@property(nonatomic,strong)NSArray <TJCyclePhotoData *>*photoDataList;
/// dot的偏移量 默认是15
@property(nonatomic)CGFloat pageControlBottomOffset;
/// 水平间距的偏移量 默认是15
@property(nonatomic)CGFloat pageControlOffsetX;
// 如果此赋值并返回NO，点击图片则不响应默认跳转事件，执行此block
@property(nonatomic,copy)BOOL(^photoViewTap)(TJCyclePhotoData *data,NSInteger index);
@property(nonatomic,copy)void(^photoToScroll)(TJCyclePhotoData *data,NSInteger index);
+(void)selectBannerItem:(TJCyclePhotoData *)data index:(NSInteger)index orderSource:(NSString *)orderSource;
-(void)setStartAutoAminat:(BOOL)isAuto;
@end



