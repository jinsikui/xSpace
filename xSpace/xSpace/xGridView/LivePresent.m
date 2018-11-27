//
//  LivePresent.m
//  QTTourAppStore
//
//  Created by JSK on 2018/4/26.
//  Copyright © 2018年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "LivePresent.h"
#import "LiveExtensions.h"

@implementation LivePresent

-(instancetype)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if(self){
        _Id = [dic[@"id"] integerValue];//1130 礼物Id
        _index = [dic[@"index"] integerValue];//5 礼物显示顺序
        _name = dic[@"name"];//"蛋糕"
        _reward_type = [dic[@"reward_type"] integerValue];//0普通礼物，1打折礼物，2活动
        _price = [dic[@"price"] integerValue];//100 金豆豆数
        _unit_price = [dic[@"unit_price"] doubleValue];//10 人民币数
        _drop_price = [dic[@"drop_price"] integerValue];//20 水滴数，和金豆豆数不会同时>0
        _start_time = [dic[@"start_time"] lv_toDate];//"2017-11-10T07:25:00.000Z" 活动时间／打折时间／其他需要时间的时候
        _end_time = [dic[@"end_time"] lv_toDate];//"2018-05-31T07:25:00.000Z" 活动时间／打折时间／其他需要时间的时候
        _img_url = dic[@"img_url"];//"http://sss.qingting.fm/pms/config/podcaster_reward/default2/4.png" 礼物图片
        _animation_url = dic[@"animation_url"];//"http://pic.qingting.fm/2017/0629/upload_a3aef2dcb88e691e85fd244f6289b02c.json" 礼物大动画文件，目前是图片序列的格式，是否要让后台变为矢量图格式？
        _combo = [dic[@"combo"] boolValue];//false 是否连击礼物
        _combo_plans = dic[@"combo_plans"];//null 连击方案
        _alias_id = [dic[@"alias_id"] integerValue];//1014 原礼物Id（相对折扣礼物来说）
        if(x_not_null(dic[@"alias"])){
            _alias = [[LivePresent alloc] initWithDic:dic[@"alias"]];//原礼物
            _alias.re_alias = self;
        }
        _label_text = dic[@"label_text"];//"5折" 在右上角显示的文字，但如果账户剩余礼物有该礼物优先显示“x？”，然后如果是首充礼物右上自己拼“首充”，如果level>0礼物右上自己拼“lv.?”
        _level = [dic[@"level"] integerValue];//多少级别才可以送，返回可能不包含这个字段
        _reward_template_id = [dic[@"reward_template_id"] integerValue];//null 叫api时可能需要传
        _priv = [dic[@"priv"] integerValue];//0 特权说明，1首充
    }
    return self;
}

-(LivePresent*)selfOrAlias{
    if(!self.alias){
        return self;
    }
    NSDate *now = [NSDate date];
    if((self.start_time && self.start_time > now) ||
       (self.end_time && self.end_time < now)){
        return self.alias;
    }
    else{
        return self;
    }
}

@end
