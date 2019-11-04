//
//  HQLFirstTableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/20.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLFirstTableViewController.h"

static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";
static const CGFloat KCellHeight = 44;

@interface HQLFirstTableViewController ()

/** 列表分组名*/
@property (nonatomic,strong) NSMutableArray *sectionArray;
/** 列表每行的数据源*/
@property (nonatomic,strong) NSMutableArray *dataSource;
/** 标记数组：标记列表每组的展开/收缩状态*/
@property (nonatomic,strong) NSMutableArray *flagArray;

@end

@implementation HQLFirstTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)setupTableView {
    // 重用UITableViewCell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReusreIdentifier];
    // 列表底部视图
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Custom Accessors

// 列表分组名
- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray arrayWithObjects:
                         @"section 1",
                         @"section 2",
                         @"section 3",
                         @"section 4", nil];
    }
    return _sectionArray;
}

// 列表每行的数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSArray *one = @[@"section 11",@"section 12",@"section 13"];
        NSArray *two = @[@"section 21",@"section 22",@"section 23"];
        NSArray *three = @[@"section 31",@"section 32",@"section 33"];
        NSArray *four = @[@"section 41",@"section 42",@"section 43",@"section 44"];
        _dataSource = [NSMutableArray arrayWithObjects:one,two,three,four, nil];
    }
    return _dataSource;
}

// 标记数组
- (NSMutableArray *)flagArray {
    if (!_flagArray) {
        _flagArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.dataSource.count; i++)
        {
            //初始化所有分组为收起状态
            [_flagArray addObject:@"0"];
        }
    }
    return _flagArray;
}

#pragma mark - IBAction

// headButton 点击事件
- (void)buttonPress:(UIButton *)sender {
    if ([self.flagArray[sender.tag] isEqualToString:@"1"]){
        // 1——>0
        [self.flagArray replaceObjectAtIndex:sender.tag withObject:@"0"];
    }else{
        // 0——>1
        [self.flagArray replaceObjectAtIndex:sender.tag withObject:@"1"];
    }
    // 重新加载section
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource

// 显示段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

// 动态显示每段行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 查询标记数组
    if ([self.flagArray[section] isEqualToString:@"1"]){
        // flagArray = 1,显示每行数据
        NSArray *array = [self.dataSource objectAtIndex:section];
        return array.count;
    }else{
        // flagArray = 0,不显示
        return 0;
    }
}

// 每段显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 辅助指示视图
    return cell;
}

#pragma mark - UITableViewDelegate

// ⭐️⭐️⭐️自定义头部视图，返回自定义按钮
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 创建UIButton对象
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [button setTag:section]; // Tag 用来标记是按钮所属的 Section 段落
    button.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0];
    // 设置Image
    [button setImage:[UIImage imageNamed:@"buttonImage"] forState:UIControlStateNormal];
    // 设置Title
    [button setTitle:self.sectionArray[section] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 设置偏移量
    CGFloat imageOriginX = button.imageView.frame.origin.x;
    CGFloat imageWidth = button.imageView.frame.size.width;
    CGFloat titleOriginX = button.titleLabel.frame.origin.x;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -titleOriginX+imageWidth + 20, 0, titleOriginX-imageWidth-20)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -imageOriginX + 10, 0, imageOriginX -  10);
    // 添加点击事件
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    // 下拉上拉指示视图
    UIImageView *_imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, (KCellHeight-6)/2, 10, 6)];
    if ([self.flagArray[section] isEqualToString:@"0"]) {
        _imgView.image = [UIImage imageNamed:@"ico_listdown"];
    }else if ([self.flagArray[section] isEqualToString:@"1"]) {
        _imgView.image = [UIImage imageNamed:@"ico_listup"];
    }
    [button addSubview:_imgView];
    return button;
}

// 头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KCellHeight;
}

// 底部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

@end
