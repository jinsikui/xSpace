

#import "UIView+xBannerLoading.h"
#import "Masonry.h"

#define kBannerLoadingViewTag  1024

@implementation UIView(TJBannerLoading)

-(void)startBannerLoading{
    xBannerLoadingView *v = [self viewWithTag:kBannerLoadingViewTag];
    if(!v){
        v = [[xBannerLoadingView alloc] initWithParentView:self];
    }
    [v show];
    [v startLoading];
}

-(void)stopBannerLoading{
    xBannerLoadingView *v = [self viewWithTag:kBannerLoadingViewTag];
    if(v){
        [v stopLoading];
        [v removeFromSuperview];
    }
}

@end

@interface xBannerLoadingView()

@property(nonatomic,strong)UIView *v1;
@property(nonatomic,strong)UIView *v2;
@property(nonatomic,strong)UIView *v3;
@property(nonatomic,assign)NSInteger state;
@property(nonatomic,assign)BOOL isLoading;
@end

@implementation xBannerLoadingView

-(instancetype)initWithParentView:(UIView*)parentView{
    self = [super init];
    if(self){
        self.tag = kBannerLoadingViewTag;
        [parentView addSubview:self];
        self.clipsToBounds = NO;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(parentView);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(6);
        }];
        //
        _v1 = [[UIView alloc] init];
        _v1.layer.cornerRadius = 3;
        [self addSubview:_v1];
        _v1.backgroundColor = [UIColor whiteColor];
        _v1.alpha = 0.3;
        [_v1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(6);
            make.left.mas_equalTo(0);
            make.centerY.equalTo(self.mas_centerY);
        }];
        //
        _v2 = [[UIView alloc] init];
        _v2.layer.cornerRadius = 3;
        [self addSubview:_v2];
        _v2.backgroundColor = [UIColor whiteColor];
        _v2.alpha = 0.3;
        [_v2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(6);
            make.left.mas_equalTo(_v1.mas_right).offset(6);
            make.centerY.equalTo(self.mas_centerY);
        }];
        //
        _v3 = [[UIView alloc] init];
        _v3.layer.cornerRadius = 3;
        [self addSubview:_v3];
        _v3.backgroundColor = [UIColor whiteColor];
        _v3.alpha = 0.3;
        [_v3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(6);
            make.left.mas_equalTo(_v2.mas_right).offset(6);
            make.centerY.equalTo(self.mas_centerY);
        }];
        _state = 2;
        _isLoading = NO;
    }
    return self;
}

-(void)doAnimation{
    if(!_isLoading){
        return;
    }
    if(_state == 2){
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat scale = 7.f/6.f;
            _v1.transform = CGAffineTransformMakeScale(scale, scale);
            _v1.alpha = 1;
            
            _v2.transform = CGAffineTransformMakeScale(1, 1);
            _v2.alpha = 0.3;
            
            _v3.transform = CGAffineTransformMakeScale(scale, scale);
            _v3.alpha = 1;
        } completion:^(BOOL finished) {
            _state = 1;
            [self doAnimation];
        }];
    }
    else if(_state == 1){
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat scale = 7.f/6.f;
            _v1.transform = CGAffineTransformMakeScale(1, 1);
            _v1.alpha = 0.3;
            
            _v2.transform = CGAffineTransformMakeScale(scale, scale);
            _v2.alpha = 1;
            
            _v3.transform = CGAffineTransformMakeScale(1, 1);
            _v3.alpha = 0.3;
        } completion:^(BOOL finished) {
            _state = 2;
            [self doAnimation];
        }];
    }
}

-(void)startLoading{
    _isLoading = YES;
    [self doAnimation];
}

-(void)stopLoading{
    _isLoading = NO;
}

-(void)show{
    self.hidden = NO;
}

-(void)hide{
    self.hidden = YES;
    [self removeFromSuperview];
}

@end
