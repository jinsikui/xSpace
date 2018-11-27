//
//  xBanner.m
//  QTTourAppStore
//
//  Created by JSK on 2018/4/24.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "xBanner.h"

@interface xBanner()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic) UICollectionView *collectionView;
@property(nonatomic) UICollectionViewFlowLayout *layout;
@property(nonatomic) NSString *reuseId;
@property(nonatomic) xTimer *timer;
@property(nonatomic) NSInteger lastDataIndex;
//当reuseEnabled == NO时，dataList中每一个data对应一个cell，cell存在这里
@property(nonatomic) NSMutableDictionary<NSString*, id> *cellStore;
@end

@implementation xBanner

-(instancetype)initWithCellClass:(Class)cellClass itemSize:(CGSize)itemSize{
    self = [super init];
    if(self){
        [self setDefaults];
        _cellClass = cellClass;
        _itemSize = itemSize;
    }
    return self;
}

-(void)setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
    if(_collectionView){
        _collectionView.scrollEnabled = scrollEnabled;
    }
}


-(void)setDefaults{
    _autoScrollIntervalSeconds = 5;
    _itemSize = CGSizeZero;
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _cellClass = UICollectionViewCell.class;
    _lastDataIndex = 0;
    _itemsInScreen = 1;
    _isCycleScroll = NO;
    _isAutoScroll = NO;
    _scrollEnabled = YES;
    _reuseId = [NSString stringWithFormat:@"%d", arc4random()];
    _reuseEnabled = YES;
    self.backgroundColor = [xColor clearColor];
}

-(void)reloadData{
    if(_collectionView == nil){
        //
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = _scrollDirection;
        _layout.itemSize = _itemSize;
        //
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setPagingEnabled:YES];
        _collectionView.directionalLockEnabled = YES;
        _collectionView.backgroundColor = [xColor clearColor];
        if(_reuseEnabled){
            [_collectionView registerClass:_cellClass forCellWithReuseIdentifier:_reuseId];
        }
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _collectionView.scrollEnabled = _scrollEnabled;
    }
    [_collectionView reloadData];
    if(_isCycleScroll && _isAutoScroll && _dataList.count > _itemsInScreen){
        [self startTimer];
    }
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if(_isCycleScroll && _dataList.count > _itemsInScreen){
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_itemsInScreen inSection:0] atScrollPosition:(_scrollDirection == UICollectionViewScrollDirectionHorizontal ? UICollectionViewScrollPositionLeft:UICollectionViewScrollPositionTop) animated:NO];
    }
}

-(void)disableScroll{
    _collectionView.scrollEnabled = NO;
}

-(void)enableScroll{
    _collectionView.scrollEnabled = YES;
}

#pragma mark - UICollectionViewDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(_dataList != nil){
        if(_dataList.count <= _itemsInScreen){
            return _dataList.count;
        }
        else{
            if(_isCycleScroll){
                return _dataList.count + 2*_itemsInScreen;
            }
            else{
                return _dataList.count;
            }
        }
    }
    else{
        return 0;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger dataIndex = [self getDataIndexByCellIndex:indexPath.item];
    NSIndexPath *dataIndexPath = [NSIndexPath indexPathForItem:dataIndex inSection:0];
    if(_reuseEnabled){
        UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:_reuseId forIndexPath:indexPath];
        if(cell.x_indexPath && cell.x_indexPath.item == dataIndex){
            return cell;
        }
        cell.x_indexPath = dataIndexPath;
        cell.x_data = _dataList[dataIndex];
        if(_buildCellCallback){
            _buildCellCallback(cell);
        }
        return cell;
        
    }
    else{
        NSString *cellId = [NSString stringWithFormat:@"%ld", (long)dataIndex];
        if(_cellStore == nil){
            _cellStore = [[NSMutableDictionary<NSString*, id> alloc] init];
        }
        if(_cellStore[cellId]){
            return _cellStore[cellId];
        }
        [_collectionView registerClass:_cellClass forCellWithReuseIdentifier:cellId];
        UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:dataIndexPath];
        cell.x_indexPath = dataIndexPath;
        cell.x_data = _dataList[dataIndex];
        if(_buildCellCallback){
            _buildCellCallback(cell);
        }
        _cellStore[cellId] = cell;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger dataIndex = [self getDataIndexByCellIndex:indexPath.item];
    id data = _dataList[dataIndex];
    if(_selectCellCallback){
        _selectCellCallback(dataIndex, data);
    }
}

#pragma mark - UIScrollView delegate

//滑动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_dataList.count > 0){
        NSInteger dataIndex = [self getCurrentDataIndex];
        if(_lastDataIndex != dataIndex){
            _lastDataIndex = dataIndex;
            if(_indexChangeCallback){
                _indexChangeCallback(dataIndex);
            }
        }
    }
}

//开始划动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

//停止滑动（手势）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(_isCycleScroll && _isAutoScroll && _dataList.count > _itemsInScreen){
        [self startTimer];
    }
    [self adjustCyclePosition];
    [self triggerStopToItemCallback];
}

//停止滑动（代码）
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(_isCycleScroll && _isAutoScroll && _dataList.count > _itemsInScreen){
        [self startTimer];
    }
    [self adjustCyclePosition];
    [self triggerStopToItemCallback];
}

#pragma mark - Timer

-(void)startTimer{
    if(_timer == nil){
        __weak typeof(self) weak = self;
        _timer = [xTimer timerOnMainWithIntervalSeconds:_autoScrollIntervalSeconds fireOnStart:NO action:^{
            [weak scrollToNext];
        }];
    }
    [_timer start];
}

-(void)stopTimer{
    [_timer stop];
}

-(void)scrollToNext{
    if(_dataList.count > _itemsInScreen){
        NSInteger cellIndex = [self getCellIndexByScrollPosition];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex + 1 inSection:0] atScrollPosition:(_scrollDirection == UICollectionViewScrollDirectionHorizontal ? UICollectionViewScrollPositionLeft:UICollectionViewScrollPositionTop) animated:YES];
    }
}

#pragma mark - Methods

-(void)adjustCyclePosition{
    if(_isCycleScroll && _dataList.count > _itemsInScreen){
        NSInteger cellIndex = [self getCellIndexByScrollPosition];
        if(cellIndex == 0){
            [self scrollToDataIndex:_dataList.count - _itemsInScreen animated:NO];
        }
        if(cellIndex == _dataList.count + _itemsInScreen){
            [self scrollToDataIndex:0 animated:NO];
        }
    }
}

-(NSInteger)getCellIndexByScrollPosition{
    if(_collectionView){
        if(_scrollDirection == UICollectionViewScrollDirectionHorizontal){
            NSInteger cellIndex = (NSInteger)ceil((_collectionView.contentOffset.x + _itemSize.width * 0.5)/_itemSize.width -1);
            return cellIndex;
        }
        else{
            NSInteger cellIndex = (NSInteger)ceil((_collectionView.contentOffset.y + _itemSize.height * 0.5)/_itemSize.height -1);
            return cellIndex;
        }
    }
    return -1;
}

-(NSInteger)getDataIndexByCellIndex:(NSInteger)cellIndex{
    if(_dataList.count > 0){
        if(_dataList.count <= _itemsInScreen){
            return cellIndex;
        }
        if(!_isCycleScroll){
            return cellIndex;
        }
        if(cellIndex < _itemsInScreen){
            return _dataList.count - (_itemsInScreen - cellIndex);
        }
        else if(cellIndex >= _itemsInScreen && cellIndex < _dataList.count + _itemsInScreen){
            return cellIndex - _itemsInScreen;
        }
        else{
            return cellIndex - _dataList.count - _itemsInScreen;
        }
    }
    else{
        return -1;
    }
}

-(NSInteger)getCurrentDataIndex{
    return [self getDataIndexByCellIndex:[self getCellIndexByScrollPosition]];
}

-(void)scrollToDataIndex:(NSInteger)dataIndex animated:(BOOL)animated{
    if(_dataList){
        if(!_isCycleScroll || _dataList.count <= _itemsInScreen){
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:dataIndex inSection:0] atScrollPosition:(_scrollDirection == UICollectionViewScrollDirectionHorizontal ? UICollectionViewScrollPositionLeft:UICollectionViewScrollPositionTop) animated:animated];
        }
        else{
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:dataIndex + _itemsInScreen inSection:0] atScrollPosition:(_scrollDirection == UICollectionViewScrollDirectionHorizontal ? UICollectionViewScrollPositionLeft:UICollectionViewScrollPositionTop) animated:animated];
        }
    }
}

-(void)triggerStopToItemCallback{
    if(_stopToItemCallback){
        NSInteger dataIndex = [self getCurrentDataIndex];
        id data = _dataList[dataIndex];
        _stopToItemCallback(dataIndex, data);
    }
}

@end
