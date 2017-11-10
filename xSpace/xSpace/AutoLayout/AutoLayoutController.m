

#import "AutoLayoutController.h"
#import "Masonry.h"

@interface AutoLayoutController (){
    UIView *v1_;
    UIView *v2_;
    UIView *v3_;
    UIView *v4_;
    UIView *v5_;
    CGFloat heightScale_;
    NSLayoutConstraint *heightConstraint_;
}

@end

@implementation AutoLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"AutoLayout";
    self.view.backgroundColor = kColor_FFFFFF;
    
    v1_ = [[UIView alloc] init];
    v1_.backgroundColor = kRed_FF6600;
    [self.view addSubview:v1_];
    
    v2_ = [[UIView alloc] init];
    v2_.backgroundColor = kGreen_7DD429;
    [self.view addSubview:v2_];
    
    v3_ = [[UIView alloc] init];
    v3_.backgroundColor = kBlue_0066CC;
    [self.view addSubview:v3_];
    
    v4_ = [[UIView alloc] init];
    v4_.backgroundColor = kYellow_FFFFD7;
    [self.view addSubview:v4_];
    
    v5_ = [[UIView alloc] init];
    v5_.backgroundColor = kGray_666666;
    [self.view addSubview:v5_];
    [v5_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionChangeSize)]];
    
    
    //设置不要把frame转化成constraint
    v1_.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:v1_ attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    //只有在没有参照控件的情况下，约束才加到自身，不然加到父控件上
    [self.view addConstraint:left];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:v1_ attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:top];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:v1_ attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0.0];
    [self.view addConstraint:width];
    heightConstraint_ = [NSLayoutConstraint constraintWithItem:v1_ attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0.0];
    [self.view addConstraint:heightConstraint_];
    
//    [v1_ mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.top.equalTo(self.view.mas_top).offset(0);
//        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
//        make.height.equalTo(self.view.mas_height).multipliedBy(0.5);
//    }];
    
    heightScale_ = 0.5;
    
    [v2_ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1_.mas_right).offset(0);
        make.top.and.width.and.height.equalTo(v1_);
    }];
    
    [v3_ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1_);
        make.top.equalTo(v1_.mas_bottom).offset(0);
        make.width.and.height.equalTo(v1_);
    }];
    
    [v4_ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v3_.mas_right).offset(0);
        make.top.and.width.and.height.equalTo(v3_);
    }];
    
    //v5_.frame = CGRectMake(0.5*(kContentWidth - 100), 0.5*(kContentHeight - 100), 100, 100);
    
    [v5_ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100));
        make.height.equalTo(@(100));
        make.center.equalTo(self.view);
    }];
}

-(void)actionChangeSize{
    if(heightScale_ == 0.5){
        heightScale_ = 0.25;
    }
    else{
        heightScale_ = 0.5;
    }
    
    [self.view removeConstraint:heightConstraint_];
    heightConstraint_ = [NSLayoutConstraint constraintWithItem:v1_ attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:heightScale_ constant:0.0];
    [self.view addConstraint:heightConstraint_];
    
//    [v1_ mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.top.equalTo(self.view.mas_top).offset(0);
//        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
//        make.height.equalTo(self.view.mas_height).multipliedBy(heightScale_);
//    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

////屏幕旋转
//-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//    //旋转前
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        //动画
//        v5_.frame = CGRectMake(0.5*(kContentWidth - 100), 0.5*(kContentHeight - 100), 100, 100);
//        
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        //旋转后
//    }];
//}



@end
