

#import "xPhotoBrowser.h"
#import "xPhoto.h"
#import "xPhotoView.h"
#import "xPhotoToolbar.h"
#import "SDWebImagePrefetcher.h"

#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface xPhotoBrowser () <xPhotoViewDelegate>
{
    //起始页面朝向
    UIInterfaceOrientation startOrientation_;
    //黑色遮罩
    UIView       *coverView_;
	UIScrollView *photoScrollView_;
    BOOL         isRotating_;
    BOOL         isRotateAfterHidden_;
    //
	NSMutableSet *visiblePhotoViews_;
    NSMutableSet *reusablePhotoViews_;
    //
    xPhotoToolbar *toolbar_;
}
@end

@implementation xPhotoBrowser

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    if (photos.count > 1) {
        visiblePhotoViews_ = [NSMutableSet set];
        reusablePhotoViews_ = [NSMutableSet set];
    }
    for (int i = 0; i<_photos.count; i++) {
        xPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

- (void)setCurrentPhotoIndex:(int)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    for (int i = 0; i<_photos.count; i++) {
        xPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
}

- (void)show
{
    //起始页面朝向和原页面相同
    startOrientation_ = [[UIApplication sharedApplication] statusBarOrientation];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelAlert;
    window.rootViewController = self;
    //这里有一个循环引用，返回时会手动释放
    self.window = window;
    [window makeKeyAndVisible];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.frame = self.window.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    coverView_ = [[UIView alloc] initWithFrame:self.view.bounds];
    coverView_.backgroundColor = kColor_222222;
    coverView_.alpha = 0;
    [self.view addSubview:coverView_];
    //
    CGRect f = self.view.bounds;
    f.origin.x -= kPadding;
    f.size.width += (2 * kPadding);
    photoScrollView_ = [[UIScrollView alloc] initWithFrame:f];
    photoScrollView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    photoScrollView_.pagingEnabled = YES;
    photoScrollView_.delegate = self;
    photoScrollView_.showsHorizontalScrollIndicator = NO;
    photoScrollView_.showsVerticalScrollIndicator = NO;
    photoScrollView_.backgroundColor = [UIColor clearColor];
    photoScrollView_.contentSize = CGSizeMake(f.size.width * _photos.count, 0);
    [self.view addSubview:photoScrollView_];
    photoScrollView_.contentOffset = CGPointMake(_currentPhotoIndex * f.size.width, 0);
    
    toolbar_ = [[xPhotoToolbar alloc] initWithFrame:CGRectMake(15, self.view.bounds.size.height - 15 - 11, 100, 11)];
    toolbar_.totalPage = (int)_photos.count;
    toolbar_.curPage = _currentPhotoIndex + 1;
    [self.view addSubview:toolbar_];
    [self updateToolbarState];
    //
    [self showPhotos:NO];
    //
    [UIView animateWithDuration:0.3 animations:^{
        coverView_.alpha = 1;
    }];
}

- (void)showPhotos:(BOOL)resize
{
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0 resize:resize];
        return;
    }
    
    CGRect visibleBounds = photoScrollView_.bounds;
	NSInteger firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
	NSInteger lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
	
	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (xPhotoView *photoView in visiblePhotoViews_) {
        photoViewIndex = kPhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[reusablePhotoViews_ addObject:photoView];
			[photoView removeFromSuperview];
		}
	}
    
	[visiblePhotoViews_ minusSet:reusablePhotoViews_];
    while (reusablePhotoViews_.count > 2) {
        [reusablePhotoViews_ removeObject:[reusablePhotoViews_ anyObject]];
    }
	
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        [self showPhotoViewAtIndex:index resize:resize];
	}
}

- (void)showPhotoViewAtIndex:(NSUInteger)index resize:(BOOL)resize
{
    xPhotoView *photoView = [self getShowingPhotoViewAtIndex:index];
    BOOL showing = photoView != nil;
    if(showing && !resize){
        return;
    }
    if(!showing){
        photoView = [self dequeueReusablePhotoView];
        if(!photoView){
            photoView = [[xPhotoView alloc] init];
        }
        photoView.photoViewDelegate = self;
        photoView.startOrientation = startOrientation_;
        photoView.coverView = coverView_;
        photoView.parentScrollView = photoScrollView_;
        photoView.tag = kPhotoViewTagOffset + index;
        photoView.photo = _photos[index];
        [visiblePhotoViews_ addObject:photoView];
        [photoScrollView_ addSubview:photoView];
    }
    CGRect bounds = photoScrollView_.bounds;
    CGRect frame = bounds;
    frame.size.width -= (2 * kPadding);
    frame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.frame = frame;
    [photoView show];
    if(!showing){
        [self loadImageNearIndex:index];
    }
}

- (void)loadImageNearIndex:(NSUInteger)index
{
    NSMutableArray *arr = [NSMutableArray array];
    if (index > 0) {
        xPhoto *photo = _photos[index - 1];
        if(!photo.image){
            [arr addObject: photo.url];
        }
    }
    if (index < _photos.count - 1) {
        xPhoto *photo = _photos[index + 1];
        if(!photo.image){
            [arr addObject:photo.url];
        }
    }
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:arr];
}

- (xPhotoView*)getShowingPhotoViewAtIndex:(NSUInteger)index {
	for (xPhotoView *photoView in visiblePhotoViews_) {
		if (kPhotoViewIndex(photoView) == index) {
            return photoView;
        }
    }
    return  nil;
}

- (xPhotoView *)dequeueReusablePhotoView
{
    xPhotoView *photoView = [reusablePhotoViews_ anyObject];
	if (photoView) {
		[reusablePhotoViews_ removeObject:photoView];
	}
	return photoView;
}

- (void)updateToolbarState
{
    _currentPhotoIndex = photoScrollView_.contentOffset.x / photoScrollView_.frame.size.width;
    toolbar_.curPage = _currentPhotoIndex + 1;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(isRotating_){
        return;
    }
    [self showPhotos:NO];
    [self updateToolbarState];
}

#pragma mark - MJPhotoViewDelegate

- (void)photoViewImageFinishLoad:(xPhotoView *)photoView
{
    
}

- (void)photoViewWillHide:(xPhotoView *)photoView{
    coverView_.alpha = 0;
}

- (void)photoViewDidHidden:(xPhotoView *)photoView
{
    //为了解决横屏后返回状态栏仍然横屏的bug
    isRotateAfterHidden_ = YES;
    NSNumber *value = [NSNumber numberWithInt:startOrientation_];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    [self.window resignKeyWindow];
    self.window.hidden = YES;
    self.window.rootViewController = nil;
    self.window = nil;
}

- (void)photoViewSingleTap:(xPhotoView *)photoView{
    [photoView hide];
}

#pragma mark - System

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return startOrientation_;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

//屏幕旋转
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    //
    isRotating_ = YES;
    if(isRotateAfterHidden_){
        [UIView setAnimationsEnabled:NO];
    }
    CGSize lastSize = self.view.bounds.size;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //
        if(lastSize.width != size.width || lastSize.height != size.height){
            //
            coverView_.frame = self.view.bounds;
            //
            CGRect f = self.view.bounds;
            f.origin.x -= kPadding;
            f.size.width += (2 * kPadding);
            photoScrollView_.frame = f;
            photoScrollView_.contentSize = CGSizeMake(f.size.width * _photos.count, 0);
            photoScrollView_.contentOffset = CGPointMake(_currentPhotoIndex * f.size.width, 0);
            //
            [self updateToolbarState];
            //
            [self showPhotos:YES];
        }
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //
        isRotating_ = NO;
        if(isRotateAfterHidden_){
            [UIView setAnimationsEnabled:YES];
        }
    }];
}

-(void)dealloc{
#ifdef DEBUG
    NSLog(@"=====xPhotoBrowser dealloc=====");
#endif
}

@end
