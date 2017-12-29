//
//  xBlurView.h
//  xSpace
//
//  Created by JSK on 2017/12/30.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////////////

@interface UIImage (xBlur)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius
                         iterations:(NSUInteger)iterations
                          tintColor:(UIColor *)tintColor;

- (UIImage*) imageWithSaturation:(CGFloat)saturation;

@end

////////////////////////////////////////////////////////////////////////////////////////

//毛玻璃视图
@interface xBlurView : UIView

- (void) setContentImage:(UIImage *)image frame:(CGRect)frame alpha:(CGFloat)alpha;
- (void) setContentImage:(UIImage *)image frame:(CGRect)frame;

@end
