

#import "UIFont+xExtension.h"

@implementation UIFont (xExtension)

+ (UIFont *) lightFont:(CGFloat)size
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.19) {
        return [UIFont systemFontOfSize:size weight:UIFontWeightLight];
    }
    
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+ (UIFont *) regularFont:(CGFloat)size
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.19) {
        return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
    }
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *) mediumFont:(CGFloat)size
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.19) {
        return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
    }
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *) semiboldFont:(CGFloat)size
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.19) {
        return [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
    }
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

@end
