//
//  TJPlayer.h
//  视频播放器
//
//  Created by 王亚军 on 16/11/11.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TJPlayerDelegate;
@interface TJPlayer : UIControl
// 播放视频的url
@property(nonatomic,strong)NSString *videoUrl;
// 当前的播放时间
@property(nonatomic)NSTimeInterval currentTime;
// 
@property(nonatomic,weak)id<TJPlayerDelegate>delegate;
//暂停
- (void)pause ;
//播放
- (void)play ;
//重置播放器
-(void)resetPlayView;
@end
@protocol TJPlayerDelegate <NSObject>
@optional
// 回调当前的播放进度
-(void)player:(TJPlayer *)player playTime:(NSTimeInterval)interval allTime:(NSTimeInterval)allTime;
// 回调当前的缓存进度
-(void)player:(TJPlayer *)player cacheLength:(NSTimeInterval)interval allLength:(NSTimeInterval)allLength;
;
// 播放开始
-(void)playerStart;
// 播放结束
-(void)playerEnd;
// 发生错误
-(void)playerFailure;
@end
