//
//  ActionSheetPickerViewController.m
//  UIAlertController
//
//  Created by Qilin Hu on 2020/11/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "ActionSheetPickerViewController.h"

// Framework
#import <ActionSheetPicker.h>

// Model
#import "HQLTableViewCellGroupedModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface ActionSheetPickerViewController ()
@property (nonatomic, copy) NSArray *cellsArray;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;
@end

@implementation ActionSheetPickerViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ActionSheetPicker";
    [self setupTableView];
}

#pragma mark - Custom Accessors

// 从 myTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray *)cellsArray {
    if (!_cellsArray) {
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:@"ActionSheetPicker.plist" modelsOfClass:HQLTableViewModel.class];
        _cellsArray = store.dataSourceArray;
    }
    return _cellsArray;
}

#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源，通过 HQLArrayDataSource 类的实例实现数据源代理
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItems:self.cellsArray cellReuseIdentifier:cellReuseIdentifier configureCellBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate

// tableView 中的某一行cell被点击时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *sender = cell.textLabel;
    
    switch (indexPath.row) {
        case 0: {
            [self showActionSheetStringPicker:sender];
            break;
        }
        case 1: {
            [self showActionSheetMultipleStringPicker:sender];
            break;
        }
        case 2: {
            [self showActionSheetDatePicker:sender];
            break;
        }
        case 3: {
            [self showActionSheetLocalePicker:sender];
            break;
        }
        case 4: {
    
            break;
        }
        default:
            break;
    }
}

#pragma mark - 使用示例

// MARK: ActionSheetStringPicker
- (void)showActionSheetStringPicker:(id)sender {
    // 数据源
    NSArray *colors = @[@"Red", @"Green", @"Blue", @"Orange"];
    [ActionSheetStringPicker showPickerWithTitle:@"选择一种颜色" rows:colors initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSLog(@"Picker:%@", picker);
        NSLog(@"Selected Index:%ld", selectedIndex);
        NSLog(@"Selected Value:%@", selectedValue);
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Cancled");
    } origin:sender];
}

// MARK: ActionSheetMultipleStringPicker
- (void)showActionSheetMultipleStringPicker:(id)sender {
    // 数据源
    NSArray *rows = @[@[@"C", @"Db", @"D", @"Eb", @"E", @"F", @"Gb", @"G", @"Ab", @"A", @"Bb", @"B"], @[@"Major", @"Minor", @"Dorian", @"Spanish Gypsy"]];
    // 默认选中的行
    NSArray *initialSelection = @[@2, @3];
    [ActionSheetMultipleStringPicker showPickerWithTitle:@"Select scale" rows:rows initialSelection:initialSelection doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues) {
        NSLog(@"Selected Indexes:%@", selectedIndexes);
        NSLog(@"%@",[selectedValues componentsJoinedByString:@", "]);
    } cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
        NSLog(@"Block Picker Cancled");
    } origin:sender];
}

// MARK: ActionSheetDatePicker
- (void)showActionSheetDatePicker:(id)sender {
    
    NSString *minimumDateString = @"1990-01-01 00:00:00"; // 最小选择日期
    NSString *maximumDateString = @"2100-01-01 00:00:00"; // 最大选择日期
    // 设置字符串的日期格式
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-M-d HH:mm:ss"];
    NSDate *minimumDate = [dateFormater dateFromString:minimumDateString];
    NSDate *maximumDate = [dateFormater dateFromString:maximumDateString];
    
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"请选择日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSLog(@"selected Data:%@",[dateFormater stringFromDate:(NSDate *)selectedDate]);
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        NSLog(@"Block Picker Cancled");
    } origin:sender];
    datePicker.minimumDate = minimumDate;
    datePicker.maximumDate = maximumDate;
    [datePicker showActionSheetPicker];
}

// MARK: ActionSheetLocalePicker
- (void)showActionSheetLocalePicker:(id)sender {
    // 完成 Block 块
    ActionLocaleDoneBlock doneBlock = ^(ActionSheetLocalePicker *picker, NSTimeZone * selectedValue) {
        NSLog(@"selected Value:%@",selectedValue);
    };
    // 取消 Block 块
    ActionLocaleCancelBlock cancelBlock = ^(ActionSheetLocalePicker *picker) {
        NSLog(@"Block Picker Cancled");
    };
    // 默认选择时区：上海
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    ActionSheetLocalePicker *picker = [[ActionSheetLocalePicker alloc] initWithTitle:@"Select Locale:" initialSelection:defaultTimeZone doneBlock:doneBlock cancelBlock:cancelBlock origin:sender];
    
    [picker addCustomButtonWithTitle:@"My locale" value:[NSTimeZone localTimeZone]];
    __weak __typeof(self)weakSelf = self;
    [picker addCustomButtonWithTitle:@"隐藏" actionBlock:^{
        NSLog(@"隐藏按钮被点击！");
    }];
    [picker showActionSheetPicker];
}


@end
