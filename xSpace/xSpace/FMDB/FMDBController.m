//
//  FMDBController.m
//  xPortal
//
//  Created by JSK on 2017/4/5.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "FMDBController.h"
#import "FMDB.h"
#import "Department.h"
#import "Employee.h"

@interface FMDBController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UIScrollView       *scroll;
@property(nonatomic, strong) UITableView        *departmentTable;
@property(nonatomic, strong) UITableView        *employeeTable;
@property(nonatomic, strong) FMDatabase         *db;
//
@property(nonatomic, strong) NSArray            *departmentArr;
@property(nonatomic, strong) Department         *selectDep;
@property(nonatomic, strong) NSArray            *employeeArr;
@end

@implementation FMDBController

-(instancetype)init{
    self = [super init];
    if(!self) return nil;
    //
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.db"];
    _db = [FMDatabase databaseWithPath:path];
    if (![_db open]) {
        _db = nil;
        exit(1);
    }
    //
    NSString *sql = @"create table if not exists Department (id integer primary key autoincrement, name text);"
                    "create table if not exists Employee (id integer primary key autoincrement, name text, fk_department_id integer);"
                    "delete from Department where 1 = 1;"
                    "delete from Employee where 1 = 1;";
    BOOL success = [_db executeStatements:sql];
    if(!success){
        NSLog(@"%@", [_db lastErrorMessage]);
        exit(1);
    }
    //
    [_db executeUpdate:@"insert into Department(name) values(?)", @"设计部"];
    [_db executeUpdate:@"insert into Department(name) values(?)", @"施工部"];
    [_db executeUpdate:@"insert into Department(name) values(?)", @"市场部"];
    //
    FMResultSet *depResult = [_db executeQuery:@"select * from Department"];
    NSMutableArray *depArr = [NSMutableArray array];
    while ([depResult next]) {
        Department *dep = [[Department alloc] init];
        dep.Id = [depResult intForColumn:@"id"];
        dep.name = [depResult stringForColumn:@"name"];
        [depArr addObject:dep];
    }
    _departmentArr = depArr;
    //
    for(Department *dep in _departmentArr){
        if([dep.name isEqualToString:@"设计部"]){
            [_db executeUpdate:@"insert into Employee(name, fk_department_id) values(?,?)", @"小明", @(dep.Id)];
            [_db executeUpdate:@"insert into Employee(name, fk_department_id) values(?,?)", @"小强", @(dep.Id)];
        }
        else if([dep.name isEqualToString:@"施工部"]){
            [_db executeUpdate:@"insert into Employee(name, fk_department_id) values(?,?)", @"小美", @(dep.Id)];
            [_db executeUpdate:@"insert into Employee(name, fk_department_id) values(?,?)", @"小金", @(dep.Id)];
        }
        else if([dep.name isEqualToString:@"市场部"]){
            [_db executeUpdate:@"insert into Employee(name, fk_department_id) values(?,?)", @"小朋", @(dep.Id)];
        }
    }
    [_db commit];
    return self;
}

- (void)dealloc{
    [_db close];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FMDB";
    self.view.backgroundColor = kColor(0xFFFFFF);
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kStatusBarHeight - kNavBarHeight)];
    [self.view addSubview:_scroll];
    _scroll.alwaysBounceVertical = YES;
    
    CGFloat y = 20;
    CGFloat x = 20;
    //
    _departmentTable = [[UITableView alloc] initWithFrame:CGRectMake(x, y, 200, 100)];
    _departmentTable.layer.borderWidth = 0.5;
    _departmentTable.layer.borderColor = kColor(0x000000).CGColor;
    _departmentTable.dataSource = self;
    _departmentTable.delegate = self;
    [_scroll addSubview:_departmentTable];
    y += 100+10;
    //
    _employeeTable = [[UITableView alloc] initWithFrame:CGRectMake(x, y, kScreenWidth - 2*x, 150)];
    _employeeTable.layer.borderWidth = 0.5;
    _employeeTable.layer.borderColor = kColor(0x000000).CGColor;
    _employeeTable.dataSource = self;
    _employeeTable.delegate = self;
    [_scroll addSubview:_employeeTable];
    y += 150+10;
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _departmentTable){
        return _departmentArr.count;
    }
    else if(tableView == _employeeTable){
        if(!_selectDep){
            return 0;
        }
        return _employeeArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 28;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _departmentTable){
        static NSString *cellId = @"departmentCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.font = kFontPF(14);
        }
        cell.textLabel.text = ((Department*)_departmentArr[indexPath.row]).name;
        return cell;
    }
    else if(tableView == _employeeTable){
        static NSString *cellId = @"employeeCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.font = kFontPF(14);
        }
        cell.textLabel.text = ((Employee*)_employeeArr[indexPath.row]).name;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _departmentTable){
        _selectDep = _departmentArr[indexPath.row];
        FMResultSet *result = [_db executeQuery:@"select * from Employee where fk_department_id = ?", @(_selectDep.Id)];
        NSMutableArray *empArr = [NSMutableArray array];
        while([result next]){
            Employee *emp = [[Employee alloc] init];
            emp.name = [result stringForColumn:@"name"];
            emp.Id = [result intForColumn:@"id"];
            emp.fk_department_id = [result intForColumn:@"fk_department_id"];
            [empArr addObject:emp];
        }
        _employeeArr = empArr;
        [_employeeTable reloadData];
    }
}

@end
