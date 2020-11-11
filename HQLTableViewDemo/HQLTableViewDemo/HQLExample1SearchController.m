//
//  HQLExample1SearchController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLExample1SearchController.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLExample1SearchController () <UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *dataList;   // 原始数据
@property (nonatomic, strong) NSMutableArray *searchList; // 搜索数据
@end

@implementation HQLExample1SearchController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 解决退出时搜索框依然存在的问题
    self.definesPresentationContext = YES;
    
    if (@available(iOS 11,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupTableView];
    
    // !!!: 修改搜索框右侧取消按钮标题 Cancel 为中文
    // 修改按钮标题文字属性( 颜色, 大小, 字体)
//    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:17.0f]} forState:UIControlStateNormal];
     // 修改标题文字
     [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];
}

- (void)setupTableView {
    // 将searchBar 赋值给 tableView 的 tableHeaderView
    self.tableView.tableHeaderView = self.searchController.searchBar;
    // 注册重用 cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
}

#pragma mark - Custom Accessors

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        // 设置结果更新代理
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        
        // 设置是否在搜索时为整个页面显示半透明背景
        // 因为在当前控制器展示结果, 所以不需要这个透明视图
        _searchController.obscuresBackgroundDuringPresentation = NO;
        
        // 设置是否在搜索时隐藏导航栏
        _searchController.hidesNavigationBarDuringPresentation = NO;
        
        // searchBar
        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
        _searchController.searchBar.placeholder = @"请输入内容";
        _searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
        _searchController.searchBar.delegate = self;
        
        // 提示语
        // _searchController.searchBar.prompt = @"prompt";
        
        // 一开始就显示取消按钮，默认正在搜索时也会显示取消按钮
        // _searchController.searchBar.showsCancelButton = YES;
        // _searchController.searchBar.showsBookmarkButton = YES;
        // _searchController.searchBar.showsSearchResultsButton = YES;
        
        // scopeBar
        // _searchController.searchBar.showsScopeBar = YES;
        // _searchController.searchBar.scopeButtonTitles = @[@"Item1", @"Item2", @"Item3"];
    }
    return _searchController;
}

- (NSMutableArray *) dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:100];
        for (NSInteger i=0; i<100; i++) {
            [_dataList addObject:[NSString stringWithFormat:@"%ld-FlyElephant",(long)i]];
        }
    }
    return _dataList;
}

- (NSMutableArray *) searchList {
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.isActive) {
        return self.searchList.count;
    } else {
        return self.dataList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    if (self.searchController.isActive) {
        cell.textLabel.text = self.searchList[indexPath.row];
    } else {
        cell.textLabel.text = self.dataList[indexPath.row];
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // !!!: cell.textLabel.text 中的数据源可能来自 _dataList，也可能来自 _searchList
    self.searchController.searchBar.text = cell.textLabel.text;
}

#pragma mark - UISearchResultsUpdating

// 每次更新搜索框里的文字，就会调用这个方法
// 根据输入的关键词及时响应：里面可以实现筛选逻辑  也显示可以联想词
// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"%s",__func__);
    
    // 获取搜索框里的字符串
    NSString *searchString = searchController.searchBar.text;
    
    /**
     谓词
     
     1.BEGINSWITH ： 搜索结果的字符串是以搜索框里的字符开头的
     2.ENDSWITH   ： 搜索结果的字符串是以搜索框里的字符结尾的
     3.CONTAINS   ： 搜索结果的字符串包含搜索框里的字符
     
     [c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
     */
    
    // 创建谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchString];
    
    if (!self.searchList) {
        [self.searchList removeAllObjects];
    }
    
    // 过滤数据
    self.searchList = [[_dataList filteredArrayUsingPredicate:predicate] mutableCopy];
    
    // 刷新列表
    [self.tableView reloadData];
}

#pragma mark - UISearchControllerDelegate

// These methods are called when automatic presentation or dismissal occurs. They will not be called if you present or dismiss the search controller yourself.
- (void)willPresentSearchController:(UISearchController *)searchController {
    NSLog(@"%s",__func__);
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    NSLog(@"%s",__func__);
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    NSLog(@"%s",__func__);
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    NSLog(@"%s",__func__);
}

// Called after the search controller's search bar has agreed to begin editing or when 'active' is set to YES. If you choose not to present the controller yourself or do not implement this method, a default presentation is performed on your behalf.
- (void)presentSearchController:(UISearchController *)searchController {
    NSLog(@"%s",__func__);
}

#pragma mark UISearchBarDelegate

// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
    return YES;
}

// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"%s",__func__);
    NSLog(@"searchBar.text = %@",searchBar.text);
    [self.tableView reloadData];
}

// return NO to not resign first responder
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    NSLog(@"%s",__func__);
    return YES;
}

// called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"%s",__func__);
    NSLog(@"searchBar.text = %@",searchBar.text);
}

// called before text changes
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%s",__func__);
    NSLog(@"searchBar.text = %@",searchBar.text);
    return YES;
}

// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%s",__func__);
    NSLog(@"searchBar.text = %@",searchBar.text);
}

// called when keyboard search button pressed 键盘搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s",__func__);
    NSLog(@"searchBar.text = %@",searchBar.text);
    if (!self.searchController.active) {
        [self.tableView reloadData];
    }
    [self.searchController.searchBar resignFirstResponder];
}

// called when bookmark button pressed
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
    [self.tableView reloadData];
}

// called when search results button pressed
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
}

// selecte ScopeButton
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    NSLog(@"%s",__func__);
    NSLog(@"selectedScope = %ld",selectedScope);
}

@end
