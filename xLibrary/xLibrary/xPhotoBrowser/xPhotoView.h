

#import <UIKit/UIKit.h>

@class xPhotoBrowser, xPhoto, xPhotoView;

@protocol xPhotoViewDelegate <NSObject>
- (void)photoViewImageFinishLoad:(xPhotoView *)photoView;
- (void)photoViewWillHide:(xPhotoView *)photoView;
- (void)photoViewDidHidden:(xPhotoView *)photoView;
- (void)photoViewSingleTap:(xPhotoView *)photoView;
@end

@interface xPhotoView : UIScrollView <UIScrollViewDelegate>
//图片
@property (nonatomic, strong) xPhoto *photo;
//代理
@property (nonatomic, weak) id<xPhotoViewDelegate> photoViewDelegate;
//起始页面朝向
@property (nonatomic, assign) UIInterfaceOrientation startOrientation;
//
@property (nonatomic, weak) UIView *coverView;
//
@property (nonatomic, weak) UIScrollView *parentScrollView;

-(void)show;

-(void)hide;

@end
