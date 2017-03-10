

#import <UIKit/UIKit.h>

@interface xPhotoBrowser : UIViewController <UIScrollViewDelegate>
//所有的图片对象
@property (nonatomic, strong) NSArray *photos;
//当前展示的图片索引
@property (nonatomic, assign) int currentPhotoIndex;
//window
@property (nonatomic, strong) UIWindow *window;
//显示
- (void)show;
@end
