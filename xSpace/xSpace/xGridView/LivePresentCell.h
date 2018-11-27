//
//  LivePresentCell.h
//  xSpace
//
//  Created by JSK on 2018/4/28.
//  Copyright © 2018年 xSpace. All rights reserved.
//
#import "LivePresent.h"

@interface LivePresentCell:UICollectionViewCell
@property(nonatomic) LivePresent *present;
@property(nonatomic) BOOL isBig;
-(void)refreshByPresent:(LivePresent*)present isBig:(BOOL)isBig;
@end
