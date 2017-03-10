

#ifndef xCommonDefine_h
#define xCommonDefine_h

#define kScreenWidth       ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight      ([[UIScreen mainScreen] bounds].size.height)
#define kStatusBarHeight   ([[UIApplication sharedApplication] statusBarFrame].size.height) //20
#define kNavBarHeight      (self.navigationController.navigationBar.frame.size.height) //44
#define kContentWidth      kScreenWidth
#define kContentHeight     (kScreenHeight - kStatusBarHeight - kNavBarHeight)



#endif /* xCommonDefine_h */
