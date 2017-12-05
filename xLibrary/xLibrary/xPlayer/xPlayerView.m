

#import "xPlayerView.h"
#import "xPlayer.h"
#import "Masonry.h"
#import "xTimer.h"


@interface xPlayerView()<xPlayerDelegate>
@property(nonatomic,strong)xPlayer *player;

@property (nonatomic, strong) UIActivityIndicatorView *loadingProgress;

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UISlider *cacheSlider;
@property (nonatomic, strong) UILabel *currentVideoTime;
@property (nonatomic, strong) UILabel *totalVideoTime;

@property (nonatomic, strong) UIButton *playOrPauseButton;

@property (nonatomic) BOOL isShowView;
@property (nonatomic,strong) xTimer *timer;
@property (nonatomic) NSTimeInterval duration;
@end

@implementation xPlayerView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        _player = [[xPlayer alloc] init];
        [self addSubview:_player];
        [_player mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        _player.delegate = self;
        [self initTopView];
        [self initBottomView];
        [self addSubview:self.playOrPauseButton];
        [self.playOrPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [_player addTarget:self action:@selector(playerViewPress) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)initBottomView {
    [self addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.bottomBar addSubview:self.currentVideoTime];
    [self.currentVideoTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(30);
    }];
    
    [self.bottomBar addSubview:self.totalVideoTime];
    [self.totalVideoTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(30);
    }];
    
    [self.bottomBar addSubview:self.progressView];
    [self.progressView setProgress:0.0 animated:NO];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currentVideoTime.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.totalVideoTime.mas_left).offset(-5);
         make.height.mas_equalTo(3);
    }];
    
    [self.bottomBar addSubview:self.cacheSlider];
    [self.cacheSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currentVideoTime.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.totalVideoTime.mas_left).offset(-5);
        make.top.and.bottom.mas_equalTo(0);
    }];
    
}

-(void)initTopView {
    
    [self addSubview:self.topBar];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(54);
        make.top.mas_equalTo(0);
        
    }];
}

-(void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    _player.videoUrl = videoUrl;
    [_player play];
    [self showLoading];
    __weak typeof(self)weak = self;
    self.timer = [xTimer timerWithIntervalSeconds:3 queue:dispatch_get_main_queue() fireOnStart:NO action:^{
        [weak hiddenMaskView];
    }];
    [self.timer start];
}
-(void)hiddenMaskView {
    if (self.topBar.alpha != 1) {
        return;
    }
    [self playerViewPress];
}
#pragma mark --
-(void)playerEnd {
   [self.delegate playerBackViewPress:self];
}
-(void)playerStart {
    [self hiddenLoading];
}
-(void)playerFailure {
    
}
-(void)player:(xPlayer *)player playTime:(NSTimeInterval)interval allTime:(NSTimeInterval)allTime {
     [self updateTimeWithCurrentTime:interval duration:allTime];
}
-(void)player:(xPlayer *)player cacheLength:(NSTimeInterval)interval allLength:(NSTimeInterval)allLength {
    self.progressView.progress = interval/allLength;
}
- (void)updateTimeWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    dMin = dMin<0?0:dMin;
    dSec = dSec<0?0:dSec;
    cMin = cMin<0?0:cMin;
    cSec = cSec<0?0:cSec;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", (long)dMin, (long)dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", (long)cMin, (long)cSec];
    
    self.currentVideoTime.text = currentString;
    self.totalVideoTime.text = durationString;
    [self.cacheSlider setValue: currentTime/duration animated:NO];
    self.duration = duration;
}

#pragma mark --
-(void)showInView:(UIView *)inView {
    [inView addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(inView.mas_width);
        make.height.equalTo(inView.mas_height);
        make.center.equalTo(@(0));
    }];
    
}
//根据想要旋转的方向来设置旋转
-(CGAffineTransform)getOrientation{
    return CGAffineTransformMakeRotation(M_PI_2);
//    //状态条的方向已经设置过,所以这个就是你想要旋转的方向
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    //根据要进行旋转的方向来计算旋转的角度
//    if (orientation ==UIInterfaceOrientationPortrait) {
//        return CGAffineTransformIdentity;
//    }else if (orientation ==UIInterfaceOrientationLandscapeLeft){
//        return CGAffineTransformMakeRotation(-M_PI_2);
//    }else if(orientation ==UIInterfaceOrientationLandscapeRight){
//        return CGAffineTransformMakeRotation(M_PI_2);
//    }
//    return CGAffineTransformIdentity;
}

-(void)actionBackButton {
    [self.player resetPlayView];
    [self.delegate playerBackViewPress:self];
}
-(void)playerViewPress {
    [self.timer stop];
    [UIView animateWithDuration:0.5 animations:^{
        if (self.bottomBar.alpha == 0.0) {
            self.bottomBar.alpha = 1.0;
            self.topBar.alpha = 1.0;
            self.playOrPauseButton.alpha = 1.0;
            [self.delegate playerShowFullView:self isFullView:NO];
        }else{
            self.bottomBar.alpha = 0.0;
            self.topBar.alpha = 0.0;
            self.playOrPauseButton.alpha = 0.0;
            [self.delegate playerShowFullView:self isFullView:YES];
        }
    } completion:^(BOOL finish){
        
    }];
}
-(void)playOrPauseButtonClick:(UIButton *)playBnt {
    playBnt.selected = !playBnt.selected;
    if (playBnt.selected) {
        [self.player pause];
    }else {
        [self.player play];
    }
}
#pragma mark
-(void)showLoading {
    [self addSubview:self.loadingProgress];
    [self.loadingProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}
-(void)hiddenLoading {
    [self.loadingProgress removeFromSuperview];
}
#pragma mark - 播放进度
- (void)updateProgress:(UISlider *)slider{
    if (self.duration <= 0) {
        return;
    }
    self.player.currentTime = slider.value * self.duration;
    self.playOrPauseButton.selected = NO;
}
#pragma mark --
-(void)setVideoTitle:(NSString *)videoTitle {
    _videoTitle = videoTitle;
    self.titleLabel.text = videoTitle;
}
#pragma mark - getter
- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UIButton *backBnt = [[UIButton alloc] initWithFrame:CGRectMake(-20, 10, 80, 44)];
        [backBnt setImage:[UIImage imageNamed:@"playerBack"] forState:UIControlStateNormal];
        [_topBar addSubview:backBnt];
        [backBnt addTarget:self action:@selector(actionBackButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_topBar addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(backBnt);
        }];
    }
    return _topBar;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] init];
        _bottomBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _bottomBar;
}
- (UISlider *)cacheSlider {
    if (!_cacheSlider) {
        _cacheSlider = [[UISlider alloc] init];
        _cacheSlider.userInteractionEnabled = YES;
        [_cacheSlider setThumbImage:[UIImage imageNamed:@"playerDot"] forState:UIControlStateNormal];
        [_cacheSlider setMinimumTrackTintColor:[UIColor redColor]];
        [_cacheSlider setMaximumTrackTintColor:[UIColor clearColor]];
        _cacheSlider.value = 0.f;
        _cacheSlider.continuous = YES;
        //进度条的拖拽事件
        [_cacheSlider addTarget:self action:@selector(updateProgress:)  forControlEvents:UIControlEventValueChanged];
    }
    return _cacheSlider;
}
- (UILabel *)currentVideoTime{
    if (!_currentVideoTime) {
        _currentVideoTime = [[UILabel alloc] init];
        _currentVideoTime.textAlignment = NSTextAlignmentCenter;
        _currentVideoTime.textColor = kColor(0xFFFFFF);
        _currentVideoTime.font = [UIFont systemFontOfSize:10];
        _currentVideoTime.text = @"00:00";
    }
    return _currentVideoTime;
}

- (UILabel *)totalVideoTime {
    if (!_totalVideoTime) {
        _totalVideoTime = [[UILabel alloc] init];
        _totalVideoTime.textAlignment = NSTextAlignmentCenter;
        _totalVideoTime.textColor = kColor(0xFFFFFF);
        _totalVideoTime.font = [UIFont systemFontOfSize:10];
        _totalVideoTime.text = @"00:00";
    }
    return _totalVideoTime;
}
-(UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = kColor(0x333333);
        _progressView.trackTintColor    = kColor(0x555555);
    }
    return _progressView;
}
-(UIActivityIndicatorView *)loadingProgress {
    if (!_loadingProgress) {
        _loadingProgress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _loadingProgress;
}

- (UIButton *)playOrPauseButton
{
    if (!_playOrPauseButton) {
        _playOrPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"kr-video-player-pause"] forState:UIControlStateNormal];
         [_playOrPauseButton setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateSelected];
        [_playOrPauseButton addTarget:self action:@selector(playOrPauseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _playOrPauseButton.alpha = 1;
    }
    return _playOrPauseButton;
}

@end
