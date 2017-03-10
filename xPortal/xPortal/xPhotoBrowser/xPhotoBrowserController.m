

#import "xPhotoBrowserController.h"
#import "UIImageView+WebCache.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "xPhotoBrowser.h"
#import "xPhoto.h"

@interface xPhotoBrowserController (){
    NSArray *urls_;
    NSArray *largeUrls_;
    NSMutableArray *imageViewArr_;
}

@end

@implementation xPhotoBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    urls_ = @[
              @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=135716650,967930038&fm=116&gp=0.jpg",
              @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2385942857,2687549657&fm=116&gp=0.jpg",
              @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4035037412,3599812834&fm=116&gp=0.jpg",
              @"https://ss0.baidu.com/73x1bjeh1BF3odCf/it/u=795051745,368381399&fm=85&s=8BF87387C46236BE78E878980300C003",
              @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1205925227,832932870&fm=116&gp=0.jpg",
              @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1347095153,749953345&fm=116&gp=0.jpg",
              @"http://att3.citysbs.com/120x120/hangzhou/2013/12/23/11/690x919-115340_12561387770820780_d877f940b7a78e278e3de0030d60cc9e.jpg",
              @"https://ss0.baidu.com/73F1bjeh1BF3odCf/it/u=1648114020,1258045134&fm=85&s=1EBA6D858E5B5ADE4AAC75A10300F000",
              @"https://ss0.baidu.com/73x1bjeh1BF3odCf/it/u=2645918995,2344799336&fm=85&s=F23F30C4822B271D4A2C1D820300C098"];
    
    largeUrls_ = @[
                   @"http://c.hiphotos.baidu.com/zhidao/pic/item/caef76094b36acaf44edaab07fd98d1001e99c68.jpg",
                   @"http://a2.att.hudong.com/13/38/01300542493935139727386849910.jpg",
                   @"http://photo.l99.com/bigger/30/1390014500913_yd8w1h.png",
                   @"http://imgsrc.baidu.com/forum/w%3D580/sign=90aef079b33533faf5b6932698d2fdca/197a0f338744ebf8933a1d48dbf9d72a6059a71c.jpg",
                   @"http://upload.wuhan.net.cn/2013/1219/1387416145381.jpg",
                   @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1478056070&di=cdc1a052d3a1fb9e1aeb1734693da4f1&src=http://www.lieqijiemi.com/uploads/150516/1T02Ua1-0.jpg",
                   @"http://att2.citysbs.com/hangzhou/2013/12/23/11/middle_690x919-115340_12561387770820780_d877f940b7a78e278e3de0030d60cc9e.jpg",
                   @"http://www.haiwainet.cn/HLMediaFile/20140110/67/17410210089035083583.jpg",
                   @"http://imgsrc.baidu.com/forum/w%3D580/sign=8ef64919d30735fa91f04eb1ae500f9f/51946144ebf81a4c74e107cbd02a6059242da60d.jpg"];
    
    imageViewArr_ = [NSMutableArray arrayWithCapacity:urls_.count];
    
    //隐藏导航栏
    self.fd_prefersNavigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kColor_000000;
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentHeight)];
    [self.view addSubview:contentView];
    
    //创建9个UIImageView
    UIImage *placeholder = [UIImage imageNamed:@"default_small_image.png"];
    CGFloat width = 70;
    CGFloat height = 70;
    CGFloat margin = 20;
    CGFloat startX = (self.view.frame.size.width - 3 * width - 2 * margin) * 0.5;
    CGFloat startY = 120;
    for (int i = 0; i<9; i++) {
        //
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [contentView addSubview:imageView];
        [imageViewArr_ addObject:imageView];
        //
        int row = i/3;
        int column = i%3;
        CGFloat x = startX + column * (width + margin);
        CGFloat y = startY + row * (height + margin);
        imageView.frame = CGRectMake(x, y, width, height);
        //下载小图片
        [imageView sd_setImageWithURL:[NSURL URLWithString:urls_[i]] placeholderImage:placeholder options:SDWebImageLowPriority];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapImage:)]];
        
    }
}

- (void)actionTapImage:(UITapGestureRecognizer *)tap
{
    NSInteger count = largeUrls_.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        //大尺寸图片地址
        NSString *url = largeUrls_[i];
        xPhoto *photo = [[xPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = imageViewArr_[i];
        [photos addObject:photo];
    }
    xPhotoBrowser *browser = [[xPhotoBrowser alloc] init];
    browser.currentPhotoIndex = (int)tap.view.tag;
    browser.photos = photos;
    [browser show];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    //设为只支持正向，来演示图片浏览器旋转但源页面不旋转的效果
    return UIInterfaceOrientationMaskPortrait;
}

@end
