//
//  HQLGroupedArrayDataSource.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLGroupedArrayDataSource.h"
#import "HQLTableViewCellGroupedModel.h"

@interface HQLGroupedArrayDataSource ()

@property (nonatomic, copy) NSArray *groupsArray;
@property (nonatomic, copy) NSString *cellReuseIdentifier;
@property (nonatomic, copy) HQLTableViewCellConfigureBlock configureBlock;

@end

@implementation HQLGroupedArrayDataSource

#pragma mark - Init

- (id)initWithGroupsArray:(NSArray *)groupsArray
      cellReuseIdentifier:(NSString *)reuseIdentifier
           configureBlock:(HQLTableViewCellConfigureBlock)configureBlock {
    self = [super init];
    if (self) {
        _groupsArray = [groupsArray copy];
        _cellReuseIdentifier = reuseIdentifier;
        _configureBlock = [configureBlock copy];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Method Undefined"
                                   reason:@"Use designated Initizlizer Method"
                                 userInfo:nil];
    return nil;
}

#pragma mark - Public

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(indexPath.section < _groupsArray.count, @"Index Out Of Array Bounds.");
    HQLTableViewCellGroupedModel *groupModel = _groupsArray[indexPath.section];
    NSArray *itemsArray = groupModel.cells;
    NSAssert(indexPath.row < itemsArray.count, @"Index Out Of Array Bounds.");
    return itemsArray[(NSUInteger)indexPath.row];
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    HQLTableViewCellGroupedModel *groupModel = _groupsArray[section];
    return groupModel.headerTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _groupsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HQLTableViewCellGroupedModel *groupModel = _groupsArray[section];
    return groupModel.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellReuseIdentifier
                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureBlock(cell,item);
    return cell;
}

@end
