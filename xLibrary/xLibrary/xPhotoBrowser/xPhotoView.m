

#import "xPhotoView.h"
#import "xPhoto.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImageManager.h"

typedef enum HideBy {
    HideByTap = 0,
    HideByDrag = 1
} HideBy;

@interface xPhotoView ()
{
}
@property(nonatomic) BOOL doubleTap;
@property(nonatomic) BOOL isZooming;
@property(nonatomic) BOOL isDragEffectOpen;
@property(nonatomic) BOOL isDragForHide;
@property(nonatomic) BOOL isInStartAnimation;
@property(nonatomic) BOOL isInLoading;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation xPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
		//图片
		_imageView = [[UIImageView alloc] init];
		[self addSubview:_imageView];
		
		//属性
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)setPhoto:(xPhoto *)photo {
    _photo = photo;
}

#pragma mark - 显示图片

- (void)show{
    if(_photo.image){
        [self _show];
    }
    else{
        NSString *cacheKey = [SDWebImageManager.sharedManager cacheKeyForURL:_photo.url];
        [SDWebImageManager.sharedManager.imageCache queryCacheOperationForKey:cacheKey done:^(UIImage *image, NSData *data, SDImageCacheType cacheType) {
            if(image){
                _photo.image = image;
            }
            [self _show];
        }];
    }
}

- (void)_show
{
    [self setImageViewBySrc];
    if(_photo.image){
        _imageView.image = _photo.image;
    }
    //启动动画
    if(_photo.firstShow){
        //动画只执行一次
        _photo.firstShow = NO;
        _isInStartAnimation = YES;
        __weak xPhotoView *wSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            //启动动画不加缩放，否则动画会不流畅
            [self adjustFrame];
        } completion:^(BOOL finished) {
            __strong xPhotoView *sSelf = wSelf;
            if(!sSelf){
                return;
            }
            if(sSelf.photo.image){
                sSelf.imageView.image = sSelf.photo.image;
            }
            else{
                if(_isInLoading){
                    [sSelf startLoadingView];
                }
            }
            //启动动画之后再加缩放
            [sSelf adjustZoomAndFrame];
            sSelf.isInStartAnimation = NO;
        }];
    }
    else if(!_isInStartAnimation){
        [self adjustZoomAndFrame];
    }
    //加载大图
    if(!_photo.image){
        //暂不支持gif
        if ([_photo.url.absoluteString hasSuffix:@"gif"]){
            return;
        }
        self.scrollEnabled = NO;
        _isInLoading = YES;
        if(!_isInStartAnimation){
            [self startLoadingView];
        }
        __weak xPhotoView *wSelf = self;
        [SDWebImageManager.sharedManager loadImageWithURL:_photo.url options:SDWebImageRetryFailed|SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            __strong xPhotoView *sSelf = wSelf;
            if(!sSelf){
                return;
            }
            sSelf.isInLoading = NO;
            [sSelf endLoadingView];
            sSelf.scrollEnabled = YES;
            if (image) {
                sSelf.photo.image = image;
                if ([sSelf.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
                    [sSelf.photoViewDelegate photoViewImageFinishLoad:self];
                }
                if(!sSelf.isInStartAnimation){
                    sSelf.imageView.image = image;
                    [sSelf adjustZoomAndFrame];
                }
            }
        }];
    }
    
}

- (void) startLoadingView
{
    [self endLoadingView];
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadingView.frame = CGRectMake(0.5f * (self.bounds.size.width - _loadingView.frame.size.width), 0.5f * (self.bounds.size.height - _loadingView.frame.size.height), _loadingView.frame.size.width, _loadingView.frame.size.height);
    [self addSubview:_loadingView];
    [_loadingView startAnimating];
}

- (void) endLoadingView
{
    [_loadingView stopAnimating];
    [_loadingView removeFromSuperview];
    _loadingView = nil;
}

- (void)adjustFrame
{
    if (_imageView.image == nil){
        return;
    }
    //
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    //
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    //
    CGRect frame;
    if(boundsSize.height > boundsSize.width){
        //竖屏
        frame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
        if (frame.size.height < boundsHeight) {
            frame.origin.y = 0.5f * (boundsHeight - frame.size.height);
        } else {
            frame.origin.y = 0;
        }
    }
    else{
        //横屏
        frame = CGRectMake(0, 0, imageWidth*boundsHeight/imageHeight, boundsHeight);
        if (frame.size.width < boundsWidth) {
            frame.origin.x = 0.5f * (boundsWidth - frame.size.width);
        } else {
            frame.origin.x = 0;
        }
    }
    _imageView.frame = frame;
    //
    self.contentInset = UIEdgeInsetsZero;
    //保证开启下拉弹簧效果
    self.contentSize = CGSizeMake(0, (frame.size.height <= boundsHeight? boundsHeight + 1:frame.size.height));
}

- (void)adjustZoomAndFrame
{
    //必须先设置zoom，再设置frame，次序颠倒就不对了
    if (_imageView.image == nil){
        return;
    }
    CGSize boundsSize = self.bounds.size;
    if(boundsSize.height > boundsSize.width){
        //竖屏
        CGFloat boundsWidth = boundsSize.width;
        CGFloat imageWidth = _imageView.image.size.width;
        CGFloat maxScale = imageWidth / boundsWidth;
        if(maxScale <= 1){
            maxScale = 1.5;
        }
        else if(maxScale < 3){
            maxScale = 3;
        }
        self.maximumZoomScale = maxScale;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.imageView.transform = CGAffineTransformMakeScale(1, 1);
    }
    else{
        //横屏
        CGFloat boundsHeight = boundsSize.height;
        CGFloat imageHeight = _imageView.image.size.height;
        CGFloat maxScale = imageHeight / boundsHeight;
        if(maxScale <= 1){
            maxScale = 1.5;
        }
        else if(maxScale < 3){
            maxScale = 3;
        }
        self.maximumZoomScale = maxScale;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.imageView.transform = CGAffineTransformMakeScale(1, 1);
    }
    //
    [self adjustFrame];
}

- (void)setImageViewBySrc
{
    _imageView.image = _photo.srcImageView.image;
    _imageView.frame = _photo.srcImageView.frame;
    _imageView.contentMode = _photo.srcImageView.contentMode;
    _imageView.clipsToBounds = _photo.srcImageView.clipsToBounds;
}

#pragma mark - UIScrollViewDelegate

-(void)log:(NSString*)methodName{
#ifdef DEBUG
    NSLog(@"=====%@ imgFrame:(%.2f, %.2f, %.2f, %.2f) contentSize:(%.2f, %.2f) contentOffset:(%.2f, %.2f) self.zoomScale:(%.2f) .transform.a:(%.2f) isZooming:(%@) dragEffectOpen:(%@)",methodName, _imageView.frame.origin.x, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height, self.contentSize.width, self.contentSize.height, self.contentOffset.x, self.contentOffset.y, self.zoomScale, _imageView.transform.a, _isZooming?@"YES":@"NO", _isDragEffectOpen?@"YES":@"NO");
#endif
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(!_isZooming && self.zoomScale == 1){
        _isDragEffectOpen = YES;
        //禁止两指缩放手势
        self.pinchGestureRecognizer.enabled = NO;
        //左右滑动效果
        _parentScrollView.pagingEnabled = NO;
        self.contentSize = CGSizeMake(self.bounds.size.width + 1, self.contentSize.height);
    }
    [self log:@"scrollViewWillBeginDragging"];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if(_isDragEffectOpen){
        //先设置一个下一步动作的标志，在scrollViewDidEndDragging中执行动作，动作代码直接放在这里ios10会有抖动现象
        if(velocity.y <= 0 && -self.contentOffset.y > 40){
            _isDragForHide = YES;
        }
        else{
            _isDragForHide = NO;
        }
    }
    [self log:@"scrollViewWillEndDragging"];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(_isDragEffectOpen){
        if(_isDragForHide){
            [self hide:HideByDrag];
        }
        else{
            _isDragEffectOpen = NO;
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 1;
                _imageView.transform = CGAffineTransformMakeScale(1, 1);
                [self adjustFrame];
                
            } completion:^(BOOL finished) {
                self.pinchGestureRecognizer.enabled = YES;
                _parentScrollView.pagingEnabled = YES;
                [self log:@"scrollViewDidEndDragging-completion"];
            }];
        }
    }
    [self log:@"scrollViewDidEndDragging"];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self log:@"scrollViewDidEndDecelerating"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //
    if(_isDragEffectOpen){
        [self adjustEffect];
    }
    [self log:@"scrollViewDidScroll"];
}

-(void)adjustEffect{
    if(_isDragEffectOpen){
        //
        CGFloat top = -self.contentOffset.y;
        static CGFloat fullTop = 80.f;
        CGFloat alpha = 1 - top/fullTop;
        alpha = alpha < 0? 0:alpha;
        alpha = alpha > 1? 1:alpha;
        _coverView.alpha = alpha;
        //
        CGPoint offset = self.contentOffset;
        self.contentInset = UIEdgeInsetsMake(offset.y < 0?-offset.y:0, offset.x < 0?-offset.x:0, offset.y > 0?offset.y:0, offset.x > 0?offset.x:0);
        //
        static CGFloat minScale = 0.5f;
        CGFloat scale = minScale + alpha * (1 - minScale);
        _imageView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    _isZooming = YES;
    _isDragEffectOpen = NO;
    _coverView.alpha = 1;
    self.pinchGestureRecognizer.enabled = YES;
    _parentScrollView.pagingEnabled = YES;
    self.contentInset = UIEdgeInsetsZero;
    [self log:@"scrollViewWillBeginZooming"];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect frame = _imageView.frame;
    CGRect bounds = [UIScreen mainScreen].bounds;
    if(bounds.size.height > bounds.size.width){
        //竖屏
        if (frame.size.height > bounds.size.height) {
            frame.origin.y = 0.0f;
        } else {
            frame.origin.y = (bounds.size.height - frame.size.height) / 2.0f;
        }
    }
    else{
        //横屏
        if (frame.size.width > bounds.size.width) {
            frame.origin.x = 0.0f;
        } else {
            frame.origin.x = (bounds.size.width - frame.size.width) / 2.0f;
        }
    }
    _imageView.frame = frame;
    //
    self.contentSize = CGSizeMake(self.contentSize.width, (frame.size.height <= bounds.size.height? bounds.size.height + 1:frame.size.height));
    [self log:@"scrollViewDidZoom"];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    _isZooming = NO;
    [self log:@"scrollViewDidEndZooming"];
}

#pragma mark - Actions

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    CGPoint touchPoint = [tap locationInView:self];
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    [self performSelector:@selector(_handleSingleTap) withObject:nil afterDelay:0.2];
}

- (void)_handleSingleTap{
    if(_doubleTap){
        return;
    }
    if(self.photoViewDelegate){
        [self.photoViewDelegate photoViewSingleTap:self];
    }
}

- (void)hide{
    [self hide:HideByTap];
}

- (void)hide:(HideBy)hideBy
{
    if(hideBy == HideByTap){
        self.contentOffset = CGPointZero;
    }
    _coverView.alpha = 0;
    _isDragEffectOpen = NO;
    [self endLoadingView];
    //通知代理
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewWillHide:)]) {
        [self.photoViewDelegate photoViewWillHide:self];
    }
    //为了更好的用户体验，当动画进行到一多半时再改变image
    CGFloat delay = 0.15;
    [self performSelector:@selector(hideReset) withObject:nil afterDelay:delay];
    [UIView animateWithDuration:delay + 0.1 animations:^{
        self.contentInset = UIEdgeInsetsZero;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(orientation == _startOrientation){
            _imageView.frame = _photo.srcImageView.frame;
        }
        else{
            CGRect bounds = [UIScreen mainScreen].bounds;
            _imageView.frame = CGRectMake(0.5f*(bounds.size.width - _photo.srcImageView.frame.size.width), 0.5f*(bounds.size.height - _photo.srcImageView.frame.size.height), _photo.srcImageView.frame.size.width, _photo.srcImageView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        //
        _imageView.hidden = YES;
        //通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidHidden:)]) {
            [self.photoViewDelegate photoViewDidHidden:self];
        }
    }];
}

- (void)hideReset{
    _imageView.image = _photo.srcImageView.image;
    _imageView.contentMode = _photo.srcImageView.contentMode;
    _imageView.clipsToBounds = _photo.srcImageView.clipsToBounds;
}

#pragma mark - System

- (void)dealloc
{
    //取消请求
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}
@end
