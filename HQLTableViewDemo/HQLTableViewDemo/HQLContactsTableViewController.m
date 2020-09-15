//
//  HQLContactsTableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/29.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLContactsTableViewController.h"

// Models
#import "HQLContact.h"
#import "HQLContactGroup.h"

#define HQLSearchBarHeight 44

@interface HQLContactsTableViewController () <UISearchBarDelegate> {
    UISearchBar *_searchBar;
    NSMutableArray *_contacts;       // 联系人数据源模型
    NSMutableArray *_searchContacts; // 符合条件的搜索联系人
    BOOL _isSearching;               // 搜索状态，显示原始数据还是搜索匹配数据
}

@end

@implementation HQLContactsTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    
    [self loadContactsData]; // 加载联系人数据源
    [self addSearchBar];     // 添加搜索框
    
    // 隐藏页脚视图分割线
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - Custom Accessors

// 重写状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

// 初始化数据源
- (void)loadContactsData {
    _contacts = [[NSMutableArray alloc] init];
    // 第一组
    HQLContact *contacts1 = [HQLContact initWithFirstName:@"Cui" lastName:@"kenshin" phoneNumber:@"18500131236"];
    HQLContact *contacts2 = [HQLContact initWithFirstName:@"Cui" lastName:@"Tom" phoneNumber:@"18500131237"];
    HQLContactGroup *group1 = [HQLContactGroup initWithName:@"C" detail:@"以C开头的姓氏" contacts:[NSMutableArray arrayWithObjects:contacts1,contacts2, nil]];
    [_contacts addObject:group1];
    // 第二组
    HQLContact *contact3=[HQLContact initWithFirstName:@"Lee" lastName:@"Terry" phoneNumber:@"18500131238"];
    HQLContact *contact4=[HQLContact initWithFirstName:@"Lee" lastName:@"Jack" phoneNumber:@"18500131239"];
    HQLContact *contact5=[HQLContact initWithFirstName:@"Lee" lastName:@"Rose" phoneNumber:@"18500131240"];
    HQLContactGroup *group2=[HQLContactGroup initWithName:@"L" detail:@"以L开头的姓氏" contacts:[NSMutableArray arrayWithObjects:contact3,contact4,contact5, nil]];
    [_contacts addObject:group2];
    // 第三组
    HQLContact *contact6=[HQLContact initWithFirstName:@"Sun" lastName:@"Kaoru" phoneNumber:@"18500131241"];
    HQLContact *contact7=[HQLContact initWithFirstName:@"Sun" lastName:@"Rosa" phoneNumber:@"18500131242"];
    HQLContactGroup *group3=[HQLContactGroup initWithName:@"S" detail:@"以S开头的姓氏" contacts:[NSMutableArray arrayWithObjects:contact6,contact7, nil]];
    [_contacts addObject:group3];
    // 第四组
    HQLContact *contact8=[HQLContact initWithFirstName:@"Zhang" lastName:@"San" phoneNumber:@"18500131243"];
    HQLContact *contact9=[HQLContact initWithFirstName:@"Zhang" lastName:@"Fei" phoneNumber:@"18500131244"];
    HQLContact *contact10=[HQLContact initWithFirstName:@"Zhang" lastName:@"Long" phoneNumber:@"18500131245"];
    HQLContactGroup *group4=[HQLContactGroup initWithName:@"Z" detail:@"以Z开头的姓氏" contacts:[NSMutableArray arrayWithObjects:contact8,contact9,contact10, nil]];
    [_contacts addObject:group4];
    // 第五组
    HQLContact *contact11=[HQLContact initWithFirstName:@"Yang" lastName:@"yang" phoneNumber:@"18500131243"];
    HQLContact *contact12=[HQLContact initWithFirstName:@"Yang" lastName:@"da" phoneNumber:@"18500131244"];
    HQLContact *contact13=[HQLContact initWithFirstName:@"Yang" lastName:@"er" phoneNumber:@"18500131245"];
    HQLContact *contact14=[HQLContact initWithFirstName:@"Yang" lastName:@"zhicheng" phoneNumber:@"18500131244"];
    HQLContact *contact15=[HQLContact initWithFirstName:@"Yang" lastName:@"zongwei" phoneNumber:@"18500131245"];
    HQLContactGroup *group5=[HQLContactGroup initWithName:@"Y" detail:@"以Y开头的姓氏" contacts:[NSMutableArray arrayWithObjects:contact11,contact12,contact13,contact14,contact15, nil]];
    [_contacts addObject:group5];
}


// !!!: 初始化并添加 UISearchBar
- (void)addSearchBar {
    CGRect searchBarRect = CGRectMake(0, 0, self.view.frame.size.width, HQLSearchBarHeight);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:searchBarRect];
    searchBar.placeholder = @"请输入搜索内容";
    
    // 💡 键盘样式
    // searchBar.keyboardType = UIKeyboardTypeAlphabet;
    
    // 💡 自动纠错类型
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // 💡 键盘对输入字母的控制
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    // 💡 显示取消按钮，默认值为 NO
    // 注意：通常取消按钮的显示是在代理方法中设置其显示或隐藏，而不是在初始化时就设置基显示
    // _searchBar.showsCancelButton = YES;
    
    // 💡 显示搜索结果按钮，在搜索框右侧显示一个下拉菜单
    // 注意：书签按钮属性与搜索回车按钮属性不能同时进行设置，只能二选一，否则会出现冲突
     _searchBar.showsSearchResultsButton = YES;
    
    // 💡 显示书签按钮 📖，默认值为 NO
    // 注意：书签按钮属性与搜索回车按钮属性不能同时进行设置，只能二选一，否则会出现冲突
    // searchBar.showsBookmarkButton = NO;
    
    // 💡 修改搜索框上所有子控件的颜色
    // 注：tint color 会影响搜索框中的光标的颜色
    //searchBar.tintColor = [UIColor redColor];
    
    // 💡 设置搜索框背景颜色
    // searchBar.barTintColor = [UIColor greenColor];
    
    searchBar.delegate = self;
    
    // 将搜索框设置为 tableView 的 headerView
    _searchBar = searchBar;
    self.tableView.tableHeaderView = _searchBar;
}


#pragma mark - Private

// !!!: 搜索形成新数据
- (void)searchDataWithKeyWord:(NSString *)keyWord {
    _isSearching = YES;
    _searchContacts = [NSMutableArray array];
    [_contacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HQLContactGroup *group = obj;
        [group.contacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HQLContact *contact = obj;
            // 查询数据源字符串中是否包含查找的字符串（全部大写后查找）
            BOOL isFirstNameContain = [contact.firstName.uppercaseString containsString:keyWord.uppercaseString];
            BOOL isLastNameContain = [contact.lastName.uppercaseString containsString:keyWord.uppercaseString];
            BOOL isPhoneConain = [contact.phoneNumber containsString:keyWord];
            if (isFirstNameContain || isLastNameContain || isPhoneConain) {
                [_searchContacts addObject:contact];
            }
        }];
    }];
    // 刷新列表
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

// 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 正在搜索中，返回1段
    if (_isSearching) {
        return 1;
    } else {
        return _contacts.count;
    }
}

// 设置每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isSearching) {
        return _searchContacts.count;
    } else {
        HQLContactGroup *group = _contacts[section];
        return group.contacts.count;
    }
}

// 设置每行单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 搜索时，换数据源
    HQLContact *contact = nil;
    if (_isSearching) {
        contact =  _searchContacts[indexPath.row];
    }else {
        // 数据源contacts -> 组数据group -> 行数据模型contact
        HQLContactGroup *group = _contacts [indexPath.section];
        contact = group.contacts[indexPath.row];
    }
    
    // 重用cell
    static NSString *tableViewCellStyleValue1 = @"UITableViewCellStyleValue1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellStyleValue1];
    if (!cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableViewCellStyleValue1];
    }
    cell.textLabel.text = [contact getFullName];
    cell.detailTextLabel.text = contact.phoneNumber;
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    return cell;
}

// 设置每组头标题
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    HQLContactGroup *group = _contacts [section];
    return group.name;
}

// 设置每组尾部说明
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    HQLContactGroup *group = _contacts [section];
    return group.detail;
}

// 在 TableView 列表右侧显示每组标题的小索引
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *indexs = [[NSMutableArray alloc] init];
    for (HQLContactGroup *group in _contacts) {
        [indexs addObject:group.name];
    }
    return indexs;
}


#pragma mark - UITableViewDelegate

// 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

// 设置分组标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }else {
        return 20;
    }
}

// 设置尾部标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 22;
}

// 点击行调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld行被调用",(long)indexPath.row);
}


#pragma mark - UISearchBarDelegate

// 1. 将要开始编辑文本时调用该方法，返回 NO 则不让搜索框成为第一响应者
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

// 2. 开始输入文本时会调用该方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"我要开始输入内容了！");
    [_searchBar setShowsCancelButton:YES animated:YES];
}

// 3. 将要结束编辑文本时会调用该方法，返回 NO 则不让搜索框释放第一响应者
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

// 4. 结束编辑文本时调用该方法
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"我已经结束编辑！");
    [_searchBar setShowsCancelButton:NO animated:YES];
}

// 5. 文本改变会调用该方法（包含 clear 清空文本）
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // 没有任何文字，则显示所有数据
    if (_searchBar.text.length == 0) {
        // 当搜索框内容为空，显示所有数据
        _isSearching = NO;
        [self.tableView reloadData];
        return;
    }
    
    // 搜索数据并更新列表
    [self searchDataWithKeyWord:_searchBar.text];
}

// 6. 文字改变前会调用该方法，返回 NO 则不能加入新的编辑文字
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // 通常用于那些指定输入文本内容的搜索，比如搜索电话号码时，只能输入数字，不能输入文字的情况！
    NSLog(@"文字被输进去之前调用");
    return YES;
}

// 7. 虚拟键盘上的搜索按钮被触发
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar; {
    [self searchDataWithKeyWord:_searchBar.text];
    // 放弃第一响应者状态，关闭虚拟键盘
    [_searchBar resignFirstResponder];
}

// 8. 搜索框右侧图书按钮点击会调用该方法
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// 9. 取消搜索按钮被触发
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar  {
    _isSearching = NO;
    _searchBar.text = @"";
    // 放弃第一响应者状态，关闭虚拟键盘
    [_searchBar resignFirstResponder];
    // 重新加载数据
    [self.tableView reloadData];
}

// 10. 搜索结果列表按钮被按下会调用该方法
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// 11. 搜索框的附属按钮视图中切换按钮会调用该方法
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
