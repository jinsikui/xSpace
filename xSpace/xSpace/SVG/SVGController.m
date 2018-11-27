//
//  SVGController.m
//  xSpace
//
//  Created by JSK on 2018/5/4.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "SVGController.h"
#import <Lottie/Lottie.h>
#import "xFile.h"
#import "FBLPromises.h"
#import "LiveConfig.h"

@interface SVGController ()
@property(nonatomic) xTimer *timer;
@property(nonatomic) NSDictionary *animation;
@property(nonatomic) UIImageView *imgv;
@property(nonatomic) NSInteger curImgIndex;
@end

@implementation SVGController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [xColor blackColor];
    
//    //任务：下载目前线上所有的礼物大动画的图片序列
//    NSDictionary *allAnimations = @{
//                                    @"1001":@"http://pic.qingting.fm/2017/0606/upload_d722b09dade7fda472afddb17562a11e.json",
//                                    @"1002":@"http://pic.qingting.fm/2017/0724/upload_a3aef2dcb88e691e85fd244f6289b02c.json",
//                                    @"1003":@"http://pic.qingting.fm/2017/0724/upload_5d5c25940583517ae3bb073b4d0189a5.json",
//                                    @"1005":@"http://pic.qingting.fm/2017/0724/upload_ddc07dc8014ebe6e056541b1e292551c.json",
//                                    @"1009":@"http://pic.qingting.fm/2017/0706/upload_25bb48a7fbf147b732d15c279fe4af6d.json",
//                                    @"1012":@"http://pic.qingting.fm/2017/0706/upload_a3aef2dcb88e691e85fd244f6289b02c.json",
//                                    @"1014":@"http://pic.qingting.fm/2017/0629/upload_a3aef2dcb88e691e85fd244f6289b02c.json",
//                                    @"1068":@"http://pic.qingting.fm/2017/0706/upload_15206c441237cd14ac0a7952fe256246.json",
//                                    @"1069":@"http://pic.qingting.fm/2017/0704/upload_25bb48a7fbf147b732d15c279fe4af6d.json",
//                                    @"1072":@"http://pic.qingting.fm/2017/0622/upload_3edc7baf2a5b53f455d2414ef93047de.json",
//                                    @"1073":@"http://pic.qingting.fm/2017/0622/upload_c9544fe2348ea48c27d85e1a2aef81a7.json",
//                                    @"1077":@"http://pic.qingting.fm/2017/0706/upload_15206c441237cd14ac0a7952fe256246.json",
//                                    @"1078":@"http://pic.qingting.fm/2017/0706/upload_e81b6cb5784124daa972ddfe87a334dc.json",
//                                    @"1079":@"http://pic.qingting.fm/2017/0707/upload_836a2e94874ff0fc64bcc7849c98b52d.json",
//                                    @"1080":@"http://pic.qingting.fm/2017/0707/upload_3696b1d0503a1acf773d9fc773230be2.json",
//                                    @"1081":@"http://pic.qingting.fm/2017/0706/upload_496dca2c65b3ea2279de0fbdc9780f07.json",
//                                    @"1082":@"http://pic.qingting.fm/2017/0706/upload_5fdc953cb88f574fccfcea8f5e94bc48.json",
//                                    @"1083":@"http://pic.qingting.fm/2017/0706/upload_96732c9e05986b9ea0a13445d778ffb4.json",
//                                    @"1084":@"http://pic.qingting.fm/2017/0707/upload_a80a5fc5ff799da5463c0bfa5f1a7acc.json",
//                                    @"1085":@"http://pic.qingting.fm/2017/0706/upload_78c71c71f7125f88441845aafee6cb70.json",
//                                    @"1086":@"http://pic.qingting.fm/2017/0706/upload_6553045b2a198a85b48e798c07f3ef2e.json",
//                                    @"1087":@"http://pic.qingting.fm/2017/0707/upload_9345769f8b4023528e906a2e8899e5e0.json",
//                                    @"1088":@"http://pic.qingting.fm/2017/0706/upload_932500e986c7495e0383bb8e84e118ff.json",
//                                    @"1110":@"http://pic.qingting.fm/2017/0821/upload_faf121c28baa3cb371e416df28c25a6c.json",
//                                    @"1111":@"http://pic.qingting.fm/2017/0821/upload_df014324ff97f9a5250185378bacd4d4.json",
//                                    @"1123":@"http://pic.qingting.fm/2017/0915/upload_7be9d60d9b9c3462c9cc0164ddcbd22d.json",
//                                    @"1124":@"http://pic.qingting.fm/2017/0915/upload_0ec45288c67fb67022058242a50d6de9.json",
//                                    @"1125":@"http://pic.qingting.fm/2017/1016/upload_29fb072285e040a8aec421dcbb91657a.json",
//                                    @"1126":@"http://pic.qingting.fm/2017/1016/upload_06c3a49cbda92aee3fec07a2f5133925.json",
//                                    @"1129":@"http://pic.qingting.fm/2017/0706/upload_a3aef2dcb88e691e85fd244f6289b02c.json",
//                                    @"1130":@"http://pic.qingting.fm/2017/0629/upload_a3aef2dcb88e691e85fd244f6289b02c.json",
//                                    @"1149":@"http://pic.qingting.fm/2017/0706/upload_78c71c71f7125f88441845aafee6cb70.json",
//                                    @"1150":@"http://pic.qingting.fm/2017/0706/upload_78c71c71f7125f88441845aafee6cb70.json",
//                                    };
//    NSMutableArray *pArr = [NSMutableArray new];
//    for(NSString *rwdId in allAnimations.allKeys){
//        FBLPromise *p = [[LiveConfig shared] loadRewardAnimation:allAnimations[rwdId] for:[rwdId integerValue]];
//        p.then(^id(id ret){
//            NSLog(@"===== reward %@ downloaded =====", rwdId);
//            return nil;
//        })
//        .catch(^(NSError *error){
//            NSLog(@"===== download reward %@ failed =====", rwdId);
//        });
//        [pArr addObject:p];
//    }
//    FBLPromise.any(pArr).then(^id(NSArray *arr){
//        NSLog(@"===== all animations downloaded =====");
//        return nil;
//    });
    
    
    //测试1，下载动画文件解析并显示完整动画
    _imgv = [[UIImageView alloc] init];
    _imgv.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imgv];
    __weak typeof(self) weak = self;
    //豪华游艇url
    NSString *aniUrl = @"http://pic.qingting.fm/2017/0716/upload_932500e986c7495e0383bb8e84e118ff.json";
    [[LiveConfig shared] loadRewardAnimation:aniUrl for:1000].then(^id(NSDictionary *animation){
        weak.animation = animation;
        double duration = [animation[@"op"] doubleValue]/[animation[@"fr"] doubleValue];
        double interval = duration / ((NSArray*)animation[@"assets"]).count;
        weak.curImgIndex = 0;
        weak.timer = [xTimer timerOnMainWithIntervalSeconds:interval fireOnStart:YES action:^{
            NSDictionary *assetDic = weak.animation[@"assets"][weak.curImgIndex];
            NSString *imgPath = [[LiveConfig shared].rewardAnimationFolderPath stringByAppendingPathComponent:assetDic[@"p"]];
            UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgPath];
            CGFloat imgW = (CGFloat)[assetDic[@"w"] floatValue];
            CGFloat imgH = (CGFloat)[assetDic[@"h"] floatValue];
            [weak.imgv mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(weak.view);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(imgH * xDevice.screenWidth / imgW);
            }];
            weak.imgv.image = img;
            weak.curImgIndex += 1;
            if(weak.curImgIndex == [weak.animation[@"assets"] count] - 1){
                [weak.timer stop];
            }
        }];
        [weak.timer start];
        return nil;
    });
    
    
//    //测试2，显示本地动画文件的第一帧
//    NSData *dicData = [xFile getDataFromFileOfPath:[xFile bundlePath:@"yangzheng.json"]];
//    NSDictionary *jsonDic = [xFile jsonDataToObject:dicData];
//    NSString *rawStr = jsonDic[@"assets"][1][@"p"];
//    NSString *base64Preffix = @"data:image/png;base64,";
//    NSString *base64 = [rawStr substringFromIndex:base64Preffix.length];
//    NSData *imgData = [xFile base64ToData:base64];
//    UIImage *image = [UIImage imageWithData:imgData];
//    UIImageView *imgv = [[UIImageView alloc] initWithImage:image];
//    imgv.contentMode = UIViewContentModeScaleAspectFill;
//    imgv.frame = CGRectMake(100, 100, 200, 200);
//    [self.view addSubview:imgv];
    
    
//    //测试3，用控件显示格式良好的动画文件
//    NSDictionary *ani2 = [xFile jsonDataToObject: [xFile getDataFromFileOfPath:[xFile bundlePath:@"入场动画.json"]]];
//    LOTComposition *comp = [LOTComposition animationFromJSON:ani2 inBundle:[NSBundle mainBundle]];
//    comp.rootDirectory = [LiveConfig shared].rewardAnimationFolderPath;
//    LOTAnimationView *a1 = [[LOTAnimationView alloc] initWithModel:comp inBundle:[NSBundle mainBundle]];
//    a1.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view addSubview:a1];
//    [a1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(50);
//        make.top.mas_equalTo(100);
//        make.width.height.mas_equalTo(200);
//    }];
//    [a1 playWithCompletion:^(BOOL animationFinished) {
//
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
