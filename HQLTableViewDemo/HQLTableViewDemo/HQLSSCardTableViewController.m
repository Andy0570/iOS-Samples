//
//  HQLSSCardTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/12/28.
//  Copyright © 2018 ToninTech. All rights reserved.
//

#import "HQLSSCardTableViewController.h"

// Frameworks
#import <MGSwipeTableCell.h>
#import <MGSwipeButton.h>
#import <YYKit.h>
#import <MJRefresh.h>

// View
#import "HQLSSCardTableViewCell.h"
#import "HQLSSCardTableViewCell+ConfigureModel.h"
#import "HQLSSCardHeaderView.h"

// Model
#import "HQLSSCardModel.h"

static NSString * const cellReuseIdentifier = @"HQLSSCardTableViewCell";

@interface HQLSSCardTableViewController () <MGSwipeTableCellDelegate>

@property (nonatomic, readwrite, strong) NSMutableArray *dataSourceArray;

@end

@implementation HQLSSCardTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化列表
    [self setupTableView];
    
    // 导航栏右侧添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigationRightBarButtonDidClicked:)];
}

#pragma mark - Custom Accessors

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SSCardDataSource" ofType:@"plist"];
        NSArray *jsonArray = [NSArray arrayWithContentsOfFile:path];
        _dataSourceArray = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[HQLSSCardModel class] json:jsonArray]];
    }
    return _dataSourceArray;
}

#pragma mark - IBActions

- (void)navigationRightBarButtonDidClicked:(id)sender {
    NSLog(@"add SSCard!!!");
}

#pragma mark - Private

- (void)setupTableView {
    [self.tableView registerClass:[HQLSSCardTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    self.tableView.rowHeight = HQLSSCardTableViewCellHeight;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    // 设置下拉刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestSSCardDataSource)];
    // 立即刷新
    [self.tableView.mj_header beginRefreshing];
}

// 发起网络请求，获取卡包数据源
- (void)requestSSCardDataSource {
    // 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 主队列刷新 UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HQLSSCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    cell.delegate = self; // <MGSwipeTableCellDelegate>
    HQLSSCardModel *model = self.dataSourceArray[indexPath.row];
    [cell hql_configureForModel:model];
    
    return cell;
}

// 表尾设置
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"注：每个参保人员最多可以绑定5张副卡。";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 刷新卡包「使用中」标记
    [self.dataSourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HQLSSCardModel *cardModel = obj;
        BOOL isSelectedCard = (long)indexPath.row == idx;
        cardModel.isCardUsing = isSelectedCard;
    }];
    [self.tableView reloadData];
    
    // ⚠️ 更改 APP 应用状态
}

// 表头设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HQLSSCardHeaderViewHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HQLSSCardHeaderView *headerView = [[HQLSSCardHeaderView alloc] initWithFrame:CGRectZero];
    return headerView;
}

#pragma mark - MGSwipeTableCellDelegate

-(BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction fromPoint:(CGPoint) point {
    
    // 主卡不允许删除
    BOOL isMasterCard = [self.tableView indexPathForCell:cell].row == 0;
    return !isMasterCard;
}


/**
 * Delegate method to setup the swipe buttons and swipe/expansion settings
 * Buttons can be any kind of UIView but it's recommended to use the convenience MGSwipeButton class
 * Setting up buttons with this delegate instead of using cell properties improves memory usage because buttons are only created in demand
 * @param cell the UITableViewCell to configure. You can get the indexPath using [tableView indexPathForCell:cell]
 * @param direction The swipe direction (left to right or right to left)
 * @param swipeSettings instance to configure the swipe transition and setting (optional)
 * @param expansionSettings instance to configure button expansions (optional)
 * @return Buttons array
 **/
-(nullable NSArray<UIView*>*) swipeTableCell:(nonnull MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
                               swipeSettings:(nonnull MGSwipeSettings*) swipeSettings expansionSettings:(nonnull MGSwipeExpansionSettings*) expansionSettings {
    
    if (direction == MGSwipeDirectionRightToLeft) {
        // MGSwipeSettings 按钮设置
        swipeSettings.transition = MGSwipeTransitionBorder;
        swipeSettings.keepButtonsSwiped = YES;
        
        // MGSwipeExpansionSettings 拉伸设置
        expansionSettings.buttonIndex = 0;
        expansionSettings.fillOnTrigger = NO; // 拉伸时是否填充整个 cell
        expansionSettings.threshold = 2.0;
        
        // 删除按钮
        CGFloat padding = 20;
        MGSwipeButton *trashButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"trash"] backgroundColor:[UIColor clearColor] padding:padding];
        return @[trashButton];
    }
    return nil;
}

/**
 * 当用户单击滑动按钮或可展开按钮被自动自动触发时调用
 * Called when the user clicks a swipe button or when a expandable button is automatically triggered
 * @return YES to autohide the current swipe buttons
 **/
-(BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    
    // 删除按钮触发事件
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        // 这里直接删除，业务层还需要做删除前的提示和判断的！！！
        // 1. 主卡不能删除
        // 2. 如果是副卡，且副卡正在使用中，副卡删除后，主卡切换为正在使用中。
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.dataSourceArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
        return NO;
    }
    return YES;
}

@end
