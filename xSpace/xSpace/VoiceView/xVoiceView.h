//
//  xVoiceView.h
//  QTTourAppStore
//
//  Created by JSK on 2018/8/20.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xVoiceView : UIView

-(instancetype)initWithBoxSize:(CGSize)boxSize;

-(void)startAnimation;

-(void)pauseAnimation;

-(void)resumeAnimation;

-(void)reset;

@end
