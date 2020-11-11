//
//  SearchResultTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "SearchResultTableViewController.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface SearchResultTableViewController ()
@property (nonatomic, strong) NSMutableArray *searchResults; // 搜索数据
@end

@implementation SearchResultTableViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索结果";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.searchResults[indexPath.row];
    return cell;
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
    
    if (!self.searchResults && searchString.length > 0) {
        [self.searchResults removeAllObjects];
        
        // 过滤数据
        self.searchResults = [[_dataList filteredArrayUsingPredicate:predicate] mutableCopy];
    } else if (searchString.length == 0) {
        self.searchResults = [NSMutableArray arrayWithArray:_dataList];
    }

    // 显示搜索结果
    [self.tableView reloadData];
}

@end
