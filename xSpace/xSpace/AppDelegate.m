

#import "AppDelegate.h"
#import "PortalNavigationController.h"
#import "PortalIndexController.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate (){
}
@property(nonatomic) UIView *a;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    //导航栏样式
    UINavigationBar *navBar = [UINavigationBar appearance];
    //导航栏标题
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColor(0x000000),NSForegroundColorAttributeName, kFontPF(18), NSFontAttributeName, nil]];
    //导航栏背景
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] rect:CGRectMake(0, 0, 1, 1)] forBarMetrics:UIBarMetricsDefault];
    //导航栏底部边框样式
    [navBar setShadowImage:[UIImage imageWithColor:kColor(0xE9E9E9) rect:CGRectMake(0, 0, 1, 0.5)]];
    //返回按钮
    [navBar setBackIndicatorImage:[[UIImage imageNamed:@"nav_back_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [navBar setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"nav_back_btn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //隐藏返回文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-9999, 0.f) forBarMetrics:UIBarMetricsDefault];
    //导航栏按钮文字
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kColor(0x000000),NSForegroundColorAttributeName, kFontPF(14), NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    @try {
        NSError *error;
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    }
    @catch(NSException *exception) {
        NSLog(@"Setting category to AVAudioSessionCategoryPlayAndRecord failed.");
    }
    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[PortalNavigationController alloc] initWithRootViewController:[[PortalIndexController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
