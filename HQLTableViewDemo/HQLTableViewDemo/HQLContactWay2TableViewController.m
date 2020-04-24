//
//  HQLContactWay2TableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/29.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLContactWay2TableViewController.h"
#import "HQLContact.h"
#import "HQLContactGroup.h"

#define HQLSearchBarHeight 44

@interface HQLContactWay2TableViewController ()<UISearchBarDelegate,UISearchResultsUpdating>

@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) NSMutableArray *contacts; //联系人数据源
@property (nonatomic,strong) NSMutableArray *searchContacts; // 符合条件的搜索联系人

@end

@implementation HQLContactWay2TableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据源
    [self initData];
    // 添加搜索框
    [self initSearchController];
    
    // 解决切换到下一个 View 中, 搜索框仍然会有短暂的存在的问题
    self.definesPresentationContext = YES;
    // 隐藏页脚视图分割线
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - Custom Accessors

// 重写状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// 初始化数据源
- (void)initData {
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

// 初始化searchController
- (void) initSearchController {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO; //设置是否在搜索时为整个页面显示半透明背景，默认YES
    _searchController.hidesNavigationBarDuringPresentation = NO; //设置是否在搜索时隐藏导航栏，默认YES
    
    // UISearchController 自带 searchBar
    CGRect searchBarRect = CGRectMake(0, 0, self.view.frame.size.width, HQLSearchBarHeight);
    _searchController.searchBar.frame = searchBarRect;
//    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.placeholder = @"请输入搜索内容...";
    
    _searchController.searchBar.keyboardType = UIKeyboardTypeAlphabet; //键盘样式
//    _searchController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo; // 关闭自动纠错
//    _searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone; // 首字母是否大写
    
    _searchController.searchBar.showsCancelButton = YES; //这个设置表示，一开始就显示取消按钮
    _searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = _searchController.searchBar;
}

#pragma mark - Privates;

// 搜索形成新数据
- (void)searchDataWithKeyWord:(NSString *)keyWord {

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
}

#pragma mark - UITableViewDataSource

// 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //搜索时，返回一组
    if (self.searchController.active) {
        return 1;
    }else {
        return _contacts.count;
    }
}

// 设置每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return _searchContacts.count;
    }else {
        HQLContactGroup *group = _contacts[section];
        return group.contacts.count;
    }
}

/*
 * 引入 UISearchController 之后, UITableView 的内容也要做相应地变动:
 * 即 cell 中要呈现的内容是 allCities, 还是 filteredCities.
 * 这一点, 可以通过 UISearchController 的 active 属性来判断, 即判断输入框是否处于 active 状态.
 * UITableView 相关的很多方法都要根据 active 来做判断:
 */

// 设置每行单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableViewCellStyleValue1 = @"UITableViewCellStyleValue1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellStyleValue1];
    if (!cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableViewCellStyleValue1];
    }
        // 搜索时，换数据源
        HQLContact *contact = nil;
        if (self.searchController.active) {
            contact =  self.searchContacts[indexPath.row];
        }else {
            // 数据源contacts -> 组数据group -> 行数据模型contact
            HQLContactGroup *group = _contacts [indexPath.section];
            contact = group.contacts [indexPath.row];
        }
    cell.textLabel.text = [contact geTName];
    cell.detailTextLabel.text = contact.phoneNumber;
    // 设置附件类型
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    return cell;
}

// 设置每组头标题
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        return nil;
    }else {
        HQLContactGroup *group = _contacts [section];
        return group.name;
    }
}

// 设置每组尾部说明
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.searchController.active) {
        return nil;
    }else {
        HQLContactGroup *group = _contacts [section];
        return group.detail;
    }
}

// 返回每组标题索引
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
    NSLog(@"%ld行被调用",indexPath.row);
}


#pragma mark - UISearchResultsUpdating

/*
 * 每次更新搜索框里的文字，就会调用这个方法
 *
 * 使用 UISearchController 要继承 UISearchResultsUpdating 协议, 实现其中的 UISearchResultsUpdating 方法.
 * UISearchController 的 searchBar 中的内容一旦发生变化, 就会调用该方法. 在其中, 我们可以使用 NSPredicate 来设置搜索过滤的条件.
 */

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = self.searchController.searchBar.text;
    // 使用自定义过滤方法
    [self searchDataWithKeyWord:searchString];
    
    // 使用NSPredicate设置搜索过滤条件
//    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchString];
//    if (self.searchContacts != nil) {
//        [self.searchContacts removeAllObjects];
//    }
//    // 过滤数据
//    self.searchContacts = [NSMutableArray arrayWithArray: [self.contacts filteredArrayUsingPredicate:searchPredicate]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


#pragma mark - UISearchControllerDelegate

// These methods are called when automatic presentation(展示结果) or dismissal(不展示结果) occurs. They will not be called if you present or dismiss the search controller yourself.
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
