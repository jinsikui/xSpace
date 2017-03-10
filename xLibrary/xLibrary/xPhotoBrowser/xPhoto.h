

#import <UIKit/UIKit.h>

@interface xPhoto : NSObject

-(instancetype)initWithUrl:(NSURL*)url srcImageView:(UIImageView*)imageView;

@property (nonatomic, strong) NSURL *url; //大图url
@property (nonatomic, strong) UIImage *image; //大图图片
@property (nonatomic, strong) NSString *photoTitle; //图片名称
@property (nonatomic, strong) NSString *photoDescription; //描述
@property (nonatomic, strong) UIImageView *srcImageView; //来源view
-(void)setSrcImage:(UIImage *)image frameToWindow:(CGRect)frame contentMode:(UIViewContentMode)contentMode clipsToBounds:(BOOL)clipsToBounds;//设置来源view
@property (nonatomic, assign) int index; //在图片列表中的索引
//控件内部使用
@property (nonatomic, assign) BOOL firstShow;

@end
