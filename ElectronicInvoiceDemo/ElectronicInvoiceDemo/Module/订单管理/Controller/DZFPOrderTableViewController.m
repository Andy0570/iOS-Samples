//
//  DZFPOrderTableViewController.m
//  XuZhouSS
//
//  Created by Qilin Hu on 2018/4/4.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "DZFPOrderTableViewController.h"

// Framework
#import <MJRefresh.h>

// View
#import "DZFPOrderTableViewCell.h"

// Model
#import "DZFPOrderModel.h"

static NSString * const cellReusreIdentifier = @"DZFPOrderTableViewCell";

@interface DZFPOrderTableViewController ()

@property (nonatomic, copy) NSArray *dataSourceArray; // 订单数据源

@end

@implementation DZFPOrderTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView]; // 初始化 tableView
}

#pragma mark - Custom Accessors

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"orderData" ofType:@"plist"];
        NSArray *jsonArray = [NSArray arrayWithContentsOfFile:path];
        _dataSourceArray = [NSArray modelArrayWithClass:[DZFPOrderModel class] json:jsonArray];
    }
    return _dataSourceArray;
}

#pragma mark - Private

- (void)setupTableView {
    // 注册重用cell
    
    // nib方式注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DZFPOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellReusreIdentifier];
    // 手写代码方式使用如下方法注册cell
//    [self.tableView registerClass:[DZFPOrderTableViewCell class]
//           forCellReuseIdentifier:cellReusreIdentifier];
    
    self.tableView.rowHeight = DZFPOrderTableViewCellHeight; // 设置 cell 高度
    self.tableView.tableFooterView = [UIView new];
    
    // 下拉刷新控件
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestOrderData)];
}

// 模仿请求服务器获取订单数据流程
- (void)requestOrderData {
    
    // 5秒后停止刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData]; // 刷新数据
        [self.tableView.mj_footer endRefreshingWithNoMoreData]; // 下拉控件停止刷新
    });
    
}

#pragma mark - UITableViewDataSource

// 返回 cell 的行数，即 dataSourceArray 数组中元素的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

// 返回每一行 cell 显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 自定义cell
    DZFPOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier forIndexPath:indexPath];
    
    // 该行对应的模型数据
    DZFPOrderModel *model = (DZFPOrderModel *)self.dataSourceArray[indexPath.row];
    cell.orderModel = model;
    
    return cell;
}

#pragma mark - UITableViewDelegate

// 选中某一行之后，调用如下方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s",__func__); // 打印函数名称
    NSLog(@"当前选中了第 %ld 行！",indexPath.row);
    
}

@end
