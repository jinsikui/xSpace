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

@property(nonatomic, strong) UIScrollView   *scroll;
@property(nonatomic, strong) UITableView    *departmentTable;
@property(nonatomic, strong) UITableView    *employeeTable;
@property(nonatomic, strong) UITableView    *personTable;
@property(nonatomic, strong) UITableView    *friendTable;
@property(nonatomic, strong) UITextField    *departInput;
@property(nonatomic, strong) NSArray        *departmentArr;
@property(nonatomic, strong) NSArray        *employeeArr;
@property(nonatomic, strong) NSArray        *personArr;
@property(nonatomic, strong) NSArray        *friendArr;
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
    UIButton *addDepartBtn = [xViewTools createBtn:CGRectMake(x+210, y, 60, 40) bgColor:kColor_FFFFFF titleColor:kColor_000000 title:@"添加" font:kFontPF(20) target:self selector:@selector(actionAddDepartment)];
    [_scroll addSubview:addDepartBtn];
    y += 20;
    //
    _departmentTable = [[UITableView alloc] initWithFrame:CGRectMake(x, y, 270, 100)];
    _departmentTable.dataSource = self;
    _departmentTable.delegate = self;
}

#pragma mark - actions

//-(void)actionAddDepartment{
//    NSString *title = _departInput.text;
//    DepartmentMO *dep = (DepartmentMO*)[[CoreDataManager sharedInstance] objectForInsert:kDepartmentEntityName];
//    dep.title = title;
//    [[CoreDataManager sharedInstance] save];
//    [_departmentTable reloadData];
//}
//
//#pragma mark - tableView
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if(tableView == _departmentTable){
//        if(!_departmentArr){
//            _departmentArr = [[CoreDataManager sharedInstance] executeResultByPredicate:nil limit:0 offset:0 entityName:kDepartmentEntityName descriptorKey:nil ascending:NO];
//        }
//        return _departmentArr.count;
//    }
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 45;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(tableView == _departmentTable){
//        static NSString *cellId = @"departmentCell";
//        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
//        if(!cell){
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//        }
//        cell.textLabel.text = ((DepartmentMO*)_departmentArr[indexPath.row]).title;
//        return cell;
//    }
//    return nil;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

@end
