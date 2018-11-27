//
//  UITestController.m
//  xSpace
//
//  Created by JSK on 2017/11/22.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "UITestController.h"
#import "Masonry.h"
#import "PopView.h"
#import "YYText.h"
#import "xCornerView.h"
#import "LiveVoiceAniView.h"

@interface UITestController ()
@property(nonatomic,strong) LiveVoiceAniView *voiceView;
@end

@implementation UITestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UI Test";
    self.view.backgroundColor = kColor(0);
    
    UIImageView *avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar-placeholder"]];
    CGFloat avatarWidth = 50;
    avatar.frame = CGRectMake(100, 100, avatarWidth, avatarWidth);
    avatar.clipsToBounds = YES;
    avatar.layer.cornerRadius = avatarWidth / 2.0;
    [self.view addSubview:avatar];
    
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionUserClick)];
    avatar.userInteractionEnabled = YES;
    [avatar addGestureRecognizer:g];
    
    _voiceView = [[LiveVoiceAniView alloc] initWithAvatarWidth:avatarWidth];
    [self.view insertSubview:_voiceView belowSubview:avatar];
    [_voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(avatar);
        make.width.height.mas_equalTo(avatarWidth * 144.0 / 100);
    }];
    [xTask asyncMainAfter:3 task:^{
        [_voiceView startAnimation];
        [xTask asyncMainAfter:7 task:^{
            [_voiceView stopAnimation];
        }];
    }];
}

-(void)actionUserClick{
    NSLog(@"===== actionUserClick =====");
}

@end
