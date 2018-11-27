//
//  xGridView.m
//  xLibrary
//
//  Created by JSK on 2017/11/19.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xGridView.h"
#import "Masonry.h"
#import <objc/runtime.h>

@interface xGridView(){
}
@property(nonatomic)Class cellClass;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *layout;
@property(nonatomic,copy)NSString *reuseId;
@end

@implementation xGridView

-(void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection{
    _layout.scrollDirection = scrollDirection;
}

-(UICollectionViewScrollDirection)scrollDirection{
    return _layout.scrollDirection;
}

-(void)setIsScrollEnabled:(BOOL)isScrollEnabled{
    _collectionView.scrollEnabled = isScrollEnabled;
    if(_layout.scrollDirection == UICollectionViewScrollDirectionVertical){
        _collectionView.alwaysBounceVertical = isScrollEnabled;
    }
}

-(BOOL)isScrollEnabled{
    return _collectionView.scrollEnabled;
}

-(void)setItemSize:(CGSize)itemSize {
    _layout.itemSize = itemSize;
}

-(CGSize)itemSize{
    return _layout.itemSize;
}

-(void)setLineSpace:(CGFloat)lineSpace {
    _layout.minimumLineSpacing = lineSpace;
}

-(CGFloat)lineSpace{
    return _layout.minimumLineSpacing;
}

-(void)setInteritemSpace:(CGFloat)interitemSpace{
    _layout.minimumInteritemSpacing = interitemSpace;
}

-(CGFloat)interitemSpace{
    return _layout.minimumInteritemSpacing;
}

- (void)setBounces:(BOOL)bounces{
    _collectionView.bounces = bounces;
}

-(BOOL)bounces{
    return _collectionView.bounces;
}

-(void)setIsScrollsToTop:(BOOL)isScrollsToTop {
    _collectionView.scrollsToTop = isScrollsToTop;
}
-(BOOL)isScrollsToTop {
    return _collectionView.scrollsToTop;
}

-(void)setContentInset:(UIEdgeInsets)contentInset{
    _collectionView.contentInset = contentInset;
}

-(UIEdgeInsets)contentInset{
    return _collectionView.contentInset;
}

-(instancetype)initWithCellClass:(Class)cellClass{
    self = [super init];
    if(self){
        self.cellClass = cellClass;
        [self prepare];
    }
    return self;
}

-(instancetype)initWithCollectionViewCell{
    self = [super init];
    if(self){
        self.cellClass = UICollectionViewCell.class;
        [self prepare];
    }
    return self;
}

-(void)prepare{
    _reuseId = [NSString stringWithFormat:@"%d", arc4random()];
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:self.cellClass forCellWithReuseIdentifier:self.reuseId];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

-(UICollectionViewCell *)cellWithIndexPath:(NSIndexPath *)path{
    return [_collectionView cellForItemAtIndexPath:path];
}

-(NSInteger)numberOfSections{
    return _collectionView.numberOfSections;
}

-(NSInteger)numberOfItemsInSection:(NSInteger)section{
    return _dataList.count;
}

-(void)reloadData{
    [_collectionView reloadData];
}

-(void)scrollToItemAt:(NSIndexPath*)indexPath position:(UICollectionViewScrollPosition)position animated:(BOOL)animated{
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:animated];
}

-(void)scrollToTopAnimated:(BOOL)animated{
    if([self numberOfItemsInSection:0] > 0){
        [self scrollToItemAt:[NSIndexPath indexPathForRow:0 inSection:0] position:UICollectionViewScrollPositionTop animated:animated];
    }
    else{
        [self scrollTo:CGPointMake(0, 0) animated:animated];
    }
}

-(void)scrollToBottomAnimated:(BOOL)animated{
    NSInteger rowCount = [self numberOfItemsInSection:0];
    if(rowCount > 0){
        [self scrollToItemAt:[NSIndexPath indexPathForRow:rowCount - 1 inSection:0] position:UICollectionViewScrollPositionBottom animated:animated];
    }
}

-(void)scrollTo:(CGPoint)offset animated:(BOOL)animated{
    [_collectionView setContentOffset:offset animated:animated];
}

#pragma mark - scrollView delegate

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.scrollEndCallback) {
        self.scrollEndCallback(scrollView.contentOffset);
    }
}
/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - collectionView delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataList.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.itemSizeCallback){
        return self.itemSizeCallback(_dataList[indexPath.item], indexPath);
    }
    return _layout.itemSize;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_reuseId forIndexPath:indexPath];
    cell.x_data = _dataList[indexPath.row];
    cell.x_indexPath = indexPath;
    if (self.buildCellCallback) {
        self.buildCellCallback(cell);
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if(self.selectCellCallback){
        self.selectCellCallback(cell);
    }
}

@end
