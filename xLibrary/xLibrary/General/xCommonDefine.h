

#ifndef xCommonDefine_h
#define xCommonDefine_h

#define kScreenWidth       ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight      ([[UIScreen mainScreen] bounds].size.height)
#define kStatusBarHeight   ([[UIApplication sharedApplication] statusBarFrame].size.height) //20
#define kNavBarHeight      (self.navigationController.navigationBar.frame.size.height) //44
#define kContentWidth      kScreenWidth
#define kContentHeight     (kScreenHeight - kStatusBarHeight - kNavBarHeight)

#define V_IOS_8 (([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)?YES:NO)
#define V_IOS_9 (([[[UIDevice currentDevice] systemVersion] doubleValue]>=9.0)?YES:NO)
#define V_IOS_10 (([[[UIDevice currentDevice] systemVersion] doubleValue]>=10.0)?YES:NO)



#endif /* xCommonDefine_h */
