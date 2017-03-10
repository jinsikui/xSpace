
#ifndef xFontDefine_h
#define xFontDefine_h

/*
 * 定义字体
 */
#define kFontUseNewVersion  (([[[UIDevice currentDevice] systemVersion] doubleValue]>=9.0) ? YES:NO)

/*!
 *  @brief 字体名称
 */
#define kFontName           kFontUseNewVersion? @"PingFangSC-Regular":@"STHeitiSC-Light"

/*!
 *  @brief 英文和数字字体
 */
#define kFontBold(x)        kFontUseNewVersion? [UIFont systemFontOfSize:x weight:UIFontWeightMedium] : \
                                                [UIFont fontWithName:@"HelveticaNeue-Medium" size:x]
#define kFontRegular(x)     kFontUseNewVersion? [UIFont systemFontOfSize:x weight:UIFontWeightRegular] : \
                                                [UIFont fontWithName:@"HelveticaNeue-Light" size:x]
#define kFontLight(x)       kFontUseNewVersion? [UIFont systemFontOfSize:x weight:UIFontWeightLight] : \
                                                [UIFont fontWithName:@"HelveticaNeue-Thin" size:x]

/*!
 *  @brief 中文字体
 */
#define kFontPF(x)          kFontUseNewVersion? [UIFont fontWithName:@"PingFangSC-Light" size:x] : \
                                                [UIFont lightFont:x]
#define kFontRegularPF(x)   kFontUseNewVersion? [UIFont fontWithName:@"PingFangSC-Regular" size:x] : \
                                                [UIFont regularFont:x]
#define kFontMediumPF(x)    kFontUseNewVersion? [UIFont fontWithName:@"PingFangSC-Medium" size:x] : \
                                                [UIFont mediumFont:x]
#define kFontSemiboldPF(x)  kFontUseNewVersion? [UIFont fontWithName:@"PingFangSC-Semibold" size:x] : \
                                                [UIFont semiboldFont:x]

#endif /* xFontDefine_h */
