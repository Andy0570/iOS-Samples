//
//  HQLCityPickerController.m
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/1/30.
//

#import "HQLCityPickerController.h"

// Framework
#import "BMChineseSort.h"
#import "ZYPinYinSearch.h"

// Controller
#import "HQLCityPickerSearchResultController.h"

// View
#import "HQLHotCityTableViewCell.h"

// Model
#import "HQLProvince.h"

// Utils
#import "HQLLocationManager.h"
#import "HQLPropertyListStore.h"

static NSString * const KCityJSONFileName = @"City.json";
static NSString * const KHotCityJSONFileName = @"HotCity.json";
static NSString * const hotCityCellReuseIdentifier = @"HQLHotCityTableViewCell";
static NSString * const defaultCityCellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLCityPickerController () <UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) HQLCityPickerSearchResultController *searchResultController;

@property (nonatomic, strong) HQLCity *currentCity;
@property (nonatomic, copy) NSArray<HQLCity *> *hotCities;
@property (nonatomic, copy) NSArray<HQLCity *> *cities;

@property (nonatomic, copy) NSArray *indexNames;
@property (nonatomic, copy) NSArray *groupedCities;

@end

@implementation HQLCityPickerController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 解决退出时搜索框依然存在的问题
    self.definesPresentationContext = YES;
    
    [self setupTableView];
    [self setupCityData];
    [self updateCurrentCity];
}

- (void)setupCityData {
    // 从本地加载热门城市数据
    HQLPropertyListStore *hotCityStore = [[HQLPropertyListStore alloc] initWithJSONFileName:KHotCityJSONFileName modelsOfClass:[HQLCity class]];
    self.hotCities = hotCityStore.dataSourceArray;
    
    // 从本地加载城市数据
    HQLPropertyListStore *cityStore = [[HQLPropertyListStore alloc] initWithJSONFileName:KCityJSONFileName modelsOfClass:[HQLCity class]];
    self.cities = cityStore.dataSourceArray;
    
    // 对城市数据进行分组排序
    __weak __typeof(self)weakSelf = self;
    [BMChineseSort sortAndGroup:self.cities key:@"first_char" finish:^(bool isSuccess, NSMutableArray *unGroupedArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        // 在数据源中添加「当前城市」、「热门城市」
        if (isSuccess) {
            // 城市索引
            [sectionTitleArr insertObject:@"热门" atIndex:0];
            [sectionTitleArr insertObject:@"当前" atIndex:0];
            strongSelf.indexNames = [sectionTitleArr copy];
            
            // 城市数据
            NSMutableArray *nullArray = [NSMutableArray arrayWithObject:[NSNull null]];
            [sortedObjArr insertObject:nullArray atIndex:0];
            [sortedObjArr insertObject:nullArray atIndex:0];
            strongSelf.groupedCities = [sortedObjArr copy];
            
            [strongSelf.tableView reloadData];
        }
    }];
}

- (void)setupTableView {
    self.title = @"选择城市";
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:249/255.0 alpha:1.0];
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:defaultCityCellReuseIdentifier];
    [self.tableView registerClass:[HQLHotCityTableViewCell class] forCellReuseIdentifier:hotCityCellReuseIdentifier];
}

- (void)updateCurrentCity {
    HQLLocationManager *locationManager = [HQLLocationManager sharedManager];
    __weak __typeof(self)weakSelf = self;
    [locationManager requestLocationWithCompletionHandler:^(HQLCity * _Nonnull currentCity, HQLLocation * _Nonnull currentLocation) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.currentCity = currentCity;
        [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - Custom Accessors

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
        _searchController.searchResultsUpdater = self;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        
        // searchBar
        _searchController.searchBar.placeholder = @"输入城市名、拼音或首字母查询";
        _searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    }
    return _searchController;
}

- (HQLCityPickerSearchResultController *)searchResultController {
    if (!_searchResultController) {
        _searchResultController = [[HQLCityPickerSearchResultController alloc] initWithStyle:UITableViewStylePlain];
        
        // 通过 Block 返回选中的城市数据
        __weak __typeof(self)weakSelf = self;
        _searchResultController.selectionBlock = ^(HQLCity * _Nonnull city) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.completionBlock) {
                strongSelf.completionBlock(city.code, city.name);
            }
            [strongSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _searchResultController;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *groupedCities = self.groupedCities[section];
    return groupedCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            // 当前城市
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCityCellReuseIdentifier forIndexPath:indexPath];
            cell.textLabel.text = (_currentCity ? _currentCity.name : @"无法定位");
            return cell;
            break;
        }
        case 1: {
            // 热门城市
            HQLHotCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotCityCellReuseIdentifier forIndexPath:indexPath];
            cell.hotCities = _hotCities;
            
            __weak __typeof(self)weakSelf = self;
            cell.hotCityButtonAction = ^(HQLCity * _Nonnull city) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (strongSelf.completionBlock) {
                    strongSelf.completionBlock(city.code, city.name);
                }
                [strongSelf.navigationController popViewControllerAnimated:YES];
            };
            return cell;
            break;
        }
        default: {
            // 普通城市
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCityCellReuseIdentifier forIndexPath:indexPath];
            NSArray *groupedCities = self.groupedCities[indexPath.section];
            HQLCity *currentCity = groupedCities[indexPath.row];
            cell.textLabel.text = currentCity.name;
            return cell;
            break;
        }
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"当前城市";
    } else if (section == 1) {
        return @"热门城市";
    } else {
        return self.indexNames[section];
    }
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexNames;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 1) ? 192 : 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HQLCity *currentCity;
    if (indexPath.section == 0) {
        if (!_currentCity) { return; }
        currentCity = _currentCity;
    } else {
        NSArray *groupedCities = self.groupedCities[indexPath.section];
        currentCity = groupedCities[indexPath.row];
    }
    
    if (self.completionBlock) {
        self.completionBlock(currentCity.code, currentCity.name);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = self.searchController.searchBar.text;
    
    if (searchText.length > 0) {
        __weak __typeof(self)weakSelf = self;
        [ZYPinYinSearch searchByPropertyName:@"pinyin" withOriginalArray:self.cities searchText:searchText success:^(NSArray *results) {
            weakSelf.searchResultController.searchResultCities = results;
        } failure:^(NSString *errorMessage) {
            weakSelf.searchResultController.searchResultCities = nil;
        }];
    }
}

@end
