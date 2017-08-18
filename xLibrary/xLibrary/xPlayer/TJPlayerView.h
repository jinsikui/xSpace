//
//  TJPlayerView.h
//  视频播放器
//
//  Created by 王亚军 on 16/11/11.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TJPlayerViewProtocol;
@interface TJPlayerView : UIView
@property(nonatomic,strong)NSString *videoUrl;
@property(nonatomic,strong)NSString *videoTitle;
@property(nonatomic,weak)id<TJPlayerViewProtocol >delegate;

-(void)showInView:(UIView *)inView;
@end

@protocol TJPlayerViewProtocol <NSObject>
@required
-(void)playerShowFullView:(TJPlayerView *)player isFullView:(BOOL)isFull;
-(void)playerBackViewPress:(TJPlayerView *)player;
@end
