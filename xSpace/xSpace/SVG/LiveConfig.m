//
//  LiveConfig.m
//  QTTourAppStore
//
//  Created by JSK on 2018/4/9.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "LiveConfig.h"
#import "xFile.h"
#import "AFNetworking.h"
#import "LiveError.h"

@interface LiveConfig()

@property(nonatomic) NSString *levelColorFileName;
@property(nonatomic) NSString *hostinAgreementFileName;
@property(nonatomic) NSString *followShowTimeFileName;

@end

@implementation LiveConfig

+(LiveConfig*)shared{
    static LiveConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LiveConfig alloc] init];
    });
    return instance;
}

-(instancetype)init{
    self = [super init];
    if(self){
        _maxSendMessageLength = 100;
        _defaultRedPacketMessage = @"恭喜发财，大吉大利！";
        _levelColorFileName = @"liveLevelColors";
        _hostinAgreementFileName = @"hostinAgreement";
        _followShowTimeFileName = @"followShowTime";
        _msgPlaceholder = @"说点什么吧！";
        _hostinPolicy = @"您承诺在连麦过程中严格遵守法律法规政策规定，不传播任何禁止性内容，不侵害他人合法权益；恪守公序良俗，不出现侮辱、诽谤、谩骂、攻击、挑逗、威胁、骚扰等行为；严格遵守蜻蜓平台规则，不宣传推广任何第三方商品及服务，不侵害平台权益或妨碍平台正常运营。您有任何违反上述承诺之行为的，将被禁用连麦功能，并需承担相应法律责任。";
        _applyHostinPlacehoder = @"填写你想提问的问题，增加大咖接通的概率哦！";
        _maxApplyHostinMsgLength = 30;
        _rewardAnimationFolderPath = [xFile documentPath:@"rewardAnimations"];
    }
    return self;
}

-(NSMutableDictionary*)getRewardAnimationConfigFor:(NSInteger)rewardId{
    return (NSMutableDictionary*)[xFile getDicFromFileOfPath:[NSString stringWithFormat:@"%@/%ld/config", self.rewardAnimationFolderPath, (long)rewardId]];
}

-(FBLPromise<NSDictionary*>*)loadRewardAnimation:(NSString*)animationUrl for:(NSInteger)rewardId{
    __weak typeof(self) weak = self;
    //创建目录
    NSString *folderPath = [NSString stringWithFormat:@"%@/%ld", weak.rewardAnimationFolderPath, (long)rewardId];
    [xFile createFolder:folderPath];
    
    FBLPromise *promise = FBLPromise.asyncOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(FBLPromiseFulfillBlock fulfill,
                                                                                                              FBLPromiseRejectBlock reject) {
        //下载配置文件并保存
        //方式1，用downloadTask
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *URL = [NSURL URLWithString:animationUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
        {
            //原始json文件保存地址
            return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%ld/rawConfig.json", weak.rewardAnimationFolderPath, (long)rewardId]];
        }
        completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
        {
            if(error){
                reject(error);
            }
            else{
                fulfill([NSData dataWithContentsOfURL:filePath]);
            }
        }];
        [downloadTask resume];
        
//        //方式2，用dataTask
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//        NSURL *URL = [NSURL URLWithString:animationUrl];
//        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//            if (error) {
//                reject(error);
//            } else {
//                NSLog(@"===== %@: %@ =====", [responseObject class], responseObject);
//                fulfill(responseObject);
//            }
//        }];
//        [dataTask resume];
        
        
//        //方式3，从本地文件读取
//        NSData *data = [xFile getDataFromFileOfPath:[xFile bundlePath:@"yangzheng.json"]];
//        fulfill(data);
        
        
    }).thenOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^id(NSData *data){
        //将配置文件中的base64转化为文件
        NSMutableDictionary *dic = [xFile jsonDataToObject:data];
        NSMutableArray *arr = dic[@"assets"];
        NSArray<FBLPromise<NSMutableDictionary*>*> *promiseArr = [arr mapWithIndex:^id(id item, NSInteger index) {
            NSMutableDictionary *imgDic = (NSMutableDictionary*)item;
            FBLPromise *promise = FBLPromise.asyncOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(FBLPromiseFulfillBlock fulfill,
                                                                                                                      FBLPromiseRejectBlock reject) {
                NSString *rawStr = imgDic[@"p"];
                NSString *base64Preffix = @"data:image/png;base64,";
                NSString *base64 = [rawStr substringFromIndex:base64Preffix.length];
                NSData *imgData = [xFile base64ToData:base64];
                //每帧图片保存地址
                //使用index命名图片帧
                NSString *imgPath = [NSString stringWithFormat:@"%@/%ld/%ld.png", weak.rewardAnimationFolderPath, (long)rewardId, (long)index];
                //使用json中的id字段命名图片帧
                //NSString *imgPath = [NSString stringWithFormat:@"%@/%ld/%@", weak.rewardAnimationFolderPath, (long)rewardId, imgDic[@"id"]];
                if([xFile saveData:imgData toPath:imgPath]){
                    //替换原来的p字段为保存的图片帧地址（=rewardAnimationFolderPath后面的部分）
                    imgDic[@"p"] = [NSString stringWithFormat:@"%ld/%ld.png", (long)rewardId, (long)index];
                    //imgDic[@"p"] = [NSString stringWithFormat:@"%ld/%@", (long)rewardId, imgDic[@"id"]];
                    fulfill(imgDic);
                }
                else{
                    reject([LiveError errorWithCode:-1 msg:@"保存动画图片失败"]);
                }
            });
            return promise;
        }];
        return FBLPromise.allOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), promiseArr).
            thenOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^id(NSArray<NSDictionary*> *arr){
                //保存新的配置文件，并返回给上层调用
                NSString *filePath = [NSString stringWithFormat:@"%@/%ld/config", weak.rewardAnimationFolderPath, (long)rewardId];
                if([xFile saveDic:dic toPath:filePath]){
                    return dic;
                }
                else{
                    return [LiveError errorWithCode:-1 msg:@"保存转化后的配置文件失败"];
                }
            });
    });
    return promise;
}

@end
