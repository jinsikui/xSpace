//
//  LiveComboView.h
//  xSpace
//
//  Created by JSK on 2018/7/18.
//  Copyright © 2018年 xSpace. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LiveComboViewTimeoutCallback)();
typedef void(^LiveComboViewAmountCallback)(NSInteger);

@interface LiveComboView : UIView

@property(nonatomic,copy) LiveComboViewTimeoutCallback  timeoutCallback;
@property(nonatomic,copy) LiveComboViewAmountCallback   amountCallback;

-(instancetype)initWithPlans:(NSArray<NSNumber*>*)plans;

-(void)show;

@end
