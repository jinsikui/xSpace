

#import "xPhotoBanner.h"
#import "xPhotoBannerData.h"
#import "xTimer.h"
#import "TAPageControl.h"
#import "TADotView.h"
#import "UIImageView+WebCache.h"

#define kPhotoBannerCellReuseId  @"xPhotoBannerCell"


@interface xPhotoBannerCell ()

@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) NSString    *photoUrl;

@end

@implementation xPhotoBannerCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.backgroundColor = [UIColor whiteColor];
        //
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self.contentView addSubview:imgView];
        _imgView = imgView;
    }
    return self;
}

-(void)setPhotoUrl:(NSString*)photoUrl placeholderImage:(UIImage*)placeholderImage {
    
    if(![_photoUrl isEqualToString:photoUrl]) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:placeholderImage];
    }
    _photoUrl = photoUrl;
}

@end



@interface xPhotoBanner ()<UICollectionViewDelegate,UICollectionViewDataSource, TAPageControlDelegate>

@property(nonatomic,strong) TAPageControl *pageControl;
@property(nonatomic,strong) UICollectionView *collectView;
@property(nonatomic,strong) UICollectionViewFlowLayout *layout;
@property(nonatomic,strong) xTimer *timer;
@property(nonatomic) NSInteger lastPhotoIndex;

@end

@implementation xPhotoBanner

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = frame.size;
        //
        _collectView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.pagingEnabled = YES;
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.showsVerticalScrollIndicator = NO;
        _collectView.directionalLockEnabled = YES;
        [_collectView registerClass:[xPhotoBannerCell class] forCellWithReuseIdentifier:kPhotoBannerCellReuseId];
        [self addSubview:_collectView];
        //
        _pageOffsetLeftOrRight = 15;
        _pageOffsetBottom = 15;
        _isCycleScroll = YES;
        _isAutoScroll = YES;
        _autoScrollIntervalSeconds = 3;
        _pagePosition = xPhotoBannerPagePositionRight;
    }
    return self;
}

#pragma mark - CollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(!_photoDataList || _photoDataList.count == 0){
        return 0;
    }
    if(_photoDataList.count == 1){
        return 1;
    }
    if(!_isCycleScroll){
        return _photoDataList.count;
    }
    else{
        return _photoDataList.count + 2;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    xPhotoBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoBannerCellReuseId forIndexPath:indexPath];
    xPhotoBannerData *data = _photoDataList[[self getPhotoIndexByCellIndex:indexPath.item]];
    [cell setPhotoUrl:data.photoUrl placeholderImage:_placeholderImage];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self getPhotoIndexByCellIndex:indexPath.item];
    xPhotoBannerData *data = self.photoDataList[index];
    if(self.tapPhoto) {
        BOOL go = self.tapPhoto(data, index);
        if(!go){
            return;
        }
    }
    [self navToPhoto:data index:index];
}

#pragma mark - ScrollViewDelegate

-(void)adjustCyclePosition{
    if(_isCycleScroll && _photoDataList && _photoDataList.count > 1){
        NSInteger cellIndex = [self getCellIndexByScrollPosition];
        if(cellIndex == 0){
            [self scrollToPhotoIndex:_photoDataList.count - 1 animated:NO];
        }
        if(cellIndex == _photoDataList.count + 1){
            [self scrollToPhotoIndex:0 animated:NO];
        }
    }
}

//停止滑动（代码）
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
#ifdef DEBUG
    NSLog(@"===== scrollViewDidEndScrollingAnimation x:%f =====", scrollView.contentOffset.x);
#endif
    if(_isAutoScroll){
        [self startTimer];
    }
    [self adjustCyclePosition];
    [self callScrollToPhoto];
}

//停止滑动（手势）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
#ifdef DEBUG
    NSLog(@"===== scrollViewDidEndDecelerating x:%f =====", scrollView.contentOffset.x);
#endif
    if(_isAutoScroll){
        [self startTimer];
    }
    [self adjustCyclePosition];
    [self callScrollToPhoto];
}

//开始划动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
#ifdef DEBUG
    NSLog(@"=====scrollViewWillBeginDragging x:%f =====", scrollView.contentOffset.x);
#endif
    [self stopTimer];
}

//滑动过程中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
#ifdef DEBUG
    NSLog(@"=====scrollViewDidScroll x:%f =====", scrollView.contentOffset.x);
#endif
    if (_photoDataList.count <= 0) {
        return;
    }
    //设置pageControl
    NSInteger photoIndex = [self getCurPhotoIndex];
    if(_lastPhotoIndex != photoIndex){
        _pageControl.currentPage = photoIndex;
    }
    //
    _lastPhotoIndex = photoIndex;
}


#pragma mark - Auto scroll

-(void)startTimer{
    if(!_timer){
        __weak typeof(self)weak = self;
        _timer = [xTimer timerWithStart:_autoScrollIntervalSeconds*NSEC_PER_SEC leeway:0 queue:dispatch_get_main_queue() block:^{
            [weak scrollToNext];
        }];
    }
    [_timer resume];
}

-(void)stopTimer{
    if(_timer){
        [_timer cancel];
        _timer = nil;
    }
}

-(void)scrollToNext{
    if(!_photoDataList || _photoDataList.count <= 1){
        return;
    }
    NSInteger cellIndex = [self getCellIndexByScrollPosition];
    [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:cellIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - Page Control

- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index{
    [self scrollToPhotoIndex:index animated:YES];
}

-(void)setPagePosition:(xPhotoBannerPagePosition)pagePosition{
    _pagePosition = pagePosition;
    if(!_photoDataList || _photoDataList.count == 0){
        return;
    }
    [_pageControl removeFromSuperview];
    if(_pagePosition == xPhotoBannerPagePositionNone){
        return;
    }
    //
    TAPageControl *pageControl = [[TAPageControl alloc] init];
    [self addSubview:pageControl];
    _pageControl = pageControl;
    pageControl.dotViewClass = [TADotView class];
    pageControl.numberOfPages = _photoDataList.count;
    pageControl.hidesForSinglePage = YES;
    pageControl.delegate = self;
    
    //
    [pageControl sizeToFit];
    CGRect f = pageControl.frame;
    f.origin.y = self.bounds.size.height - self.pageOffsetBottom - pageControl.frame.size.height;
    if(pagePosition == xPhotoBannerPagePositionCenter){
        f.origin.x = 0.5*(self.bounds.size.width - pageControl.frame.size.width);
    }
    else if(pagePosition == xPhotoBannerPagePositionLeft){
        f.origin.x = self.pageOffsetLeftOrRight;
    }
    else{
        f.origin.x = self.bounds.size.width - self.pageOffsetLeftOrRight - pageControl.frame.size.width;
    }
    pageControl.frame = f;
}

#pragma mark - General Methods

-(NSInteger)getCellIndexByScrollPosition{
    NSInteger cellIndex = ceilf((_collectView.contentOffset.x + _layout.itemSize.width * 0.5)/_layout.itemSize.width - 1);
    return cellIndex;
}

-(NSInteger)getPhotoIndexByCellIndex:(NSInteger)cellIndex{
    if(!_photoDataList || _photoDataList.count == 0){
        return -1;
    }
    if(_photoDataList.count == 1){
        return 0;
    }
    if(!_isCycleScroll){
        return cellIndex;
    }
    else{
        if(cellIndex == 0){
            //第一个cell
            return _photoDataList.count - 1;
        }
        if(cellIndex == _photoDataList.count + 1){
            //最后一个cell
            return 0;
        }
        return cellIndex - 1;
    }
}

-(NSInteger)getCurPhotoIndex{
    return [self getPhotoIndexByCellIndex:[self getCellIndexByScrollPosition]];
}

-(void)scrollToPhotoIndex:(NSInteger)photoIndex animated:(BOOL)animated{
    if(!_isCycleScroll || _photoDataList.count <= 1){
        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:photoIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
    else{
        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:photoIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
}

-(void)callScrollToPhoto{
    if(self.scrollToPhoto){
        NSInteger photoIndex = [self getCurPhotoIndex];
        self.scrollToPhoto(_photoDataList[photoIndex], photoIndex);
    }
}

-(void)navToPhoto:(xPhotoBannerData*)data index:(NSInteger)index{
    //跳转方法
}

-(void)setPhotoDataList:(NSArray<xPhotoBannerData *> *)photoDataList {
    _photoDataList = photoDataList;
    [self.collectView reloadData];
    if (_isCycleScroll && photoDataList.count > 1) {
        //此时需要划到cell中的第二个，即photoIndex=0的位置
        [self scrollToPhotoIndex:0 animated:NO];
    }
    //重置页码控件
    [self setPagePosition:_pagePosition];
    //自动播放
    [self stopTimer];
    if(_isAutoScroll && _photoDataList.count > 1){
        [self startTimer];
    }
}

-(void)setIsCycleScroll:(BOOL)isCycleScroll{
    _isCycleScroll = isCycleScroll;
    if(!isCycleScroll){
        _isAutoScroll = NO;
    }
}

-(void)setIsAutoScroll:(BOOL)isAutoScroll{
    if(!isAutoScroll){
        _isAutoScroll = NO;
    }
    else{
        if(_isCycleScroll){
            _isAutoScroll = YES;
        }
    }
}

-(void)dealloc {
    [_timer cancel];
    _timer = nil;
}

@end
