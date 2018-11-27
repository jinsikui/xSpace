//
//  LiveExtensions.h
//  QTTourAppStore
//
//  Created by JSK on 2018/4/11.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LiveExtension)

-(void)qt_showAvatar:(NSString*)url width:(CGFloat)width;

-(void)qt_showImage:(NSString*)url;

@end

@interface NSObject (LiveExtension)

@property(nonatomic,assign) BOOL qt_initialized;

@end

@interface NSString (LiveExtension)

-(NSDate*)lv_toDate;

@end

@interface NSNull (LiveExtension)

-(NSDate*)lv_toDate;

@end
