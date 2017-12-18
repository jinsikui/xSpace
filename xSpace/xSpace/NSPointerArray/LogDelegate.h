//
//  LogDelegate.h
//  xSpace
//
//  Created by JSK on 2017/12/7.
//  Copyright © 2017年 xSpace. All rights reserved.
//

@protocol LogDelegate <NSObject>

@required
- (void)log:(NSString*)msg;

@end
