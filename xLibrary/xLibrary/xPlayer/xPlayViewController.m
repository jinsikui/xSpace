

#import "xPlayViewController.h"
#import "xPlayerView.h"
@interface xPlayViewController ()<xPlayerViewProtocol>
@property(nonatomic,strong)xPlayerView *playView;
@property(nonatomic)BOOL isShowFull;
@end

@implementation xPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    xPlayerView *playView = [[xPlayerView alloc] initWithFrame:CGRectMake(0, 100, 320, 200)];
    //    playView.frame = ;
    playView.videoTitle = self.videoTitle;
    
    playView.videoUrl = self.videoUrl;
    [playView showInView:self.view];
    playView.delegate = self;
    _playView = playView;
    self.isShowFull = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

-(BOOL)shouldAutorotate {
    return NO;
}
-(BOOL)prefersStatusBarHidden {
    
    return self.isShowFull;
}

-(void)playerShowFullView:(xPlayerView *)player isFullView:(BOOL)isFull {
    self.isShowFull = isFull;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)playerBackViewPress:(xPlayerView *)player {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
