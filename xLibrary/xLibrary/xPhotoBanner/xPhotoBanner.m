

#import "TJCyclePhotoView.h"
#import "Masonry.h"
#import "TJCyclePhotoConfig.h"
#import "xTimer.h"
#import "TAPageControl.h"
#import "TJPlayViewController.h"
#import "TJURLTJCodeParseManager.h"
#import "Statistics.h"
#import "UIImageView+WebCache.h"


@interface xPhotoBannerCell ()
@property(nonatomic,strong)UIImageView *photoImage;
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
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        _photoImage = imgView;
        
    }
    return self;
}
-(void)setPhotoData:(TJCyclePhotoData *)photoData {
    
    if(![photoData.pictureUrl isEqualToString:_photoData.pictureUrl]) {
        [_photoImage sd_setImageWithURL:[NSURL URLWithString:photoData.pictureUrl] placeholderImage:photoData.defaultImage];
    }
    _photoData = photoData;
    
}

@end




@interface TJCyclePhotoView ()
@property(nonatomic)NSInteger totalImageCount;
@property(nonatomic)NSInteger tempIndexOnPageControl;
@property(nonatomic,strong)TAPageControl *pageControl;
@property(nonatomic,strong) UICollectionView *collectView;
@property(nonatomic,strong) UICollectionViewFlowLayout *layout;
@property(nonatomic,strong) TJTimer *timer;
@property(nonatomic)BOOL isAutoScroller;
@end

@interface TJCyclePhotoView (CollectionViewDelegate)<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@interface TJCyclePhotoView (scroller)<UIScrollViewDelegate>
@end

#define kCyclePhotoImageCellReuseId  @"TJCyclePhotoImageCell"

@implementation TJCyclePhotoView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = frame.size;
        _collectView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.pagingEnabled = YES;
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.showsVerticalScrollIndicator = NO;
        _collectView.scrollsToTop = NO;
        _collectView.directionalLockEnabled = YES;
        
        
        [self addSubview:_collectView];
        self.backgroundColor = [UIColor whiteColor ];
        [_collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        _collectView.backgroundColor = [UIColor whiteColor];
        [_collectView registerClass:[TJCyclePhotoImageCell class] forCellWithReuseIdentifier:kCyclePhotoImageCellReuseId];
        
        _collectView.pagingEnabled = YES;
        _pageControlBottomOffset = 15;
        _pageControlOffsetX = 15;
    }
    return self;
}


// 获取当前的index
-(NSInteger)currentIndex {
    
    if (_collectView.frame.size.width == 0 || _collectView.frame.size.height == 0 ){
        return 0;
    }
    NSInteger index = (_collectView.contentOffset.x + _layout.itemSize.width * 0.5)/_layout.itemSize.width;
    if (index <= 0) {
        index = _photoDataList.count;
    }
    if (index >= _totalImageCount - 1) {
        index = _photoDataList.count - 1;
    }
    return index;
    
}
-(NSInteger)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
     return index % self.photoDataList.count;
}

-(void)automaticScroll {
    if (_totalImageCount == 0 && !self.isAutoScroller) {
        return;
    }
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex animated:YES];
}
-(void)setupTimer {
    if(self.photoDataList.count <= 1) {
        return;
    }
    __weak typeof(self)weak = self;
    _timer = [TJTimer timerWithStart:3*NSEC_PER_SEC leeway:0 queue:dispatch_get_main_queue() block:^{
        [weak automaticScroll];
    }];
    [_timer resume];
}
-(void)invalidateTimer {
    _timer = nil;
}

-(void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    if (_totalImageCount != 0 && _photoDataList ) {
        [_collectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
    if (self.photoToScroll) {
        NSInteger currentindex = self.currentImageIndex;
        self.photoToScroll(self.photoDataList[currentindex],currentindex);
    }
}

-(void)setStartAutoAminat:(BOOL)isAuto {
    if (isAuto) {
        [self setupTimer];
    }else {
        [self invalidateTimer];
    }
}

#pragma mark --

-(void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    if (_autoScroll) {
        [self setupTimer];
    }else {
        [self invalidateTimer];
    }
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    _collectView.backgroundColor = backgroundColor;
}
-(void)setPhotoDataList:(NSArray<TJCyclePhotoData *> *)photoDataList {
    _photoDataList = photoDataList;
    _totalImageCount = photoDataList.count *2;
    [self layoutSubviews];
     [self.collectView reloadData];
    if ( photoDataList.count > 1) {
        [self scrollToIndex:photoDataList.count animated:NO];
    }
}
-(void)setStyle:(TJCyclePhotoViewStyle)style {
    _style = style;
    [self.pageControl removeFromSuperview];
    if (style == TJCyclePhotoViewNone) {
        return;
    }
    TAPageControl *pageControl = [[TAPageControl alloc] init];
    pageControl.numberOfPages = self.photoDataList.count;
    pageControl.dotColor = kColor_FD8238;
    pageControl.userInteractionEnabled = NO;
    pageControl.dotSize = CGSizeMake(4, 4);
    [self addSubview:pageControl];
    _pageControl = pageControl;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(_photoDataList.count <= 0) {
        [self addSubview:self.backgroundImageView];
        self.backgroundImageView.frame = self.bounds;
       
    }else {
        [self.backgroundImageView removeFromSuperview];
        self.pageControl.numberOfPages = _photoDataList.count;
    }
    self.collectView.scrollEnabled = self.photoDataList.count > 1;
    self.pageControl.hidden = YES;
    self.autoScroll = _autoScroll;
    
    if (_style == TJCyclePhotoViewNone ) {
        return;
    }
    
    CGSize size = [_pageControl sizeForNumberOfPages:self.photoDataList.count];
    CGFloat x = 15; // left
    switch (_style) {
        case TJCyclePhotoViewRight:
             x = self.frame.size.width - size.width - _pageControlOffsetX;
            break;
          case TJCyclePhotoViewCenter:
            x = (self.frame.size.width - size.width) * 0.5;
        default:
            break;
    }
    
    CGFloat y = self.frame.size.height - size.height - _pageControlBottomOffset;
    [_pageControl sizeToFit];
    self.pageControl.frame = CGRectMake(x, y, size.width, size.height);
    self.pageControl.hidden = self.photoDataList.count <= 1;
}

-(UIImageView *)currentImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    NSInteger current = self.currentImageIndex;
    TJCyclePhotoData *photoData = self.photoDataList[current];
    imageView.frame = self.frame;
     [imageView sd_setImageWithURL:[NSURL URLWithString:photoData.pictureUrl] placeholderImage:photoData.defaultImage];
    return imageView;
}
-(NSInteger)currentImageIndex {
    return [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
}
+(void)selectBannerItem:(TJCyclePhotoData *)data index:(NSInteger)index orderSource:(NSString *)orderSource
{
    switch (data.dataType) {
        case TJCyclePhotoDataVideo:
            [TJCyclePhotoView playVideo:data];
            break;
        case TJCyclePhotoDataImage:
            [TJCyclePhotoView pushViewController:data orderSource:orderSource];
            break;
            
        case TJCyclePhotoDataText:
            break;
            
        default:
            break;
    }
    
}

+(void)playVideo:(TJCyclePhotoData *)data {
    TJPlayViewController *player = [[TJPlayViewController alloc] init];
    player.videoTitle = data.name;
    player.videoUrl = data.videoUrl;
    [[ControllerHelper currentNavController] presentViewController:player animated:YES completion:nil];
}
+(void)pushViewController:(TJCyclePhotoData *)data orderSource:(NSString *)orderSource{
    [TJURLTJCodeParseManager pushViewControllerWithUrl:data.navigateUrl stat:orderSource shareSetting:data.shareSetting];

    
}

-(void)dealloc {
    _collectView.delegate = nil;
    _collectView.dataSource = nil;
    [self invalidateTimer];
}

@end

@implementation TJCyclePhotoView (CollectionViewDelegate)

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalImageCount;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    TJCyclePhotoData *data = self.photoDataList[indexOnPageControl];
    switch (data.dataType) {
        case TJCyclePhotoDataImage:
        case TJCyclePhotoDataVideo:
        {
            TJCyclePhotoImageCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCyclePhotoImageCellReuseId forIndexPath:indexPath];
            imageCell.photoData = data;
            return imageCell;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    TJCyclePhotoData *data = self.photoDataList[indexOnPageControl];
    if(self.photoViewTap) {
        BOOL go = self.photoViewTap(data,indexOnPageControl);
        if(!go){
            return;
        }
    }
    
    [TJCyclePhotoView selectBannerItem:data index:indexOnPageControl orderSource:nil];
}

@end

@implementation TJCyclePhotoView (scroller)
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.photoDataList.count <= 0) {
        return;
    }
    NSInteger itemIndex = [self currentIndex];
    [self scrollToIndex:itemIndex animated:NO];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.photoDataList.count <= 0) {
        return;
    }
    NSInteger itemIndex = [self currentIndex];
    NSInteger indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    if (_tempIndexOnPageControl == indexOnPageControl) {
        return;
    }
    self.pageControl.currentPage = indexOnPageControl;
    self.tempIndexOnPageControl = indexOnPageControl;
}

@end
