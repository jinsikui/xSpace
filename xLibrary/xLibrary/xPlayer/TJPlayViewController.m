//
//  TJPlayViewController.m
//  视频播放器
//
//  Created by 王亚军 on 2016/11/12.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "TJPlayViewController.h"
#import "TJPlayerView.h"
@interface TJPlayViewController ()<TJPlayerViewProtocol>
@property(nonatomic,strong)TJPlayerView *playView;
@property(nonatomic)BOOL isShowFull;
@end

@implementation TJPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TJPlayerView *playView = [[TJPlayerView alloc] initWithFrame:CGRectMake(0, 100, 320, 200)];
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

-(void)playerShowFullView:(TJPlayerView *)player isFullView:(BOOL)isFull {
    self.isShowFull = isFull;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)playerBackViewPress:(TJPlayerView *)player {
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
