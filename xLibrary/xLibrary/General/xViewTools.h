

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface xViewTools : NSObject

+ (UIImage *)createSingleColorImage:(CGRect)rect color:(UIColor*)color;

+ (UIButton *)createBorderBtn:(CGRect)frame borderColor:(UIColor*)borderColor bgColor:(UIColor*)bgColor titleColor:(UIColor*)titleColor title:(NSString*)title font:(UIFont*)font target:(id)target selector:(SEL)selector;

+ (UIButton *)createBtn:(CGRect)frame bgColor:(UIColor*)bgColor titleColor:(UIColor*)titleColor title:(NSString*)title font:(UIFont*)font target:(id)target selector:(SEL)selector;

/**
 * @brief  创建指定格式的Label,高度会自动计算
 */
+ (UILabel *)createAttributedLabelWithFrame:(CGRect)frame
                                        str:(NSString*)str
                                       font:(UIFont*)font
                                  textColor:(UIColor*)textColor
                                  lineSpace:(CGFloat)lineSpace;

/**
 * @brief  创建指定格式的Label,高度会自动计算
 */
+(UILabel *)createAttributedLabelWithFrame:(CGRect)frame
                                       str:(NSString *)str
                                      font:(UIFont *)font
                                 textColor:(UIColor *)textColor
                                 lineSpace:(CGFloat)lineSpace
                                 underline:(BOOL)underline;

/**
 *  @brief 创建label
 */
+ (UILabel *) createLabel:(NSString *)text
                    frame:(CGRect)frame
                alignment:(NSTextAlignment)align
                     font:(UIFont *)font
                textColor:(UIColor *)color
                     line:(int)line;

@end
