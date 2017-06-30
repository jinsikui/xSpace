

#import <UIKit/UIKit.h>

@interface UIView(xBannerLoading)

-(void)startBannerLoading;

-(void)stopBannerLoading;

@end

@interface xBannerLoadingView : UIView

-(instancetype)initWithParentView:(UIView*)parentView;

-(void)startLoading;

-(void)stopLoading;

-(void)show;

-(void)hide;

@end
