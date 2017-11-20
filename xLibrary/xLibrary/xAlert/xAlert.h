//
//  xAlert.h
//  xLibrary
//
//  Created by JSK on 2017/8/3.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xAlertController : UIAlertController

- (void) show:(BOOL)animated completion:(void (^ __nullable)(void))completion;

@end

//======================================================================

typedef NS_ENUM(NSInteger, xAlertResult)
{
    xAlertResultCancel = 0,
    xAlertResultConfirm = 1
};

typedef void(^xAlertResultCallback)(xAlertResult result);

@interface xAlert : NSObject

+ (void) showWithMessage:(NSString *)message;

+ (void) showWithMessage:(NSString *)message completionHandler:(xAlertResultCallback)completionHandler;

+ (void) showWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle completionHandler:(xAlertResultCallback)completionHandler;

@end
