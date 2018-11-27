//
//  SliderController.m
//  xSpace
//
//  Created by JSK on 2018/6/10.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import "SliderController.h"
#import "xUISlider.h"

@interface SliderController ()
@property (nonatomic,strong) UISlider *slider;
@end

@implementation SliderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Slider";
    
    _slider = [[xUISlider alloc ] initWithFrame:CGRectMake(0,100,200 ,40) ];//高度设为40就好,高度代表手指触摸的高度.这个一定要注意
    _slider.minimumValue = 0.0;//下限
    _slider.maximumValue = 50.0;//上限
    _slider.value = 22.0;//开始默认值
    _slider.backgroundColor =[UIColor redColor];//测试用
    _slider.minimumTrackTintColor = kColor(0xFD5353);
    _slider.maximumTrackTintColor = kColor(0xFFECEC);
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _slider.continuous = NO;//当放开手., 值才确定下来
    [ self.view addSubview:_slider ];
}

-(void)sliderValueChanged:(UISlider *)paramSender{
    NSLog(@"New value=%f",paramSender.value);
}
@end
