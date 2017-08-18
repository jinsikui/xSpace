

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,xPhotoBannerDataType)
{
    // 图片
    xPhotoBannerDataTypeImage = 0,
    // 视频
    xPhotoBannerDataTypeVideo = 1
};


@interface xPhotoBannerData : NSObject

// 数据类型
@property(nonatomic) xPhotoBannerDataType dataType;
// 默认图片 自动赋值默认为1：1的图，其他比例需要重新赋值
@property(nonatomic,strong) UIImage     *defaultImage;
@property(nonatomic,strong) NSString    *photoUrl;
// 导航url
@property(nonatomic,strong) NSString    *navigateUrl;
// 视频url 有视频url优先选择视频url跳转
@property(nonatomic,strong) NSString    *videoUrl;
// 视频title
@property(nonatomic,strong) NSString    *videoTitle;

@end
