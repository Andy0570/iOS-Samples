//
//  HQLCityPickerSearchResultController.m
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/2/1.
//

#import "HQLCityPickerSearchResultController.h"

// Framework
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

// Model
#import "HQLProvince.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLCityPickerSearchResultController () <DZNEmptyDataSetSource>
@end

@implementation HQLCityPickerSearchResultController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索结果";
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:249/255.0 alpha:1.0];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSetSource = self;
}

#pragma mark - Custom Accessors

- (void)setSearchResultCities:(NSArray<HQLCity *> *)searchResultCities {
    _searchResultCities = searchResultCities;
    [self.tableView reloadData];
}

#pragma mark - Private

- (HQLCity *)cityAtIndexPath:(NSIndexPath *)indexPath {
    HQLCity *currentCity = (HQLCity *)self.searchResultCities[indexPath.row];
    return currentCity;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HQLCity *currentCity = [self cityAtIndexPath:indexPath];
    cell.textLabel.text = currentCity.name;
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HQLCity *currentCity = [self cityAtIndexPath:indexPath];
    if (self.selectionBlock) {
        self.selectionBlock(currentCity);
    }
}

#pragma mark - <DZNEmptyDataSetSource>

// 空白页显示标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"未找到相关城市，请尝试修改后重试";
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f],
        NSForegroundColorAttributeName:[UIColor darkGrayColor]
    };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

// 设置内容视图的垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -120;
}

@end
