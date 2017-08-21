

#import "xPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "xNoticeCenter.h"
@interface xPlayer ()
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic ,strong) id playbackTimeObserver;
// 是否正在播放
@property(nonatomic)BOOL isPlaying;
// 是否播放结束
@property (nonatomic) BOOL isVideoEnd;
// 进入后台时播放器的播放状态
@property (nonatomic) BOOL appBackIsPlaying;
@end
static void *PlayViewCMTimeValue = &PlayViewCMTimeValue;

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;
static void *PlayViewloadedTimeRanges = &PlayViewloadedTimeRanges;
@implementation xPlayer

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - initialize
- (void) initialize {
    //设置静音状态也可播放声音
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.layer addSublayer:self.playerLayer];
    self.backgroundColor = [UIColor blackColor];
    __weak typeof(self)weak = self;
   self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if ([weak.delegate respondsToSelector:@selector(player:playTime:allTime:)]) {
           CGFloat durationTime = CMTimeGetSeconds(weak.playerItem.duration);
            
           CGFloat currentTime = CMTimeGetSeconds(weak.playerItem.currentTime);
            [weak.delegate player:weak playTime:currentTime allTime:durationTime];
        }
    }];
    
    [[xNoticeCenter sharedInstance] registerAppBecomeActive:self block:^{
        if(weak.appBackIsPlaying ) {
          [weak.player play];
        }
    }];
    [[xNoticeCenter sharedInstance] registerAppEnterBackground:self block:^{
        weak.appBackIsPlaying = weak.isPlaying;
        [weak.player pause];
    }];
}
-(void)setVideoUrl:(NSString *)videoUrl {
        
    _videoUrl = videoUrl;
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
     [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    


    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoUrl]];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    if([[UIDevice currentDevice] systemVersion].intValue>=10){
        //      增加下面这行可以解决iOS10兼容性问题了
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    }
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
     [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区空了，需要等待数据
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    // 缓冲区有足够数据可以播放了
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            if ([self.delegate respondsToSelector:@selector(playerStart)]) {
                [self.delegate playerStart];
            }
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            if ([self.delegate respondsToSelector:@selector(playerFailure)]) {
                [self.delegate playerFailure];
            }
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        if ([self.delegate respondsToSelector:@selector(player:cacheLength:allLength:)]) {
            [self.delegate player:self cacheLength:timeInterval allLength:totalDuration];
        }
    }
}
- (void)moviePlayDidEnd {
    if (_isVideoEnd) {
        return;
    }
    _isVideoEnd = YES;
    if ([self.delegate respondsToSelector:@selector(playerEnd)]) {
        [self.delegate playerEnd];
    }
}
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
}

#pragma mark - public
//暂停
- (void) pause {
    if (!_isPlaying) {
        return;
    }
     _isPlaying = NO;
    [self.player pause];
    _currentTime = CMTimeGetSeconds(self.player.currentTime);
}
//播放
- (void) play {
    
    if (_isPlaying) {
        return;
    }
    _isPlaying = YES;
    if (!_isVideoEnd) {
        [self.player play];
    }else{
        _currentTime = 0;
        __weak typeof(self)weak = self;
        [self.player seekToTime:CMTimeMakeWithSeconds(self.currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            weak.isVideoEnd = NO;
            [weak.player play];
        }];
    }
    
}

-(void)resetPlayView {
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    _videoUrl = nil;
}

-(void)setCurrentTime:(NSTimeInterval)currentTime {
    
    _currentTime = currentTime;
     __weak typeof(self)weak = self;
    [self.player seekToTime:CMTimeMakeWithSeconds(self.currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        weak.isVideoEnd = NO;
        weak.isPlaying = YES;
        [weak.player play];
    }];
}

#pragma mark
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];

     [self.player removeTimeObserver:self.playbackTimeObserver];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.player pause];
    [self.playerLayer removeFromSuperlayer];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
    
}
@end
