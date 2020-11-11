//
//  HQLExample2SearchController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLExample2SearchController.h"
#import "SearchResultTableViewController.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLExample2SearchController () <UISearchControllerDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultTableViewController *resultVC;
@property (nonatomic, strong) NSMutableArray *dataList;   // 原始数据
@end

@implementation HQLExample2SearchController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 解决退出时搜索框依然存在的问题
    self.definesPresentationContext = YES;
    
    if (@available(iOS 11,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    [self setupTableView];
        
    // 修改标题文字
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];
}

- (void)setupTableView {
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
}

#pragma mark - Custom Accessors

- (UISearchController *)searchController {
    if (!_searchController) {
        // !!!: 结果页面展示搜索结果
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
        _searchController.searchResultsUpdater = self.resultVC;
        _searchController.delegate = self;
        
        // 设置是否在搜索时为整个页面显示半透明背景
        _searchController.obscuresBackgroundDuringPresentation = YES;
        
        // 设置是否在搜索时隐藏导航栏
        _searchController.hidesNavigationBarDuringPresentation = YES;
        
        // searchBar
        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
        _searchController.searchBar.placeholder = @"请输入内容";
        _searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
        _searchController.searchBar.delegate = self;
        [_searchController.searchBar sizeToFit];
        
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

- (SearchResultTableViewController *)resultVC {
    if (!_resultVC) {
        _resultVC = [[SearchResultTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _resultVC.dataList = self.dataList;
    }
    return _resultVC;
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
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
