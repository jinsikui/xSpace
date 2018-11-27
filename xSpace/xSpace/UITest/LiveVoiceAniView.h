//
//  LiveVoiceAniView.h
//  xSpace
//
//  Created by JSK on 2018/10/22.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveVoiceAniView : UIView

-(instancetype)initWithAvatarWidth:(CGFloat)avatarWidth;

-(void)startAnimation;

-(void)stopAnimation;

@end
