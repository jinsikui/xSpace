

#import <UIKit/UIKit.h>
@protocol xPlayerDelegate;
@interface xPlayer : UIControl
// 播放视频的url
@property(nonatomic,strong)NSString *videoUrl;
// 当前的播放时间
@property(nonatomic)NSTimeInterval currentTime;
// 
@property(nonatomic,weak)id<xPlayerDelegate>delegate;
//暂停
- (void)pause ;
//播放
- (void)play ;
//重置播放器
-(void)resetPlayView;
@end
@protocol xPlayerDelegate <NSObject>
@optional
// 回调当前的播放进度
-(void)player:(xPlayer *)player playTime:(NSTimeInterval)interval allTime:(NSTimeInterval)allTime;
// 回调当前的缓存进度
-(void)player:(xPlayer *)player cacheLength:(NSTimeInterval)interval allLength:(NSTimeInterval)allLength;
;
// 播放开始
-(void)playerStart;
// 播放结束
-(void)playerEnd;
// 发生错误
-(void)playerFailure;
@end
