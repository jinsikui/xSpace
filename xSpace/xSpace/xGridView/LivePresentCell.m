//
//  LivePresentCell.m
//  xSpace
//
//  Created by JSK on 2018/4/28.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "LivePresentCell.h"
#import "YYText.h"
#import "UIImageView+WebCache.h"

@interface LivePresentCell()
@property(nonatomic) UILabel *leftLabel;
@property(nonatomic) UILabel *rightLabel;
@property(nonatomic) UIImageView *imgView;
@property(nonatomic) YYLabel *nameLabel;
@property(nonatomic) YYLabel *priceLabel;
@property(nonatomic) FBKVOController *kvo;
@end

@implementation LivePresentCell:UICollectionViewCell

-(void)refreshByPresent:(LivePresent*)present isBig:(BOOL)isBig{
    if(_imgView == nil){
        _leftLabel = [xViewFactory labelWithText:@"连" font:kFontRegularPF(10) color:[xColor blackColor]];
        _leftLabel.backgroundColor = kColorA(0xFFFFFF, 0.4);
        _leftLabel.layer.cornerRadius = 2;
        _leftLabel.clipsToBounds = YES;
        [self addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(4);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(14);
        }];
        _leftLabel.hidden = YES;
        
        _rightLabel = [xViewFactory labelWithText:@"" font:kFontRegularPF(10) color:[xColor clearColor]];
        _rightLabel.layer.cornerRadius = 2;
        _rightLabel.clipsToBounds = YES;
        [self addSubview:_rightLabel];
        _rightLabel.hidden = YES;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
        
        _nameLabel = [[YYLabel alloc] init];
        [self addSubview:_nameLabel];
        
        _priceLabel = [[YYLabel alloc] init];
        [self addSubview:_priceLabel];
    }
    self.present = present;
    self.isBig = isBig;
    
    [self updateIsSelect];
    [self updateLeftLabel];
    [self updateRightLabel];
    [self updateImg];
    [self updateName];
    [self updatePrice];
    
    self.kvo = nil; //释放之前的观察
    self.kvo = [[FBKVOController alloc] initWithObserver:self];
    __weak typeof(self) weak = self;
    [self.kvo observe:self.present keyPath:@"accountRemains" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        [xTask asyncMain:^{
            [weak updateRightLabel];
        }];
    }];
    [self.kvo observe:self.present keyPath:@"isSelect" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        [xTask asyncMain:^{
            [weak updateIsSelect];
        }];
    }];
    [self.kvo observe:self.present keyPath:@"isLock" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary<NSString *,id> * change) {
        [xTask asyncMain:^{
            [weak updateName];
        }];
    }];
}

-(void)updateIsSelect{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = _isBig ? 6 : 3;
    if(self.present.isSelect){
        self.layer.borderColor = kColor(0xE6534F).CGColor;
    }
    else{
        self.layer.borderColor = [xColor clearColor].CGColor;
    }
}

-(void)updateLeftLabel{
    _leftLabel.hidden = !_present.combo;
}

-(void)updateRightLabel{
    NSString *str;
    UIColor *color;
    if(_present.accountRemains > 0){
        str = [NSString stringWithFormat:@"X%ld", (long)_present.accountRemains];
        color = kColor(0xFFCC01);
    }
    else if(_present.level > 0){
        str = [NSString stringWithFormat:@"Lv.%ld", (long)_present.level];
        color = kColor(0xE6534F);
    }
    else if(_present.priv == 1){
        str = @"首充";
        color = kColor(0xE6534F);
    }
    else if(_present.label_text.length > 0){
        str = _present.label_text;
        color = kColor(0xE6534F);
    }
    if(str){
        _rightLabel.text = str;
        _rightLabel.backgroundColor = color;
        CGSize size = [str x_sizeWithFont:_rightLabel.font];
        [_rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-4);
            make.top.mas_equalTo(4);
            make.width.mas_equalTo(size.width + 6);
            make.height.mas_equalTo(14);
        }];
        _rightLabel.hidden = NO;
    }
    else{
        _rightLabel.hidden = YES;
    }
}

-(void)updateImg{
    if(_isBig){
        [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(20);
            make.width.height.mas_equalTo(120);
        }];
    }
    else{
        [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.mas_equalTo(5);
            make.width.height.mas_equalTo(60);
        }];
    }
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_present.img_url]];
}

-(void)updateName{
    NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc] init];
    if(self.present.isLock){
        [nameAttr x_appendImgNamed:@"live-lock" alignToFont:self.isBig ? kFontRegularPF(13) : kFontRegularPF(12)];
        [nameAttr x_appendStr:[NSString stringWithFormat:@" %@",self.present.name] foreColor:[xColor whiteColor] font:self.isBig ? kFontRegularPF(13) : kFontRegularPF(12)];
    }
    else{
        [nameAttr x_appendStr:self.present.name foreColor:[xColor whiteColor] font:self.isBig ? kFontRegularPF(13) : kFontRegularPF(12)];
    }
    _nameLabel.attributedText = nameAttr;
    CGSize size = [nameAttr x_sizeWithMaxWidth:CGFLOAT_MAX];
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.equalTo(_imgView.mas_bottom).offset(_isBig ? 9 : 3);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
}

-(void)updatePrice{
    NSMutableAttributedString *priceAttr = [[NSMutableAttributedString alloc] init];
    if(self.present.price > 0){
        [priceAttr x_appendImgNamed:@"live-beans" alignToFont:kFontRegularPF(12)];
        [priceAttr x_appendStr:[NSString stringWithFormat:@" %ld",(long)self.present.price] foreColor:kColorA(0xFFFFFF, 0.7) font:kFontRegularPF(12)];
    }
    else if(self.present.drop_price > 0){
        [priceAttr x_appendImgNamed:@"live-drops" alignToFont:kFontRegularPF(12)];
        [priceAttr x_appendStr:[NSString stringWithFormat:@" %ld",(long)self.present.drop_price] foreColor:kColorA(0xFFFFFF, 0.7) font:kFontRegularPF(12)];
    }
    _priceLabel.attributedText = priceAttr;
    CGSize size = [priceAttr x_sizeWithMaxWidth:CGFLOAT_MAX];
    [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.equalTo(_nameLabel.mas_bottom).offset(_isBig ? 8 : 3);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
}

@end
