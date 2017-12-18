//
//  xGridView.h
//  xLibrary
//
//  Created by JSK on 2017/11/19.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UICollectionViewCell (xGridView)

@property(nonatomic,strong)id x_data;

@property(nonatomic)NSIndexPath *x_indexPath;

@end

@interface xGridView : UIView <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property(nonatomic,strong)NSArray *dataList;

@property(nonatomic)CGSize itemSize;

@property(nonatomic)CGFloat lineSpace;

@property(nonatomic)CGFloat interitemSpace;

@property(nonatomic)UICollectionViewScrollDirection scrollDirection;

@property(nonatomic)BOOL isScrollEnabled;

@property(nonatomic) BOOL isScrollsToTop;

@property(nonatomic)BOOL bounces;

@property(nonatomic) UIEdgeInsets contentInset;

@property(nonatomic,copy)void (^scrollEndCallback)(CGPoint);

@property(nonatomic,copy)void (^buildCellCallback)(UICollectionViewCell*);

@property(nonatomic,copy)CGSize(^itemSizeCallback)(id data, NSIndexPath *indexpath);

@property(nonatomic,copy)void (^selectCellCallback)(UICollectionViewCell*);

-(instancetype)initWithCellClass:(Class)cellClass;

-(instancetype)initWithFrame:(CGRect)frame;

-(UICollectionViewCell *)cellWithIndexPath:(NSIndexPath *)path;

@property(nonatomic,readonly)NSInteger numberOfSections;

-(NSInteger)numberOfItemsInSection:(NSInteger)section;

-(void)reloadData;

-(void)scrollToItemAt:(NSIndexPath*)indexPath position:(UICollectionViewScrollPosition)position animated:(BOOL)animated;

-(void)scrollToTopAnimated:(BOOL)animated;

-(void)scrollToBottomAnimated:(BOOL)animated;

-(void)scrollTo:(CGPoint)offset animated:(BOOL)animated;

@end
