//
//  CoreDataController.m
//  xPortal
//
//  Created by JSK on 2017/3/10.
//  Copyright © 2017年 xSpace. All rights reserved.
//

#import "CoreDataController.h"
#import "CoreDataManager.h"
#import "EmployeeMO.h"
#import "DepartmentMO.h"
#import "FriendInfoMO.h"
#import "PersonMO.h"


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
@property(nonatomic, strong) UITableView    *friendedTable;
@property(nonatomic, strong) DepartmentMO   *selectDep;
@property(nonatomic, strong) UILabel        *srcLabel;
@property(nonatomic, strong) UILabel        *friendedLabel;
@property(nonatomic, strong) PersonMO       *selectPerson;
//
@property(nonatomic, strong) NSArray        *departmentArr;
@property(nonatomic, strong) NSArray        *employeeArr;
@property(nonatomic, strong) NSArray        *personArr;
@property(nonatomic, strong) NSArray        *friendArr;
@property(nonatomic, strong) NSArray        *friendedArr;
@end

@implementation CoreDataController

-(instancetype)init{
    self = [super init];
    if(!self) return nil;
    
    _departmentArr = [[CoreDataManager sharedInstance] executeResultByPredicate:nil limit:0 offset:0 entityName:kDepartmentEntityName descriptorKey:nil ascending:NO];
    if(_departmentArr.count == 0){
        DepartmentMO *dep1 = (DepartmentMO*)[[CoreDataManager sharedInstance] objectForInsert:kDepartmentEntityName];
        dep1.title = @"设计部";
        DepartmentMO *dep2 = (DepartmentMO*)[[CoreDataManager sharedInstance] objectForInsert:kDepartmentEntityName];
        dep2.title = @"施工部";
        DepartmentMO *dep3 = (DepartmentMO*)[[CoreDataManager sharedInstance] objectForInsert:kDepartmentEntityName];
        dep3.title = @"市场部";
        
        EmployeeMO *emp1 = (EmployeeMO*)[[CoreDataManager sharedInstance] objectForInsert:kEmployeeEntityName];
        emp1.name = @"小明";
        emp1.department = dep1;
        EmployeeMO *emp2 = (EmployeeMO*)[[CoreDataManager sharedInstance] objectForInsert:kEmployeeEntityName];
        emp2.name = @"小强";
        emp2.department = dep1;
        EmployeeMO *emp3 = (EmployeeMO*)[[CoreDataManager sharedInstance] objectForInsert:kEmployeeEntityName];
        emp3.name = @"小美";
        emp3.department = dep2;
        EmployeeMO *emp4 = (EmployeeMO*)[[CoreDataManager sharedInstance] objectForInsert:kEmployeeEntityName];
        emp4.name = @"小金";
        emp4.department = dep2;
        EmployeeMO *emp5 = (EmployeeMO*)[[CoreDataManager sharedInstance] objectForInsert:kEmployeeEntityName];
        emp5.name = @"小朋";
        emp5.department = dep3;
        
        PersonMO *p1 = (PersonMO*)[[CoreDataManager sharedInstance] objectForInsert:kPersonEntityName];
        p1.name = @"小明";
        PersonMO *p2 = (PersonMO*)[[CoreDataManager sharedInstance] objectForInsert:kPersonEntityName];
        p2.name = @"小强";
        PersonMO *p3 = (PersonMO*)[[CoreDataManager sharedInstance] objectForInsert:kPersonEntityName];
        p3.name = @"小美";
        PersonMO *p4 = (PersonMO*)[[CoreDataManager sharedInstance] objectForInsert:kPersonEntityName];
        p4.name = @"小金";
        PersonMO *p5 = (PersonMO*)[[CoreDataManager sharedInstance] objectForInsert:kPersonEntityName];
        p5.name = @"小朋";
        
        FriendInfoMO *f1 = (FriendInfoMO*)[[CoreDataManager sharedInstance] objectForInsert:kFriendInfoEntityName];
        f1.source = p1;//小明-小强
        f1.setAsFriend = p2;
        FriendInfoMO *f2 = (FriendInfoMO*)[[CoreDataManager sharedInstance] objectForInsert:kFriendInfoEntityName];
        f2.source = p1;//小明-小美
        f2.setAsFriend = p3;
        FriendInfoMO *f3 = (FriendInfoMO*)[[CoreDataManager sharedInstance] objectForInsert:kFriendInfoEntityName];
        f3.source = p2;//小强-小美
        f3.setAsFriend = p3;
        FriendInfoMO *f4 = (FriendInfoMO*)[[CoreDataManager sharedInstance] objectForInsert:kFriendInfoEntityName];
        f4.source = p3;//小美-小强
        f4.setAsFriend = p2;
        FriendInfoMO *f5 = (FriendInfoMO*)[[CoreDataManager sharedInstance] objectForInsert:kFriendInfoEntityName];
        f5.source = p4;//小金-小朋
        f5.setAsFriend = p5;
        FriendInfoMO *f6 = (FriendInfoMO*)[[CoreDataManager sharedInstance] objectForInsert:kFriendInfoEntityName];
        f6.source = p5;//小朋-小金
        f6.setAsFriend = p4;
        [[CoreDataManager sharedInstance] save];
    }
    _departmentArr = [[CoreDataManager sharedInstance] executeResultByPredicate:nil limit:0 offset:0 entityName:kDepartmentEntityName descriptorKey:nil ascending:NO];
    _personArr = [[CoreDataManager sharedInstance] executeResultByPredicate:nil limit:0 offset:0 entityName:kPersonEntityName descriptorKey:nil ascending:NO];
    return self;
}

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
    _departmentTable = [[UITableView alloc] initWithFrame:CGRectMake(x, y, 200, 100)];
    _departmentTable.layer.borderWidth = 0.5;
    _departmentTable.layer.borderColor = kColor_000000.CGColor;
    _departmentTable.dataSource = self;
    _departmentTable.delegate = self;
    [_scroll addSubview:_departmentTable];
    y += 100+10;
    //
    _employeeTable = [[UITableView alloc] initWithFrame:CGRectMake(x, y, kScreenWidth - 2*x, 150)];
    _employeeTable.layer.borderWidth = 0.5;
    _employeeTable.layer.borderColor = kColor_000000.CGColor;
    _employeeTable.dataSource = self;
    _employeeTable.delegate = self;
    [_scroll addSubview:_employeeTable];
    y += 150+10;
    //
    _personTable = [[UITableView alloc] initWithFrame:CGRectMake(x, y, kScreenWidth - 2*x, 150)];
    _personTable.layer.borderWidth = 0.5;
    _personTable.layer.borderColor = kColor_000000.CGColor;
    _personTable.dataSource = self;
    _personTable.delegate = self;
    [_scroll addSubview:_personTable];
    y += 150+10;
    //
    _srcLabel = [xViewTools createLabel:@"" frame:CGRectMake(x, y, 100, 28) alignment:NSTextAlignmentLeft font:kFontPF(14) textColor:kColor_000000 line:1];
    [_scroll addSubview:_srcLabel];
    //
    _friendedLabel = [xViewTools createLabel:@"" frame:CGRectMake(x+120, y, 100, 28) alignment:NSTextAlignmentLeft font:kFontPF(14) textColor:kColor_000000 line:1];
    [_scroll addSubview:_friendedLabel];
    y += 38;
    //
    _friendTable = [[UITableView alloc] initWithFrame:CGRectMake(x, y, 100, 150)];
    _friendTable.layer.borderWidth = 0.5;
    _friendTable.layer.borderColor = kColor_000000.CGColor;
    _friendTable.dataSource = self;
    _friendTable.delegate = self;
    [_scroll addSubview:_friendTable];
    //
    _friendedTable = [[UITableView alloc] initWithFrame:CGRectMake(x+120, y, 100, 150)];
    _friendedTable.layer.borderWidth = 0.5;
    _friendedTable.layer.borderColor = kColor_000000.CGColor;
    _friendedTable.dataSource = self;
    _friendedTable.delegate = self;
    [_scroll addSubview:_friendedTable];
    y += 150+20;
    //
    _scroll.contentSize = CGSizeMake(0, y);
    
}

#pragma mark - actions

-(void)actionAddFriend{
    
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
        return _selectDep.employees.count;
    }
    else if(tableView == _personTable){
        return _personArr.count;
    }
    else if(tableView == _friendTable){
        if(!_selectPerson){
            return 0;
        }
        return _selectPerson.friends.count;
    }
    else if(tableView == _friendedTable){
        if(!_selectPerson){
            return 0;
        }
        return _selectPerson.beFriendedBy.count;
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
        cell.textLabel.text = ((DepartmentMO*)_departmentArr[indexPath.row]).title;
        return cell;
    }
    else if(tableView == _employeeTable){
        static NSString *cellId = @"employeeCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.font = kFontPF(14);
        }
        cell.textLabel.text = ((EmployeeMO*)_employeeArr[indexPath.row]).name;
        return cell;
    }
    else if(tableView == _personTable){
        static NSString *cellId = @"personCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.font = kFontPF(14);
        }
        cell.textLabel.text = ((PersonMO*)_personArr[indexPath.row]).name;
        return cell;
    }
    else if(tableView == _friendTable){
        static NSString *cellId = @"friendCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.font = kFontPF(14);
        }
        cell.textLabel.text = ((PersonMO*)_friendArr[indexPath.row]).name;
        return cell;
    }
    else if(tableView == _friendedTable){
        static NSString *cellId = @"friendedCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.font = kFontPF(14);
        }
        cell.textLabel.text = ((PersonMO*)_friendedArr[indexPath.row]).name;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _departmentTable){
        _selectDep = _departmentArr[indexPath.row];
        _employeeArr = [NSArray arrayWithArray:[_selectDep.employees allObjects]];
        [_employeeTable reloadData];
    }
    else if(tableView == _personTable){
        _selectPerson = _personArr[indexPath.row];
        //
        _srcLabel.text = [NSString stringWithFormat:@"%@的朋友：",_selectPerson.name];
        _friendedLabel.text = [NSString stringWithFormat:@"以%@为朋友：",_selectPerson.name];
        //
        NSSet<PersonMO*>* friendSet = [_selectPerson valueForKeyPath:@"friends.setAsFriend"];
        _friendArr = [NSArray arrayWithArray:[friendSet allObjects]];
        [_friendTable reloadData];
        //
        NSSet<PersonMO*>* friendedSet = [_selectPerson valueForKeyPath:@"beFriendedBy.source"];
        _friendedArr = [NSArray arrayWithArray:[friendedSet allObjects]];
        [_friendedTable reloadData];
    }
}

@end
