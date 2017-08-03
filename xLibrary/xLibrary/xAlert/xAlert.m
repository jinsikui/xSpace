//
//  xAlert.m
//  xLibrary
//
//  Created by JSK on 2017/8/3.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "xAlert.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface xAlertController()

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation xAlertController

- (void) show:(BOOL)animated completion:(void (^ __nullable)(void))completion
{
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[UIViewController alloc] init];
    self.alertWindow.windowLevel = UIWindowLevelAlert;
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:completion];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return [UIApplication sharedApplication].statusBarStyle;
}

- (BOOL) prefersStatusBarHidden
{
    return [UIApplication sharedApplication].statusBarHidden;
}

@end

//======================================================================

#define kAlertHandlerKey "talertconfig"

@interface xAlertContext : NSObject<UIAlertViewDelegate>

@property (nonatomic) BOOL haveShow;
@property (nonatomic, strong) NSString *lastAlert;

@end

@implementation xAlertContext

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _haveShow = NO;
    xAlertResultCallback callback = (xAlertResultCallback)objc_getAssociatedObject(alertView, &kAlertHandlerKey);
    if (callback) {
        callback(buttonIndex == 1 ? xAlertResultConfirm:xAlertResultCancel);
    }
}

@end

static xAlertContext *alertContext = nil;

//======================================================================

@implementation xAlert

+ (void) initialize
{
    alertContext  = [[xAlertContext alloc] init];
}

+ (void) showAlertWithMessage:(NSString *)message
{
    [self showAlertWithTitle:@"提示" message:message cancelTitle:@"确定" confirmTitle:nil completionHandler:nil];
}

+ (void) showAlertWithMessage:(NSString *)message completionHandler:(xAlertResultCallback)completionHandler
{
    [self showAlertWithTitle:@"提示" message:message cancelTitle:@"确定" confirmTitle:nil completionHandler:completionHandler];
}

+ (void) showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle completionHandler:(xAlertResultCallback)completionHandler
{
    if (alertContext.haveShow == YES && [alertContext.lastAlert isEqualToString:message]) {
        return;
    }
    alertContext.haveShow = YES;
    alertContext.lastAlert = message;
    if (V_IOS_8) {
        
        //
        xAlertController *alertController = [xAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        //
        if (cancelTitle.length > 0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                alertContext.haveShow = NO;
                if (completionHandler) {
                    completionHandler(xAlertResultCancel);
                }
            }];
            [alertController addAction:cancelAction];
        }
        
        //
        if (confirmTitle.length > 0) {
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                alertContext.haveShow = NO;
                if (completionHandler) {
                    completionHandler(xAlertResultConfirm);
                }
            }];
            [alertController addAction:confirmAction];
        }
        
        //
        [alertController show:YES completion:nil];
        
    } else {
        //
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:alertContext cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
        if (completionHandler) {
            objc_setAssociatedObject(alertView, &kAlertHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
        }
        [alertView show];
    }
}

@end

