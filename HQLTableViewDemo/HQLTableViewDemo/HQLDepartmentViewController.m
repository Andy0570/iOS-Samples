//
//  HQLDepartmentViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/21.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLDepartmentViewController.h"

// Controllers

// Views
#import "HQLDepartmentCell.h"

// Models
#import "HQLDepartment.h"

#define DEPARTMENT_BACKGROUND_COLOR [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]

static NSString *const leftReusreIdentifier = @"HQLDepartmentCell";
static NSString *const rightReusreIdentifier = @"UITableViewCellStyleDefault";

@interface HQLDepartmentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSMutableArray *dataSource;
@property (nonatomic, copy) NSArray *rightDataSourceArray; // 小科室数组
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@end

@implementation HQLDepartmentViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self requestDapartmentData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height);
        _leftTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _leftTableView.backgroundColor = DEPARTMENT_BACKGROUND_COLOR;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
                CGRect rect = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 64, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height);
        _rightTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _rightTableView.showsHorizontalScrollIndicator = NO;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.tableFooterView = [UIView new];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
    }
    return _rightTableView;
}

#pragma mark - Private

- (void)setupTableView {
    
    [self.leftTableView registerClass:[HQLDepartmentCell class]
               forCellReuseIdentifier:leftReusreIdentifier];
    [self.rightTableView registerClass:[UITableViewCell class]
                forCellReuseIdentifier:rightReusreIdentifier];
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
}

#pragma mark 5.2 获取某一医院全部科室信息
- (void)requestDapartmentData {
    
    // JSON
    NSDictionary *JSON = @{@"group":
                               @[
                                   @{@"groupName":@"内科",
                                     @"groupArray":@[@"心血管内科",@"呼吸科",@"消化内科",@"神经内科",@"肾内科",@"血液科",@"风湿免疫科",@"感染性疾病科",@"内分泌科"]},
                                   @{@"groupName":@"外科",
                                     @"groupArray":@[@"普外科",@"心胸外科",@"神经外科",@"肛肠科",@"泌尿外科",@"医疗美容科",@"烧伤整形科"]},
                                   @{@"groupName":@"骨科",
                                     @"groupArray":@[@"骨科"]},
                                   @{@"groupName":@"妇产科",
                                     @"groupArray":@[@"妇产科"]},
                                   @{@"groupName":@"儿科",
                                     @"groupArray":@[@"儿科",@"儿外科"]},
                                   @{@"groupName":@"眼科",
                                     @"groupArray":@[@"眼科"]},
                                   @{@"groupName":@"耳鼻咽喉头颈科",
                                     @"groupArray":@[@"耳鼻喉科"]},
                                   @{@"groupName":@"口腔科",
                                     @"groupArray":@[@"口腔科"]},
                                   @{@"groupName":@"皮肤性病科",
                                     @"groupArray":@[@"皮肤性病科"]},
                                   @{@"groupName":@"肿瘤科",
                                     @"groupArray":@[@"放疗科",@"立体定向科",@"肿瘤科"]},
                                   @{@"groupName":@"疼痛科",
                                     @"groupArray":@[@"疼痛科"]},
                                   @{@"groupName":@"皮肤性病科",
                                     @"groupArray":@[@"皮肤性病科"]},
                                   @{@"groupName":@"医学影像科",
                                     @"groupArray":@[@"核医学科"]},
                                   @{@"groupName":@"皮肤性病科",
                                     @"groupArray":@[@"皮肤性病科"]},
                                   @{@"groupName":@"中医科",
                                     @"groupArray":@[@"中医科"]},
                                   @{@"groupName":@"其他",
                                     @"groupArray":@[@"介入放射科",@"康复科",@"老年病科"]},
                                   ]
                           };
    self.dataSource = JSON[@"group"];
//    for (NSDictionary *groupDictionary in JSON[@"group"]) {
//        [self.dataSource addObject:groupDictionary];
//    }
    
    NSDictionary *first = self.dataSource[0];
    self.rightDataSourceArray = first[@"groupArray"];
    
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    
    // 默认选中第一行
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.leftTableView selectRowAtIndexPath:firstIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.dataSource.count;
    }else {
        return self.rightDataSourceArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        HQLDepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:leftReusreIdentifier forIndexPath:indexPath];
        NSDictionary *dict = self.dataSource[indexPath.row];
        cell.textLabel.text = dict[@"groupName"];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightReusreIdentifier forIndexPath:indexPath];
        cell.textLabel.text = self.rightDataSourceArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

// 设置 cell 边距
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.rightTableView) {
        return;
    }
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


/**
 * 1. 点击左边的大科室 -> 更新对应右侧科室
 * 2. 点击右边的小科室 -> 导航跳转
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        NSDictionary *dict = self.dataSource[indexPath.row]; // 取得对应的数据源
        self.rightDataSourceArray = dict[@"groupArray"];
        [self.rightTableView reloadData];
    }else {
        [self.rightTableView deselectRowAtIndexPath:indexPath animated:YES]; // 取消选中状态
        NSLog(@"right select %ld",indexPath.row);
    }
}

@end
