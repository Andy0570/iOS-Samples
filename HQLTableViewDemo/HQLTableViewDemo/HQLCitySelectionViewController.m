//
//  HQLCitySelectionViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCitySelectionViewController.h"

// Framework
#import <YYKit.h>
#import <Chameleon.h>
#import <Masonry.h>
#import "BMChineseSort.h"
#import "ZYPinYinSearch.h"
#import "STSearchBar.h"

// View
#import "HQLCurrentLocationCityView.h"
#import "HQLHotCityTableViewCell.h"
#import "HQLCitySelectionHeaderView.h"
#import "HQLCityTableViewCell.h"
#import "HQLTableIndexView.h"

// Model
#import "HQLCity.h"

static NSString * const headerReuseIdentifier = @"HQLCitySelectionHeaderView";
static NSString * const hotCityCellReuseIdentifier = @"HQLHotCityTableViewCell";
static NSString * const cityCellReuseIdentifier = @"HQLCityTableViewCell";

@interface HQLCitySelectionViewController () <UITableViewDataSource, UITableViewDelegate, STSearchBarDelegate>

@property (nonatomic, strong) STSearchBar *searchBar;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) UITableView *cityTableview;
@property (nonatomic, strong) HQLCurrentLocationCityView *currentLocationCityView;
@property (nonatomic, strong) HQLTableIndexView *tableIndexView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) NSArray<HQLCity *> *cities;
@property (nonatomic, strong) NSArray<HQLCity *> *hotCities;

@property (nonatomic, strong) NSMutableArray *indexNames;
@property (nonatomic, strong) NSMutableArray *groupedCities;

@property (nonatomic, strong) NSMutableArray *mutableArray2; // ???: 不明数据？
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *mDataArray;

@property (nonatomic, strong) NSMutableDictionary *buffList;

@end

@implementation HQLCitySelectionViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择城市";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    // 对城市名称进行排序
    __weak __typeof(self)weakSelf = self;
    [BMChineseSort sortAndGroup:self.cities key:@"first_char" finish:^(bool isSuccess, NSMutableArray *unGroupedArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (isSuccess) {
            // 排序好的分组索引、分组数据
            strongSelf.indexNames = [sectionTitleArr mutableCopy];
            [strongSelf.indexNames insertObject:@"热门" atIndex:0];
            strongSelf.groupedCities = sortedObjArr;
            
            strongSelf.tableIndexView.indexNames = strongSelf.indexNames;
            [strongSelf.cityTableview reloadData];
        }
    }];
}

- (void)setupUI {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.currentLocationCityView];
    [self.view addSubview:self.cityTableview];
    [self.view addSubview:self.tableIndexView];
    
    [self.tableIndexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.cityTableview.mas_centerY);
        make.height.mas_equalTo(self.cityTableview.mas_height);
        make.width.mas_equalTo(40);
    }];
}

#pragma mark - Custom Accessors

- (STSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[STSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.delegate = self;
        _searchBar.font = [UIFont systemFontOfSize:14];
        _searchBar.placeholderColor = HexColor(@"aaaaaa");
        _searchBar.placeholder = @"输入城市名、拼音或首字母查询";
    }
    return _searchBar;
}

- (HQLCurrentLocationCityView *)currentLocationCityView {
    if (!_currentLocationCityView) {
        CGRect frame = CGRectMake(0, self.searchBar.bottom, kScreenWidth, 48);
        _currentLocationCityView = [[HQLCurrentLocationCityView alloc] initWithFrame:frame];
        
        __weak __typeof(self)weakSelf = self;
        _currentLocationCityView.currentLocationCityButtonAction = ^(NSString * _Nonnull cityName) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [strongSelf.cities enumerateObjectsUsingBlock:^(HQLCity *currentCity, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([currentCity.name isEqualToString:cityName]) {
                    if (strongSelf.citySelectionBlock) {
                        strongSelf.citySelectionBlock(currentCity.code, currentCity.name);
                    }
                    *stop = YES;
                }
            }];
        };
    }
    return _currentLocationCityView;
}

- (UITableView *)cityTableview {
    if (!_cityTableview) {
        CGRect frame = CGRectMake(0, self.currentLocationCityView.bottom, kScreenWidth, kScreenHeight - self.currentLocationCityView.bottom);
        _cityTableview = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _cityTableview.backgroundColor = rgb(244, 244, 244);
        _cityTableview.delegate  = self;
        _cityTableview.dataSource = self;
        _cityTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_cityTableview registerClass:HQLCitySelectionHeaderView.class forHeaderFooterViewReuseIdentifier:headerReuseIdentifier];
        [_cityTableview registerClass:HQLHotCityTableViewCell.class
               forCellReuseIdentifier:hotCityCellReuseIdentifier];
        [_cityTableview registerNib:[UINib nibWithNibName:NSStringFromClass(HQLCityTableViewCell.class) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cityCellReuseIdentifier];
    }
    return _cityTableview;
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, kScreenWidth, kScreenHeight - self.searchBar.bottom - 64) style:UITableViewStylePlain];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_searchTableView registerNib:[UINib nibWithNibName:NSStringFromClass(HQLCityTableViewCell.class) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cityCellReuseIdentifier];
        
    }
    return _searchTableView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, kScreenWidth, kScreenHeight)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.5;
    }
    return _maskView;
}

- (HQLTableIndexView *)tableIndexView {
    if (!_tableIndexView) {
        _tableIndexView = [[HQLTableIndexView alloc] initWithFrame:CGRectZero];
        // 滑动 _tableIndexView 时，实现 tableView 的联动效果
        __weak __typeof(self)weakSelf = self;
        _tableIndexView.selectedBlock = ^(NSInteger index) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
            [weakSelf.cityTableview selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        };
    }
    return _tableIndexView;
}

- (NSArray<HQLCity *> *)cities {
    if (!_cities) {
        // 1.构造文件路径
        NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        NSURL *url = [bundleURL URLByAppendingPathComponent:@"CityArray.json"];
        // 2.将文件数据化
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        NSError *readFileError = nil;
        // 3.对数据进行 JSON 格式化并返回字典形式
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&readFileError];
        NSAssert1(jsonArray, @"JSON File read error:\n%@", readFileError);
        // 4.将 JSON 数据转换为 Model
        _cities = [NSArray modelArrayWithClass:HQLCity.class json:jsonArray];
    }
    return _cities;
}

- (NSArray<HQLCity *> *)hotCities {
    if (!_hotCities) {
        // 1.构造文件路径
        NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        NSURL *url = [bundleURL URLByAppendingPathComponent:@"HotCityArray.json"];
        // 2.将文件数据化
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        NSError *readFileError = nil;
        // 3.对数据进行 JSON 格式化并返回字典形式
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&readFileError];
        NSAssert1(jsonArray, @"JSON File read error:\n%@", readFileError);
        // 4.将 JSON 数据转换为 Model
        _hotCities = [NSArray modelArrayWithClass:HQLCity.class json:jsonArray];
    }
    return _hotCities;
}

- (NSMutableDictionary *)buffList{
    if (!_buffList) {
        _buffList = [NSMutableDictionary dictionaryWithCapacity:self.cities.count];
        [self.cities enumerateObjectsUsingBlock:^(HQLCity *currentCity, NSUInteger idx, BOOL * _Nonnull stop) {
            [_buffList setObject:currentCity.code forKey:currentCity.name];
        }];
    }
    return _buffList;
}

- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _searchArray;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchTableView) {
        return 1;
    } else {
        return self.indexNames.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchTableView) {
        return (self.searchArray.count == 0) ? 1 : self.searchArray.count;
    } else {
        if (section == 0) {
            // 热门城市
            return 1;
        } else {
            NSArray *currentGroupedCities = self.groupedCities[section - 1];
            return currentGroupedCities.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTableView) {
        
        HQLCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellReuseIdentifier forIndexPath:indexPath];
        if (self.searchArray.count == 0) {
            cell.cityName = @"抱歉，未找到相关城市，请尝试修改后重试";
        } else {
            HQLCity *currentCity = self.searchArray[indexPath.row];
            cell.cityName = currentCity.name;
        }
        return cell;
        
    } else if (tableView == self.cityTableview ) {
        if (indexPath.section == 0) {
            // 热门城市
            HQLHotCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotCityCellReuseIdentifier forIndexPath:indexPath];
            cell.hotCities = self.hotCities;
            cell.hotCityButtonAction = ^(NSString * _Nonnull cityCode, NSString * _Nonnull cityName) {
                if (self.citySelectionBlock) {
                    self.citySelectionBlock(cityCode, cityName);
                }
            };
            return cell;
        } else {
            // 普通城市
            HQLCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellReuseIdentifier forIndexPath:indexPath];
            HQLCity *currentCity = self.groupedCities[indexPath.section - 1][indexPath.row];
            cell.cityName = currentCity.name;
            return cell;
        }
    } else {
        return nil;
    }
}

#pragma mark - <UITableViewDelegate>

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.cityTableview) {
        // 城市分组名称
        HQLCitySelectionHeaderView *headerView = [self.cityTableview dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
        if (section == 0) {
            headerView.headerTitle = @"热门城市";
        } else {
            headerView.headerTitle = self.indexNames[section];
        }
        return headerView;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchTableView) {
        return 0.00001;
    }else{
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTableView) {
        return 48;
    } else if (tableView == self.cityTableview ) {
        return (indexPath.section == 0) ? 192 : 48;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.searchTableView) {
        if (self.searchArray.count == 0) {
            return;
        }
        
        HQLCity *currentCity = self.searchArray[indexPath.row];
        if (self.citySelectionBlock) {
            self.citySelectionBlock(currentCity.code, currentCity.name);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if (tableView == self.cityTableview) {
        
        HQLCity *currentCity = self.groupedCities[indexPath.section -1][indexPath.row];
        if (self.citySelectionBlock) {
            self.citySelectionBlock(currentCity.code, currentCity.name);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark - <STSearchBarDelegate>

-(BOOL)searchBarShouldBeginEditing:(STSearchBar *)searchBar{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(STSearchBar *)searchBar {
    [self.view addSubview:self.maskView];
}
    

- (BOOL)searchBarShouldEndEditing:(STSearchBar *)searchBar{
    return YES;
}

- (void)searchBarTextDidEndEditing:(STSearchBar *)searchBar{
    [self.maskView removeFromSuperview];
}

// called when text changes (including clear)
- (void)searchBar:(STSearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isNotBlank]) {
        
        __weak __typeof(self)weakSelf = self;
        [ZYPinYinSearch searchByPropertyName:@"name" withOriginalArray:self.cities searchText:searchText success:^(NSArray *results) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [strongSelf.searchArray removeAllObjects];
            
            strongSelf.searchArray = [NSMutableArray arrayWithArray:results];
            [strongSelf.view addSubview:self.searchTableView];
            [self.searchTableView reloadData];
            
        } failure:^(NSString *errorMessage) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [strongSelf.searchArray removeAllObjects];
            [strongSelf.searchTableView removeFromSuperview];
        }];
    } else {
        [self.searchTableView removeFromSuperview];
    }
}

// called before text changes
- (BOOL)searchBar:(STSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(STSearchBar *)searchBar {
    if ([searchBar.text isNotBlank]) {
        
        __weak __typeof(self)weakSelf = self;
        [ZYPinYinSearch searchByPropertyName:@"name" withOriginalArray:self.cities searchText:searchBar.text success:^(NSArray *results) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [strongSelf.searchArray removeAllObjects];
            
            strongSelf.searchArray = [NSMutableArray arrayWithArray:results];
            [strongSelf.view addSubview:self.searchTableView];
            [self.searchTableView reloadData];
            
        } failure:^(NSString *errorMessage) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [strongSelf.searchArray removeAllObjects];
            [strongSelf.searchTableView removeFromSuperview];
        }];
    } else {
        [self.searchTableView removeFromSuperview];
    }
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(STSearchBar *)searchBar {
    [self.maskView removeFromSuperview];
    [self.searchTableView removeFromSuperview];
}


@end
