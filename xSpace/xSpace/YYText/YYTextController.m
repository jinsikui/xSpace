//
//  YYTextController.m
//  xSpace
//
//  Created by JSK on 2018/4/26.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "YYTextController.h"
#import "YYText.h"
#import "xViewFactory.h"
#import "UIImageView+WebCache.h"

@interface YYTextController ()
@property(nonatomic) UIView *bar;
@property(nonatomic) YYLabel *beansLabel;
@property(nonatomic) YYLabel *dropsLabel;
@property(nonatomic) YYLabel *rechargeLabel;
@property(nonatomic) UIButton *payBtn;
@end

@implementation YYTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat maxWidth = 150;
    NSString *name = @"金小瞢萌二白肥猴宝狗小丢";
    int level = 2;
    YYLabel *label = [[YYLabel alloc] init];
    YYLabel *label2;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *attr2 = nil;
    [attr x_appendStr:@"欢迎 " foreColor:kColor(0xF5BD5E) font:kFontMediumPF(13)];
    if(level > 0){
        [attr x_appendImgWithUrl:[NSString stringWithFormat:@"https://sss.qingting.fm/pms/config/priv/lvic/lv%d@2x.png", level] size:CGSizeMake(23, 12) alignToFont:kFontMediumPF(13)];
        [attr x_appendStr:@" " foreColor:kColor(0xF5BD5E) font:kFontMediumPF(13)];
    }
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.layer.cornerRadius = 14;
    [imgv sd_setImageWithURL:[NSURL URLWithString:@"https://tva2.sinaimg.cn/crop.0.0.180.180.180/8c6ac5c5jw1e8qgp5bmzyj2050050aa8.jpg"]];
    imgv.frame = CGRectMake(0, 0, 28, 28);
    imgv.clipsToBounds = YES;
    [attr x_appendView:imgv alignToFont:kFontRegularPF(14)];
    [attr x_appendStr:name foreColor:kColor(0xFF5D65) font:kFontMediumPF(11) underline:NO baselineOffset:1];
    if([attr x_sizeWithMaxWidth:CGFLOAT_MAX].width > maxWidth){
        label.attributedText = attr;
        label.numberOfLines = 1;
        attr2 = [[NSMutableAttributedString alloc] init];
        [attr2 x_appendStr:@"来到本直播间！" foreColor:kColor(0xF5BD5E) font:kFontMediumPF(13)];
        label2 = [[YYLabel alloc] init];
        label2.attributedText = attr2;
    }
    else{
        [attr x_appendStr:@" 来到本直播间！" foreColor:kColor(0xF5BD5E) font:kFontMediumPF(13)];
        label.attributedText = attr;
        label.numberOfLines = 0;
    }
    CGSize textSize = CGSizeZero;
    CGSize textSize2 = CGSizeZero;
    CGSize panelSize;
    if(label2 != nil){
        textSize = CGSizeMake(maxWidth, 13);
        textSize2 = [attr2 x_sizeWithMaxWidth:CGFLOAT_MAX];
        panelSize = CGSizeMake(maxWidth + 16, 53);
    }
    else{
        textSize = [attr x_sizeWithMaxWidth:maxWidth];
        panelSize = CGSizeMake(textSize.width + 16, textSize.height + 22);
    }
    UIView *panel = [[UIView alloc] init];
    panel.backgroundColor = kColorA(0, 0.3);
    panel.layer.cornerRadius = 4;
    [self.view addSubview:panel];
    [panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.left.mas_equalTo(59);
        make.width.mas_equalTo(panelSize.width);
        make.height.mas_equalTo(panelSize.height);
    }];
    [panel addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(11);
        make.width.mas_equalTo(textSize.width);
        make.height.mas_equalTo(textSize.height);
    }];
    if(label2 != nil){
        [panel addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(27);
            make.width.mas_equalTo(textSize2.width);
            make.height.mas_equalTo(textSize2.height);
        }];
    }
    
    
    
    
    _bar = [[UIView alloc] init];
    _bar.backgroundColor = kColor(0x1E1E1E);
    [self.view addSubview:_bar];
    [_bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(200);
        make.height.mas_equalTo(35);
    }];
    _beansLabel = [[YYLabel alloc] init];
    NSMutableAttributedString *beanAttr = [[NSMutableAttributedString alloc] init];
    [beanAttr x_appendImgNamed:@"live-beans" alignToFont:kFontRegularPF(14)];
    [beanAttr x_appendStr:@" 110" foreColor:kColor(0xFFFFFF) font:kFontRegularPF(14)];
    CGSize beanSize = [beanAttr x_sizeWithMaxWidth:CGFLOAT_MAX];
    _beansLabel.attributedText = beanAttr;
    [_bar addSubview:_beansLabel];
    [_beansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(_bar);
        make.width.mas_equalTo(beanSize.width);
        make.height.mas_equalTo(beanSize.height);
    }];
    
    _dropsLabel = [[YYLabel alloc] init];
    NSMutableAttributedString *dropAttr = [[NSMutableAttributedString alloc] init];
    [dropAttr x_appendImgNamed:@"live-drops" alignToFont:kFontRegularPF(14)];
    [dropAttr x_appendStr:@" 400" foreColor:kColor(0xFFFFFF) font:kFontRegularPF(14)];
    CGSize dropSize = [dropAttr x_sizeWithMaxWidth:CGFLOAT_MAX];
    _dropsLabel.attributedText = dropAttr;
    [_bar addSubview:_dropsLabel];
    [_dropsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_beansLabel.mas_right).offset(15);
        make.centerY.equalTo(_bar);
        make.width.mas_equalTo(dropSize.width);
        make.height.mas_equalTo(dropSize.height);
    }];
    
    _rechargeLabel = [[YYLabel alloc] init];
    NSMutableAttributedString *rechargeAttr = [[NSMutableAttributedString alloc] init];
    [rechargeAttr x_appendStr:@"首充奖励 " foreColor:kColor(0xFFFFFF) font:kFontRegularPF(13)];
    [rechargeAttr x_appendImgNamed:@"live-r-arrow" alignToFont:kFontRegularPF(13)];
    CGSize rechargeSize = [rechargeAttr x_sizeWithMaxWidth:CGFLOAT_MAX];
    _rechargeLabel.attributedText = rechargeAttr;
    [_bar addSubview:_rechargeLabel];
    [_rechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dropsLabel.mas_right).offset(28);
        make.centerY.equalTo(_bar);
        make.width.mas_equalTo(rechargeSize.width);
        make.height.mas_equalTo(35);
    }];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionRecharge)];
    _rechargeLabel.userInteractionEnabled = YES;
    [_rechargeLabel addGestureRecognizer:g];
    
    _payBtn = [xViewFactory buttonWithTitle:@"赞赏" font:kFontRegularPF(15) titleColor:[xColor whiteColor] bgColor:kColor(0xCDCDCD) cornerRadius:4];
    [_payBtn addTarget:self action:@selector(actionPay) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:_payBtn];
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bar);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *lb = [[UILabel alloc] init];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = kFontRegularPF(14);
    lb.textColor = [xColor whiteColor];
    lb.text = @"abcd";
    lb.backgroundColor = [xColor blackColor];
    lb.layer.cornerRadius = 4;
    lb.clipsToBounds = YES;
    [self.view addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(300);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    UIView *box = [UIView new];
    box.backgroundColor = kColor(0xF7EEEE);
    [self.view addSubview:box];
    [box mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(400);
        make.height.mas_equalTo(31);
    }];
    NSString *desc = @"abc";//@"这家伙很懒，什么都没有留下~这家伙很懒，什么都没有留下~";
    YYLabel *briefLb = [[YYLabel alloc] init];
    briefLb.numberOfLines = 1;
    briefLb.lineBreakMode = NSLineBreakByTruncatingTail;
    attr = [[NSMutableAttributedString alloc] init];
    [attr x_appendStr:desc foreColor:kColor(0x666666) font:kFontRegularPF(13)];
    briefLb.attributedText = attr;
    [box addSubview:briefLb];
    [briefLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(box);
        make.height.mas_equalTo(13);
        make.width.mas_lessThanOrEqualTo(xDevice.screenWidth - 15*2 - 43*2);
    }];
}

-(void)actionPay{
    NSLog(@"===== actionPay =====");
}

-(void)actionRecharge{
    NSLog(@"===== actionRecharge =====");
}

@end
