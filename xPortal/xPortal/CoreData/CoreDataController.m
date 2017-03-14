//
//  CoreDataController.m
//  xPortal
//
//  Created by JSK on 2017/3/10.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "CoreDataController.h"
#import "CoreDataManager.h"

#define kEmployeeEntityName     @"Employee"
#define kDepartmentEntityName   @"Department"
#define kPersonEntityName       @"Person"
#define kFriendInfoEntityName   @"FriendInfo"

@interface CoreDataController ()<UITableViewDataSource, UITableViewDelegate>{

}

@property(nonatomic, strong) UIScrollView *scroll;
@property(nonatomic, strong) UITableView *departmentTable;
@property(nonatomic, strong) UITableView *employeeTable;
@property(nonatomic, strong) UITableView *personTable;
@property(nonatomic, strong) UITableView *friendTable;
@property(nonatomic, strong) UITextField *departInput;
@end

@implementation CoreDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Core Data";
    self.view.backgroundColor = [UIColor whiteColor];
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentHeight)];
    [self.view addSubview:_scroll];
    _scroll.alwaysBounceVertical = YES;
    
    CGFloat y = 20;
    CGFloat x = 20;
    //
    _departInput = [[UITextField alloc] initWithFrame:CGRectMake(x, y, 200, 40)];
    [_scroll addSubview:_departInput];
    //
    UIButton *addDepartBtn = [xViewTools createBtn:CGRectMake(x+210, y, 60, 40) bgColor:kColor_FFFFFF titleColor:kColor_000000 title:@"添加" font:kFontPF(20) target:self selector:@selector(addDepartment)];
    [_scroll addSubview:addDepartBtn];
    y += 20;
    //
    _departmentTable = [[UITableView alloc] initWithFrame:CGRectMake(x, y, 270, 100)];
    _departmentTable.dataSource = self;
    _departmentTable.delegate = self;
}

-(void)addDepartment{
    NSString *name = _departInput.text;
    [[CoreDataManager sharedInstance] objectForInsert:kDepartmentEntityName];
}

@end
