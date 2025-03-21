//
//  HQLGroupedArrayDataSource.m
//  iOS Project
//
//  Created by Qilin Hu on 2020/11/07.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLGroupedArrayDataSource.h"
#import "HQLTableViewCellGroupedModel.h"

@interface HQLGroupedArrayDataSource ()

@property (nonatomic, copy) NSArray *groups;
@property (nonatomic, copy) NSString *cellReuseIdentifier;
@property (nonatomic, copy) HQLTableViewCellConfigureBlock configureBlock;

@end

@implementation HQLGroupedArrayDataSource

#pragma mark - Initialize

- (id)initWithGroups:(NSArray *)groups cellReuseIdentifier:(NSString *)reuseIdentifier configureCellBlock:(HQLTableViewCellConfigureBlock)configureBlock {
    self = [super init];
    if (self) {
        _groups = [groups copy];
        _cellReuseIdentifier = reuseIdentifier;
        _configureBlock = [configureBlock copy];
    }
    return self;
}

#pragma mark - Public

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(_groups.count > indexPath.section, @"Index Out Of Array Bounds.");
    HQLTableViewGroupedModel *groupModel = _groups[indexPath.section];
    NSArray *itemsArray = groupModel.cells;
    
    NSAssert(itemsArray.count > indexPath.row, @"Index Out Of Array Bounds.");
    return itemsArray[(NSUInteger)indexPath.row];
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    HQLTableViewGroupedModel *groupModel = _groups[section];
    return groupModel.headerTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HQLTableViewGroupedModel *groupModel = _groups[section];
    return groupModel.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellReuseIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureBlock(cell,item);
    return cell;
}

@end
