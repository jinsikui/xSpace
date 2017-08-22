//
//  PhotoBannerController.m
//  xPortal
//
//  Created by JSK on 2017/8/22.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "PhotoBannerController.h"
#import "xPhotoBanner.h"
#import "xPhotoBannerData.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface PhotoBannerController ()

@end

@implementation PhotoBannerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    //
    xPhotoBanner *banner = [[xPhotoBanner alloc] initWithFrame:CGRectMake(0, 164, kScreenWidth, kScreenWidth * 3.0/4.0)];
    [self.view addSubview:banner];
    banner.placeholderImage = [UIImage imageNamed:@"empty_image.png"];
    NSArray *urls = @[
                      @"http://c.hiphotos.baidu.com/zhidao/pic/item/caef76094b36acaf44edaab07fd98d1001e99c68.jpg",
                      @"http://a2.att.hudong.com/13/38/01300542493935139727386849910.jpg",
                      @"http://photo.l99.com/bigger/30/1390014500913_yd8w1h.png",
                      @"http://imgsrc.baidu.com/forum/w%3D580/sign=90aef079b33533faf5b6932698d2fdca/197a0f338744ebf8933a1d48dbf9d72a6059a71c.jpg",
                      @"http://upload.wuhan.net.cn/2013/1219/1387416145381.jpg",
                      @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1478056070&di=cdc1a052d3a1fb9e1aeb1734693da4f1&src=http://www.lieqijiemi.com/uploads/150516/1T02Ua1-0.jpg",
                      @"http://att2.citysbs.com/hangzhou/2013/12/23/11/middle_690x919-115340_12561387770820780_d877f940b7a78e278e3de0030d60cc9e.jpg",
                      @"http://www.haiwainet.cn/HLMediaFile/20140110/67/17410210089035083583.jpg",
                      @"http://imgsrc.baidu.com/forum/w%3D580/sign=8ef64919d30735fa91f04eb1ae500f9f/51946144ebf81a4c74e107cbd02a6059242da60d.jpg"];

    NSMutableArray *photoDataList = [NSMutableArray arrayWithCapacity:urls.count];
    for(NSString *url in urls){
        xPhotoBannerData *data = [[xPhotoBannerData alloc] init];
        data.photoUrl = url;
        [photoDataList addObject:data];
    }
    banner.photoDataList = photoDataList;
    
}

@end
