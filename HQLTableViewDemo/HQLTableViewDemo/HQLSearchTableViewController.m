//
//  HQLSearchTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/5/4.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "HQLSearchTableViewController.h"

@interface HQLSearchTableViewController () <UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *dataList;   // 原始数据
@property (nonatomic, strong) NSMutableArray *searchList; // 搜索数据

@end

@implementation HQLSearchTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // 解决退出时搜索框依然存在的问题
    self.definesPresentationContext = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors

// 初始化搜索控制器
- (UISearchController *)searchController {
    if (!_searchController) {
        // searchController
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self; // UISearchControllerDelegate
//        _searchController.dimsBackgroundDuringPresentation = NO; //设置是否在搜索时为整个页面显示半透明背景
//        _searchController.hidesNavigationBarDuringPresentation = NO; //设置是否在搜索时隐藏导航栏
        
        // searchBar
//        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        _searchController.searchBar.placeholder = @"请输入内容";
//        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//        _searchController.searchBar.prompt = @"prompt"; // 提示语
        
//        _searchController.searchBar.showsCancelButton = YES; // 一开始就显示取消按钮，默认正在搜索时也会显示取消按钮
//        _searchController.searchBar.showsBookmarkButton = YES;
//        _searchController.searchBar.showsSearchResultsButton = YES;
        
        // scopeBar
//        _searchController.searchBar.showsScopeBar = YES;
//        _searchController.searchBar.scopeButtonTitles = @[@"Item1", @"Item2", @"Item3"];
        
//        _searchController.searchBar.delegate = self; // UISearchBarDelegate
        
    }
    return _searchController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // when selected row of indexPath
    
}

#pragma mark - UISearchResultsUpdating

// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"%s",__func__);
    
    // 获取搜索框里的字符串
    NSString *searchString = searchController.searchBar.text;
    NSLog(@"%@",searchString);
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

@end
