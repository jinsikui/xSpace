

#import "xViewTools.h"

@implementation xViewTools

+ (UIImage *)createSingleColorImage:(CGRect)rect color:(UIColor*)color{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIButton *)createBtn:(CGRect)frame bgColor:(UIColor*)bgColor titleColor:(UIColor*)titleColor title:(NSString*)title font:(UIFont*)font target:(id)target selector:(SEL)selector{
    return [self createBorderBtn:frame borderColor:nil bgColor:bgColor titleColor:titleColor title:title font:font target:target selector:selector];
}

+ (UIButton *)createBorderBtn:(CGRect)frame borderColor:(UIColor*)borderColor bgColor:(UIColor*)bgColor titleColor:(UIColor*)titleColor title:(NSString*)title font:(UIFont*)font target:(id)target selector:(SEL)selector{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setBackgroundColor:bgColor];
    btn.titleLabel.font = font;
    CALayer *layer = btn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 3;
    if(borderColor){
        layer.borderColor = borderColor.CGColor;
        layer.borderWidth = 0.5;
    }
    if (target) {
        [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

/**
 * @brief  创建指定格式的Label,高度会自动计算
 */
+ (UILabel *)createAttributedLabelWithFrame:(CGRect)frame str:(NSString*)str font:(UIFont*)font textColor:(UIColor*)textColor lineSpace:(CGFloat)lineSpace {
    return [xViewTools createAttributedLabelWithFrame:frame str:str font:font textColor:textColor lineSpace:lineSpace underline:NO];
}

/**
 * @brief  创建指定格式的Label,高度会自动计算
 */
+(UILabel *)createAttributedLabelWithFrame:(CGRect)frame str:(NSString *)str font:(UIFont *)font textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace underline:(BOOL)underline {
    //
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:str];
    //行间距
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    [pstyle setLineSpacing:lineSpace];
    [aString addAttribute:NSParagraphStyleAttributeName value:pstyle range:NSMakeRange(0, str.length)];
    //字体
    [aString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, str.length)];
    //文字颜色
    [aString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, str.length)];
    // 下划线
    if (underline) {
        [aString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, str.length)];
    }
    //求高度
    CGSize constrainedSize = CGSizeMake(frame.size.width, 9999);
    CGRect requiredRect = [aString boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, requiredRect.size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.attributedText = aString;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

/**
 *  @brief 创建label
 */
+ (UILabel *) createLabel:(NSString *)text
                    frame:(CGRect)frame
                alignment:(NSTextAlignment)align
                     font:(UIFont *)font
                textColor:(UIColor *)color
                     line:(int)line
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textAlignment = align;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    if (color) {
        label.textColor = color;
    }
    label.numberOfLines = line;
    return label;
}

@end
