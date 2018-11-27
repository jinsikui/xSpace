//
//  LivePresent.h
//  QTTourAppStore
//
//  Created by JSK on 2018/4/26.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LivePresent : NSObject
@property(nonatomic) NSInteger Id;//1130 礼物Id
@property(nonatomic) NSInteger index;//5 礼物显示顺序
@property(nonatomic) NSString *name;//"蛋糕"
@property(nonatomic) NSInteger reward_type;//0普通礼物，1打折礼物，2活动
@property(nonatomic) NSInteger price;//100 金豆豆数
@property(nonatomic) double unit_price;//10 人民币数
@property(nonatomic) NSInteger drop_price;//20 水滴数，和金豆豆数不会同时>0
@property(nonatomic) NSDate *start_time;//"2017-11-10T07:25:00.000Z" 活动时间／打折时间／其他需要时间的时候
@property(nonatomic) NSDate *end_time;//"2018-05-31T07:25:00.000Z" 活动时间／打折时间／其他需要时间的时候
@property(nonatomic) NSString *img_url;//"http://sss.qingting.fm/pms/config/podcaster_reward/default2/4.png" 礼物图片
@property(nonatomic) NSString *animation_url;//"http://pic.qingting.fm/2017/0629/upload_a3aef2dcb88e691e85fd244f6289b02c.json" 礼物大动画文件，目前是图片序列的格式，是否要让后台变为矢量图格式？
@property(nonatomic) BOOL combo;//false 是否连击礼物
@property(nonatomic) NSArray<NSNumber*> *combo_plans;//null 连击方案
@property(nonatomic) NSInteger alias_id;//1014 原礼物Id（相对折扣礼物来说）
@property(nonatomic) LivePresent *alias;//原礼物
@property(nonatomic,weak) LivePresent *re_alias;//原礼物到本礼物的引用
/*
"alias":{
    "id":1014,
    "index":5,
    "name":"蛋糕",
    "reward_type":0,
    "price":200,
    "unit_price":20,
    "start_time":null,
    "end_time":null,
    "img_url":"http://sss.qingting.fm/pms/config/podcaster_reward/default2/4.png",
    "animation_url":"http://pic.qingting.fm/2017/0629/upload_a3aef2dcb88e691e85fd244f6289b02c.json",
    "combo":false,
    "combo_plans":null,
    "alias_id":null,
    "label_text":null,
    "reward_template_id":null,
    "priv":0
},
 */
@property(nonatomic) NSString *label_text;//"5折" 在右上角显示的文字，但如果账户剩余礼物有该礼物优先显示“x？”，然后如果是首充礼物右上自己拼“首充”，如果level>0礼物右上自己拼“lv.?”
@property(nonatomic) NSInteger level;//多少级别才可以送，返回可能不包含这个字段
@property(nonatomic) NSInteger reward_template_id;//null 叫api时可能需要传
@property(nonatomic) NSInteger priv;//0 特权说明，1首充

// view model property
@property(nonatomic) NSInteger accountRemains; //账户中该礼物的剩余个数
@property(nonatomic) BOOL isSelect;
@property(nonatomic) BOOL isLock;

-(instancetype)initWithDic:(NSDictionary*)dic;
//根据当前时间确定是返回本礼物还是本礼物的alias
-(LivePresent*)selfOrAlias;
@end
