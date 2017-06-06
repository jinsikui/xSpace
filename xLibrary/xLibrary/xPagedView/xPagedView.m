

#import "xPagedView.h"

@interface xPagedView()
{
    UIScrollView * scrollView_;
}

@end

@implementation xPagedView

-(instancetype)init{
    self = [super init];
    if(self){
    }
    return self;
}

-(void)setScrollView:(UIScrollView*)scrollView{
    [self addSubview:scrollView];
    scrollView_ = scrollView;
    scrollView_.delegate = self;
    scrollView_.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

-(UIScrollView*)scrollView{
    return scrollView_;
}

-(CGPoint)getEndOffsetWithCurOffset:(CGPoint)curOffset targetOffset:(CGPoint)scrollTarget scrollView:(UIScrollView*)scrollView{
    int curPage, endPage;
    CGPoint endOffset;
    if(_pageWidth > 0){
        //横向分页
        curPage = (int)roundf(curOffset.x / _pageWidth);
        endPage = (int)roundf(scrollTarget.x / _pageWidth);
        if(endPage > curPage + 1){
            endPage = curPage + 1;
        }
        if(endPage < curPage - 1){
            endPage = curPage - 1;
        }
        endOffset = CGPointMake(endPage * _pageWidth, 0);
        if(endOffset.x + scrollView.frame.size.width > scrollView.contentSize.width){
            endOffset.x = scrollView.contentSize.width - scrollView.frame.size.width;
        }
    }
    else{
        //纵向分页
        curPage = (int)roundf(curOffset.y / _pageHeight);
        endPage = (int)roundf(scrollTarget.y / _pageHeight);
        if(endPage > curPage + 1){
            endPage = curPage + 1;
        }
        if(endPage < curPage - 1){
            endPage = curPage - 1;
        }
        endOffset = CGPointMake(0, endPage * _pageHeight);
        if(endOffset.y + scrollView.frame.size.height > scrollView.contentSize.height){
            endOffset.y = scrollView.contentSize.height - scrollView.frame.size.height;
        }
    }
    return endOffset;
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint curOffset = scrollView.contentOffset;
    CGPoint endOffset = [self getEndOffsetWithCurOffset:curOffset targetOffset:*targetContentOffset scrollView:scrollView];
    *targetContentOffset = curOffset;
    [scrollView setContentOffset:endOffset animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}
@end
