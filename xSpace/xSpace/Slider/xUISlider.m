//
//  xUISlider.m
//  xSpace
//
//  Created by JSK on 2018/6/10.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "xUISlider.h"

@implementation xUISlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    bounds.origin.y = bounds.size.height / 2.0 - 1.5;
    bounds.size.height = 3;
    return bounds;
}

@end
