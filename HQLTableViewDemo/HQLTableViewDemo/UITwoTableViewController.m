//
//  UITwoTableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2017/1/17.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "UITwoTableViewController.h"

#define leftTableWidth [UIScreen mainScreen].bounds.size.width * 0.3
#define rightTableWidth [UIScreen mainScreen].bounds.size.width * 0.7
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

static NSString * const LeftcellReusreIdentifier = @"LeftTableViewCell";
static NSString * const RightcellReusreIdentifier = @"RightTableViewCell";

@interface UITwoTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UITableView *rightTableView;

@end

@implementation UITwoTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加列表
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 初始化默认选中第一行
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.leftTableView selectRowAtIndexPath:firstIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - Custom Accessors

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        CGRect leftTableRect = CGRectMake(0, 0, leftTableWidth, screenHeight);
        _leftTableView = [[UITableView alloc] initWithFrame:leftTableRect];
        //        // 背景色
        //        _leftTableView.backgroundColor = bgColor;
        // 注册重用UITableViewCell
        [_leftTableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:LeftcellReusreIdentifier];
        // 需要遵守的协议
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        // 列表底部视图
        _leftTableView.tableFooterView = [UIView new];

    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        CGRect rightTableRect = CGRectMake(leftTableWidth, 64, rightTableWidth, screenHeight-64);
        _rightTableView = [[UITableView alloc] initWithFrame:rightTableRect];
        [_rightTableView registerClass:[UITableViewCell class]
                forCellReuseIdentifier:RightcellReusreIdentifier];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.tableFooterView = [UIView new];
    }
    return _rightTableView;
}

#pragma mark - UITableViewDataSource

// tableView要显示的section段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTableView) {
        return 1;
    }else {
        return 10;
    }
}

// section段显示的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return 10;
    }else {
        return 10;
    }
}

// 每段的标题
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 右侧 TableViewCell 显示标题
    if (tableView == self.rightTableView) {
        return [NSString stringWithFormat:@"第%ld组",section];
    }else {
        return nil;
    }
}

// 每行显示的的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;

    if (tableView == self.leftTableView) {
        // 左侧 TableViewCell
        cell = [tableView dequeueReusableCellWithIdentifier:LeftcellReusreIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    }else {
        // 右侧 TableViewCell
        cell = [tableView dequeueReusableCellWithIdentifier:RightcellReusreIdentifier forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld组:第%ld行",indexPath.section,indexPath.row + 1];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

// 点击cell后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 选中 左侧 的 tableView
    if (tableView == self.leftTableView) {
        // 取出左侧 tableView 的 row 作为右侧 tableView 的 section
        // NSNotFound:避免右边tableview只有标题没有数据时奔溃问题
        NSIndexPath *moveToIndexPath = [NSIndexPath indexPathForRow:NSNotFound inSection:indexPath.row];
//        // 将右侧 tableView 移动到指定位置
//        [self.rightTableView selectRowAtIndexPath:moveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//        // 取消选中效果
//        [self.rightTableView deselectRowAtIndexPath:moveToIndexPath animated:YES];
        // 上面两个方法用下面一个替换
        [self.rightTableView scrollToRowAtIndexPath:moveToIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

//任何偏移发生时调用：右边滑动时跟左边的联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 如果是 左侧的 tableView 发生偏移 ， return
    if (scrollView == self.leftTableView ) {
        return;
    }
    // 如果是 右侧的 tableView 发生偏移,要处理由用户引起的滚动 而不是由左侧tableView被点击后引起的滚动
    // 利用 scrollView 的三个属性判断 tableView 的滚动是否是由用户引起的:
    // !scrollView.dragging:用户滚动,返回YES 
    // scrollView.tracking：用户触摸，返回YES
    // scrollView.decelerating：如果用户未（向上）拖动但滚动视图仍在移动，则返回YES
    BOOL isUserTouch = scrollView.dragging || scrollView.tracking || scrollView.decelerating;
    if (!isUserTouch) {
        return;
    }
        // 取出显示在 视图 且最靠上 的 cell 的 indexPath
        NSIndexPath *topHeaderViewIndexpath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
        // 左侧 talbelView 移动的 indexPath
        NSIndexPath *moveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
        // 移动 左侧 tableView 到 指定 indexPath 选中状态并居中显示
        [self.leftTableView selectRowAtIndexPath:moveToIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

@end
