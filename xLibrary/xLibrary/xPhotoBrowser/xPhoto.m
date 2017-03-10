

#import "xPhoto.h"

@implementation xPhoto

-(instancetype)initWithUrl:(NSURL*)url srcImageView:(UIImageView*)imageView{
    self = [super init];
    if(self){
        self.url = url;
        self.srcImageView = imageView;
    }
    return self;
}

- (void)setSrcImageView:(UIImageView *)srcImageView
{
    [self setSrcImage:srcImageView.image frameToWindow:[self getFrameToWindow:srcImageView] contentMode:srcImageView.contentMode clipsToBounds:srcImageView.clipsToBounds];
}

-(void)setSrcImage:(UIImage *)image frameToWindow:(CGRect)frame contentMode:(UIViewContentMode)contentMode clipsToBounds:(BOOL)clipsToBounds{
    _srcImageView = [[UIImageView alloc] init];
    _srcImageView.image = image;
    _srcImageView.frame = frame;
    _srcImageView.contentMode = contentMode;
    _srcImageView.clipsToBounds = clipsToBounds;
}

-(CGRect)getFrameToWindow:(UIImageView*)srcImageView{
    CGRect initFrame;
    if(srcImageView.superview){
        initFrame = [srcImageView convertRect:srcImageView.bounds toView:nil];
    }
    else{
        initFrame = CGRectMake(0.5f*([UIApplication sharedApplication].keyWindow.bounds.size.width - srcImageView.frame.size.width), 0.5f*([UIApplication sharedApplication].keyWindow.bounds.size.height - srcImageView.frame.size.height), srcImageView.frame.size.width, srcImageView.frame.size.height);
    }
    return initFrame;
}

@end
