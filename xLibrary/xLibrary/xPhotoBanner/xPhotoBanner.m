

#import "xPhotoBanner.h"
#import "xPhotoBannerData.h"
#import "Masonry.h"
#import "xTimer.h"
#import "TAPageControl.h"
#import "TADotView.h"
#import "xPlayViewController.h"
#import "UIImageView+WebCache.h"

#define kPhotoBannerCellReuseId  @"xPhotoBannerCell"


@interface xPhotoBannerCell ()

@property(nonatomic,strong)UIImageView *imgView;

@end

@implementation xPhotoBannerCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        imgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imgView];
        //
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        _imgView = imgView;
        
    }
    return self;
}

-(void)setPhotoData:(xPhotoBannerData*)photoData {
    
    if(![photoData.photoUrl isEqualToString:_photoData.photoUrl]) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:photoData.photoUrl] placeholderImage:photoData.defaultImage];
    }
    _photoData = photoData;
    
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
        _collectView.backgroundColor = [UIColor whiteColor];
        [_collectView registerClass:[xPhotoBannerCell class] forCellWithReuseIdentifier:kPhotoBannerCellReuseId];
        [self addSubview:_collectView];
        [_collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
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
    cell.photoData = data;
    return cell;
}

-(NSInteger)getPhotoIndexByCellIndex:(NSInteger)cellIndex{
    if(!_photoDataList || _photoDataList.count == 0){
        return 0;
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

-(void)navToPhoto:(xPhotoBannerData*)data index:(NSInteger)index{
    
}

#pragma mark - ScrollViewDelegate

-(NSInteger)getCellIndexByScrollPosition{
    NSInteger cellIndex = ceilf((_collectView.contentOffset.x + _layout.itemSize.width * 0.5)/_layout.itemSize.width - 1);
    return cellIndex;
}

-(void)adjustCyclePosition{
    if(_isCycleScroll && _photoDataList && _photoDataList.count > 1){
        NSInteger cellIndex = [self getCellIndexByScrollPosition];
        if(cellIndex == 0){
            [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_photoDataList.count inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        if(cellIndex == _photoDataList.count + 1){
            [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
}

//停止滑动（代码）
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"=====scrollViewDidEndScrollingAnimation=====");
    if(_isAutoScroll){
        [self startTimer];
    }
    [self adjustCyclePosition];
}

//停止滑动（手势）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"=====scrollViewDidEndDecelerating=====");
    if(_isAutoScroll){
        [self startTimer];
    }
    [self adjustCyclePosition];
}

//开始划动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"=====scrollViewWillBeginDragging=====");
    [self stopTimer];
}

//松手
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"=====scrollViewWillEndDragging=====");
    NSInteger cellIndex = [self getCellIndexByScrollPosition];
    CGFloat endX = cellIndex * _layout.itemSize.width;
    CGPoint endOffset = CGPointMake(endX, 0);
    *targetContentOffset = scrollView.contentOffset;
    [scrollView setContentOffset:endOffset animated:YES];
}

//滑动过程中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"=====scrollViewDidScroll=====");
    if (_photoDataList.count <= 0) {
        return;
    }
    //设置pageControl
    NSInteger cellIndex = [self getCellIndexByScrollPosition];
    NSInteger index = [self getPhotoIndexByCellIndex:cellIndex];
    if(_lastPhotoIndex != index){
        _pageControl.currentPage = index;
    }
    //
    _lastPhotoIndex = index;
}


#pragma mark - Auto scroll

-(void)startTimer{
    if(self.photoDataList.count <= 1) {
        return;
    }
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
        [_timer suspend];
    }
}

-(void)scrollToNext{
    NSInteger cellIndex = [self getCellIndexByScrollPosition];
    [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:cellIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - Page Control

- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index{
    [self scrollToPhotoIndex:index animated:YES];
}

-(void)scrollToPhotoIndex:(NSInteger)photoIndex animated:(BOOL)animated{
    if(!_isCycleScroll || _photoDataList.count <= 1){
        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:photoIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
    else{
        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:photoIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
}

-(void)setPagePosition:(xPhotoBannerPagePosition)pagePosition{
    _pagePosition = pagePosition;
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

-(void)setPhotoDataList:(NSArray<xPhotoBannerData *> *)photoDataList {
    _photoDataList = photoDataList;
    [self.collectView reloadData];
    if (_isCycleScroll && photoDataList.count > 1) {
        //此时需要划到cell中的第二个，即photoIndex=0的位置
        [self scrollToPhotoIndex:0 animated:NO];
    }
    //重置页码控件
    [self setPagePosition:_pagePosition];
}

-(void)dealloc {
    [_timer cancel];
    _timer = nil;
}

@end
