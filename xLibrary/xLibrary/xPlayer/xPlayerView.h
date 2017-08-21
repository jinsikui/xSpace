

#import <UIKit/UIKit.h>

@protocol xPlayerViewProtocol;
@interface xPlayerView : UIView
@property(nonatomic,strong)NSString *videoUrl;
@property(nonatomic,strong)NSString *videoTitle;
@property(nonatomic,weak)id<xPlayerViewProtocol >delegate;

-(void)showInView:(UIView *)inView;
@end

@protocol xPlayerViewProtocol <NSObject>
@required
-(void)playerShowFullView:(xPlayerView *)player isFullView:(BOOL)isFull;
-(void)playerBackViewPress:(xPlayerView *)player;
@end
