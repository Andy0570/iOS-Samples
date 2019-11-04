//
//  HQLGovermentTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/12.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLGovermentTableViewController.h"

// View
#import "HQLGovermentTableViewCell.h"

// Model
#import "HQLGovermentTableViewCell+ConfigureModel.h"


static NSString *const cellReuseIdentifier = @"HQLGovermentTableViewCell";

@interface HQLGovermentTableViewController ()

@property (nonatomic, strong) HQLGovermentModel *govermentModel;
@property (nonatomic, strong) NSArray *dataSourceArray;

@end

@implementation HQLGovermentTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.govermentModel.result.title;
    // 设置数据源
    self.dataSourceArray = self.govermentModel.result.list;
    [self setupTableView];
}

- (instancetype)initWithGovermentModel:(HQLGovermentModel *)govermentModel {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _govermentModel = govermentModel;
    }
    return self;
}

#pragma mark - Private

- (void)setupTableView {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([HQLGovermentTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellReuseIdentifier];
    self.tableView.estimatedRowHeight = HQLGovermentTableViewCellHeight;
    self.tableView.rowHeight = HQLGovermentTableViewCellHeight;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    HQLGovermentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    ListData *data = self.dataSourceArray[indexPath.row];
    [cell hql_configureForModel:data];
    
    return cell;
}


@end
