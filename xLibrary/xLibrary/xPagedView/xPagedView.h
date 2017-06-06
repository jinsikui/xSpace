

#import <UIKit/UIKit.h>

@interface xPagedView : UIView<UIScrollViewDelegate>
@property (nonatomic) CGFloat pageWidth;
@property (nonatomic) CGFloat pageHeight;
@property (nonatomic,weak)UIScrollView *scrollView;
@end
