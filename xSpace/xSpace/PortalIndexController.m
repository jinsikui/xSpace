

#import "PortalIndexController.h"
#import "xPhotoBrowserController.h"
#import "AutoLayoutController.h"
#import "OCController.h"
#import "PortalNavigationController.h"
#import "EventController.h"
#import "CoreDataController.h"
#import "RefreshController.h"
#import "FMDBController.h"
#import "InterAppController.h"
#import "WVJBController.h"
#import "UIImageView+WebCache.h"
#import "PagedController.h"
#import "BannerLoadingController.h"
#import "RuntimeController.h"
#import "PhotoBannerController.h"
#import "UITestController.h"
#import "KVOTestController.h"
#import "AudienceController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "BeaconAPI.h"
#import "MyDelegate.h"
#import "LogDelegate.h"
#import "BlurViewController.h"
#import "CThreadController.h"
#import "xTaskController.h"
#import "PromisesController.h"
#import "xBannerController.h"
#import "YYTextController.h"
#import "xGridViewController.h"
#import "SVGController.h"
#import "SingletonController.h"
#import "SingletonManager.h"
#import "RetryController.h"
#import "AudioController.h"
#import "SliderController.h"
#import "GradientController.h"
#import "AnimationsController.h"
#import "VoiceViewController.h"
#import "CollectionViewController.h"
#import "SVGAController.h"
#import "AudioToolController.h"

@interface PortalIndexController ()
@property(nonatomic,strong)UIView *affineShowingPanel;
@property(nonatomic,strong)UIScrollView *contentView;

@property(nonatomic,strong)NSPointerArray *delegates;
@property(nonatomic,strong)MyDelegate *myDelegate1;
@property(nonatomic,strong)MyDelegate *myDelegate2;
@property(nonatomic,strong)MyDelegate *myDelegate3;
@end

@implementation PortalIndexController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = kColor(0xFFFFFF);
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentHeight)];
    contentView.alwaysBounceVertical = YES;
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    [self createBtn:@"图片浏览" y:30 selector:@selector(actionShowPhotoBrowser)];
    [self createBtn:@"AutoLayout" y:90 selector:@selector(actionShowAutoLayout)];
    [self createBtn:@"OC语法" y:150 selector:@selector(actionShowOC)];
    [self createBtn:@"事件处理" y:210 selector:@selector(actionShowEvent)];
    [self createBtn:@"CoreData" y:270 selector:@selector(actionShowCoreData)];
    [self createBtn:@"FMDB" y:330 selector:@selector(actionFMDB)];
    [self createBtn:@"下拉刷新" y:390 selector:@selector(actionRefresh)];
    [self createBtn:@"其他App交互" y:450 selector:@selector(actionInterApp)];
    [self createBtn:@"JSBridge" y:510 selector:@selector(actionJSBridge)];
    [self createBtn:@"分页" y:570 selector:@selector(actionPaged)];
    [self createBtn:@"Banner loading" y:630 selector:@selector(actionBannerLoading)];
    [self createBtn:@"runtime" y:690 selector:@selector(actionRuntime)];
    [self createBtn:@"affine showing" y:750 selector:@selector(actionAffineShowing)];
    [self createBtn:@"图片Banner" y:810 selector:@selector(actionPhotoBanner)];
    [self createBtn:@"播放http视频" y:870 selector:@selector(actionPlay)];
    [self createBtn:@"Network" y:930 selector:@selector(actionNetwork)];
    [self createBtn:@"UITest" y:990 selector:@selector(actionUITest)];
    [self createBtn:@"KVO" y:1050 selector:@selector(actionKVO)];
    [self createBtn:@"Agora Audience" y:1110 selector:@selector(actionAudience)];
    [self createBtn:@"AFNetworking" y:1170 selector:@selector(actionAFNetworking)];
    [self createBtn:@"NSPointerArray" y:1230 selector:@selector(actionPointerArray)];
    [self createBtn:@"BlurView" y:1290 selector:@selector(actionBlurView)];
    [self createBtn:@"c thread" y:1350 selector:@selector(actionCThread)];
    [self createBtn:@"xTask" y:1410 selector:@selector(actionxTask)];
    [self createBtn:@"Date & Calendar" y:1470 selector:@selector(actionDate)];
    [self createBtn:@"导航" y:1530 selector:@selector(actionNavigation)];
    [self createBtn:@"Promises" y:1590 selector:@selector(actionPromises)];
    [self createBtn:@"xBanner" y:1650 selector:@selector(actionXBanner)];
    [self createBtn:@"YYText" y:1710 selector:@selector(actionYYText)];
    [self createBtn:@"xGridView" y:1770 selector:@selector(actionXGridView)];
    [self createBtn:@"SVG Animation" y:1830 selector:@selector(actionSVG)];
    [self createBtn:@"Singleton VC" y:1890 selector:@selector(actionControllerSingle)];
    [self createBtn:@"Retry Logic" y:1950 selector:@selector(actionRetry)];
    [self createBtn:@"Audio" y:2010 selector:@selector(actionAudio)];
    [self createBtn:@"Slider" y:2070 selector:@selector(actionSlider)];
    [self createBtn:@"gradient" y:2130 selector:@selector(actionGradient)];
    [self createBtn:@"Animations" y:2190 selector:@selector(actionAnimations)];
    [self createBtn:@"正则表达式" y:2250 selector:@selector(actionRegularEx)];
    [self createBtn:@"xVoiceView" y:2310 selector:@selector(actionVoiceView)];
    [self createBtn:@"CollectionView" y:2370 selector:@selector(actionCollectionView)];
    [self createBtn:@"SVGA" y:2430 selector:@selector(actionSVGA)];
    [self createBtn:@"Audio Tool" y:2490 selector:@selector(actionAudioTool)];
    contentView.contentSize = CGSizeMake(kScreenWidth, 2590);
}

-(void)actionAudioTool{
    [self.navigationController pushViewController:[[AudioToolController alloc] init] animated:YES];
}

-(void)actionSVGA{
    [self.navigationController pushViewController:[[SVGAController alloc] init] animated:YES];
}

-(void)actionCollectionView{
    [self.navigationController pushViewController:[[CollectionViewController alloc] init] animated:YES];
}

-(void)actionVoiceView{
    [self.navigationController pushViewController:[[VoiceViewController alloc] init] animated:YES];
}

-(void)actionRegularEx{
    NSString *template = @"曾经有一个{user}站在{podcaster}的面前";
    NSString *patten = @"(\\{user\\})|(\\{podcaster\\})|(\\{room\\})|(\\{reward\\})";
    NSInteger start = 0;
    NSMutableAttributedString *attr = [NSMutableAttributedString new];
    NSRange find;
    do{
        find = [template rangeOfString:patten options:NSRegularExpressionSearch range:NSMakeRange(start, template.length - start)];
        if(find.location != NSNotFound){
            //找到patten
            if(find.location > start){
                //添加patten前方文字
                [attr x_appendStr:[template substringWithRange:NSMakeRange(start, find.location - start)] foreColor:kColor(0x333333) font:kFontRegularPF(13)];
                [attr x_appendStr:@" " foreColor:kColor(0x333333) font:kFontRegularPF(13)];
            }
            //添加patten对应内容
            NSString *findPatten = [template substringWithRange:find];
            if([findPatten isEqualToString:@"{user}"]){
                [attr x_appendStr:@"狗小丢" foreColor:kColor(0xFD5253) font:kFontRegularPF(13)];
            }
            else if([findPatten isEqualToString:@"{podcaster}"]){
                [attr x_appendStr:@"金小懵" foreColor:kColor(0xFD5253) font:kFontRegularPF(13)];
            }
            else if([findPatten isEqualToString:@"{reward}"]){
                [attr x_appendStr:@"小礼物" foreColor:kColor(0xFD5253) font:kFontRegularPF(13)];
            }
            if(find.location + find.length < template.length){
                [attr x_appendStr:@" " foreColor:kColor(0x333333) font:kFontRegularPF(13)];
            }
            //移动下次查找起始位置
            start = find.location + find.length;
        }
        else{
            //未找到patten，添加末尾文字
            [attr x_appendStr:[template substringWithRange:NSMakeRange(start, template.length - start)] foreColor:kColor(0x333333) font:kFontRegularPF(13)];
            break;
        }
    }while(start < template.length);
    NSLog(@"%@", attr.string);
}

-(void)actionAnimations{
    [self.navigationController pushViewController:[[AnimationsController alloc] init] animated:YES];
}

-(void)actionGradient{
    [self.navigationController pushViewController:[[GradientController alloc] init] animated:YES];
}

-(void)actionSlider{
    [self.navigationController pushViewController:[[SliderController alloc] init] animated:YES];
}

-(void)actionAudio{
    [self.navigationController pushViewController:[[AudioController alloc] init] animated:YES];
}

-(void)actionRetry{
    [self.navigationController pushViewController:[[RetryController alloc] init] animated:YES];
}

-(void)actionControllerSingle{
    [self.navigationController pushViewController:[[SingletonController alloc] init] animated:YES];
    [self.navigationController pushViewController:[[SVGController alloc] init] animated:YES];
    [self.navigationController pushViewController:[[YYTextController alloc] init] animated:YES];
    [xTask asyncMainAfter:1 task:^{
        [SingletonManager showAndUpdateSingleton];
        [xTask asyncMainAfter:3 task:^{
            [SingletonManager showAndUpdateSingleton];
        }];
    }];
    
}

-(void)actionSVG{
    [self.navigationController pushViewController:[[SVGController alloc] init] animated:YES];
}

-(void)actionXGridView{
    [self.navigationController pushViewController:[[xGridViewController alloc] init] animated:YES];
}

-(void)actionYYText{
    [self.navigationController pushViewController:[[YYTextController alloc] init] animated:YES];
}

-(void)actionXBanner{
    [self.navigationController pushViewController:[[xBannerController alloc] init] animated:YES];
}

-(void)actionPromises{
    [self.navigationController pushViewController:[[PromisesController alloc] init] animated:YES];
}

-(void)actionNavigation{
    [self.navigationController pushViewController:[[PagedController alloc] init] animated:YES];
    __weak typeof(self) weak = self;
    [xTask asyncMainAfter:5 task:^{
        [weak.navigationController popViewControllerAnimated:NO];
        [weak.navigationController pushViewController:[[RefreshController alloc] init] animated:NO];
    }];
}

-(void)actionDate{
    NSString *str = @"2018-04-03T03:15:34.001Z";
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSDate *date = [f dateFromString:str];
    NSDate *date2 = [f dateFromString:@""];
    NSLog(@"===== %@, %@ =====", date, date2);
}

-(void)actionxTask{
    [self.navigationController pushViewController:[[xTaskController alloc] init] animated:YES];
}

-(void)actionCThread{
    [self.navigationController pushViewController:[[CThreadController alloc] init] animated:YES];
}

-(void)actionBlurView{
    [self.navigationController pushViewController:[[BlurViewController alloc] init] animated:YES];
}

-(void)actionPointerArray{
    _delegates = [NSPointerArray weakObjectsPointerArray];
    self.myDelegate1 = [[MyDelegate alloc] initWithNum:1];
    [self addDelegate:_myDelegate1];
    self.myDelegate2 = [[MyDelegate alloc] initWithNum:2];
    [self addDelegate:_myDelegate2];
    self.myDelegate3 = [[MyDelegate alloc] initWithNum:3];
    [self addDelegate:_myDelegate3];
    
    __weak typeof(self) weak = self;
    [xTask asyncMainAfter:3 task:^{
        weak.myDelegate1 = nil;
        weak.myDelegate3 = nil;
    }];
    [xTask asyncMainAfter:6 task:^{
        [weak executeDelegates];
        [weak executeDelegates];
    }];
}

-(void)executeDelegates{
    NSLog(@"===== delegates.count: %lu =====", (unsigned long)self.delegates.count);
    NSMutableArray *nilIndexArr = [NSMutableArray array];
    for(NSInteger i=0; i<self.delegates.count; i++){
        id<LogDelegate> log = [self.delegates pointerAtIndex:i];
        if(log == nil){
            [nilIndexArr addObject:@(i)];
        }
        else{
            [log log:@"hello world"];
        }
    }
    for(NSInteger j = nilIndexArr.count -1; j>=0; j--){
        NSInteger index = [nilIndexArr[j] integerValue];
        [self.delegates removePointerAtIndex:index];
    }
}

- (void)addDelegate:(id<LogDelegate>)delegate
{
    if([[_delegates allObjects] containsObject:delegate]){
        return;
    }
    [_delegates addPointer:(__bridge void * _Nullable)(delegate)];
}

- (void)removeDelegate:(id<LogDelegate>)delegate
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray: [_delegates allObjects]];
    if([arr containsObject:delegate]){
        [arr removeObject:delegate];
        NSPointerArray *pArr = [NSPointerArray weakObjectsPointerArray];
        for(id<LogDelegate> obj in arr){
            [pArr addPointer:(__bridge void * _Nullable)(obj)];
        }
        _delegates = pArr;
    }
}

-(void)actionAFNetworking{
    [BeaconAPI send:@"test" event:@"hello" params:@{@"id":@(123)} commonParams:@{@"a":@"0",@"b":@"1"}];
}

-(void)actionAudience{
    [self.navigationController pushViewController:[[AudienceController alloc] init] animated:YES];
}

-(void)actionKVO{
    [self.navigationController pushViewController:[[KVOTestController alloc] init] animated:YES];
}

-(void)actionUITest{
    [self.navigationController pushViewController:[[UITestController alloc] init] animated:YES];
}

-(void)actionNetwork{
}

-(void)actionPlay{
    NSURL *url = [NSURL URLWithString:@"http://devimages.apple.com.edgekey.net/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8"];
    AVPlayer *player = [AVPlayer playerWithURL:url];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    controller.player = player;
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

-(void)actionPhotoBanner{
    [self.navigationController pushViewController:[[PhotoBannerController alloc] init] animated:YES];
}

-(void)actionAffineShowing{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIColor *windowColor = window.backgroundColor;
    window.backgroundColor = [UIColor blackColor];
    
    UIView *rootView = window.rootViewController.view;
    _affineShowingPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth, kScreenHeight)];
    UIButton *btn = [xViewFactory buttonWithTitle:@"返回" font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 100), 150, 100, 40)];
    [_affineShowingPanel addSubview:btn];
    _affineShowingPanel.backgroundColor = kColor(0xFD8238);
    [window addSubview:_affineShowingPanel];
    NSLog(@"===== rootView size before affine:(%f,%f) =====",rootView.frame.size.width, rootView.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        _affineShowingPanel.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        rootView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        NSLog(@"===== rootView size after affine:(%f,%f) =====",rootView.frame.size.width, rootView.frame.size.height);
        rootView.transform = CGAffineTransformMakeScale(1, 1);
        window.backgroundColor = windowColor;
    }];
}

-(void)actionBackFromAffineShowing{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIColor *windowColor = window.backgroundColor;
    window.backgroundColor = [UIColor blackColor];
    
    UIView *rootView = window.rootViewController.view;
    rootView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    [UIView animateWithDuration:0.3 animations:^{
        _affineShowingPanel.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        rootView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [_affineShowingPanel removeFromSuperview];
        window.backgroundColor = windowColor;
    }];
}

-(void)actionRuntime{
    [self.navigationController pushViewController:[[RuntimeController alloc] init] animated:YES];
}

-(void)actionBannerLoading{
    [self.navigationController pushViewController:[[BannerLoadingController alloc] init] animated:YES];
}

-(void)actionPaged{
    [self.navigationController pushViewController:[[PagedController alloc] init] animated:YES];
}

-(void)actionJSBridge{
    [self.navigationController pushViewController:[[WVJBController alloc] init] animated:YES];
}

-(void)actionInterApp{
    [self.navigationController pushViewController:[[InterAppController alloc] init] animated:YES];
}

-(void)actionFMDB{
    [self.navigationController pushViewController:[[FMDBController alloc] init] animated:YES];
}

-(void)actionRefresh{
    [self.navigationController pushViewController:[[RefreshController alloc] init] animated:YES];
}

-(void)actionShowCoreData{
    [self.navigationController pushViewController:[[CoreDataController alloc] init] animated:YES];
}

-(void)actionShowPhotoBrowser{
    [self.navigationController pushViewController:[[xPhotoBrowserController alloc] init] animated:YES];
}

-(void)actionShowAutoLayout{
    [self.navigationController pushViewController:[[AutoLayoutController alloc] init] animated:YES];
}

-(void)actionShowOC{
    [self.navigationController pushViewController:[[OCController alloc] init] animated:YES];
}

-(void)actionShowEvent{
    [self.navigationController pushViewController:[[EventController alloc] init] animated:YES];
}

-(void)createBtn:(NSString*)title y:(CGFloat)y selector:(SEL)selector{
    UIButton *btn = [xViewFactory buttonWithTitle:title font:kFontPF(14) titleColor:kColor(0xFF6600) bgColor:kColor(0xFFFFFF) cornerRadius:0 borderColor:kColor(0xFF6600) borderWidth:0.5 frame:CGRectMake(0.5*(kContentWidth - 120), y, 120, 40)];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
