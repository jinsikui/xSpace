//
//  QTNetworkController.m
//  xPortal
//
//  Created by JSK on 2017/11/9.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "QTNetworkController.h"
#import "QTNetwork.h"
#import "TestAPI.h"

@interface QTNetworkController ()
@property (strong, nonatomic) QTNetworkManager * manager;
@end

@implementation QTNetworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"QTNetwork test";
    UILabel *label = [xViewTools createLabel:@"See console print" frame:CGRectMake(100, 100, 200, 17) alignment:NSTextAlignmentLeft font:kFontPF(17) textColor:kColor_000000 line:1];
    [self.view addSubview:label];
    self.manager = [QTNetworkManager manager];
    TestAPI *api = [[TestAPI alloc] initWithId:@"abcab67b8afe4a2ac1dd559d483348aa"];
    [self.manager request:api
               completion:^(QTNetworkResponse * _Nonnull response) {
                   NSLog(@"%@",response.responseObject);
               }];
    
}


@end
