//
//  SingletonManager.m
//  xSpace
//
//  Created by JSK on 2018/5/18.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "SingletonManager.h"
#import "SingletonController.h"

@implementation SingletonManager

+(void)showAndUpdateSingleton{
    UIViewController *curVC = [xControllerHelper curVC];
    if([curVC isKindOfClass:[SingletonController class]]){
        [(SingletonController*)curVC update];
        return;
    }
    UINavigationController *navc = curVC.navigationController;
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray arrayWithArray:navc.viewControllers];
    SingletonController *c = (SingletonController*)[controllers first:^BOOL(UIViewController *controller) {
        return [controller isKindOfClass:[SingletonController class]];
    }];
    if(c){
        [controllers removeObject:c];
        [navc setViewControllers:controllers animated:NO];
        [navc pushViewController:c animated:YES];
    }
    else{
        c = [SingletonController new];
        [navc pushViewController:c animated:YES];
    }
    [c update];
}

@end
