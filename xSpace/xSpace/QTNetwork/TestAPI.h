//
//  TestAPI.h
//  QTNetwork
//
//  Created by JSK on 2017/11/9.
//Copyright © 2017年 QT. All rights reserved.
//

#import "QTNetwork.h"

@class NSDictionary;//Result

@interface TestAPI : NSObject<QTRequestConvertable>

@property(nonatomic, copy) NSString * Id;

-(instancetype)initWithId:(NSString*)Id;

@end

