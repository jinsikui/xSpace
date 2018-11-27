//
//  SingletonController.m
//  xSpace
//
//  Created by JSK on 2018/5/18.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "SingletonController.h"

@interface SingletonController ()
@property(nonatomic) UIButton *btn;
@end

@implementation SingletonController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [xViewFactory buttonWithTitle:@"Singleton Page" font:kFontRegularPF(13) titleColor:kColor(0) bgColor:[UIColor clearColor] cornerRadius:4 borderColor:kColor(0) borderWidth:1];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(200);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(100);
    }];
    _btn = btn;
    
}

-(void)update{
    [_btn setTitle:@"Updating。。。" forState:UIControlStateNormal];
    [xTask asyncMainAfter:2 task:^{
        [self.btn setTitle:@"Singleton Page" forState:UIControlStateNormal];
    }];
}

@end
