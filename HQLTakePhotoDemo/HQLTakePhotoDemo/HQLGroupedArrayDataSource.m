//
//  HQLGroupedArrayDataSource.m
//  XuZhouSS
//
//  Created by ToninTech on 2017/6/22.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLGroupedArrayDataSource.h"
#import "HQLNavigationButtonModel.h"

@interface HQLGroupedArrayDataSource ()

@property (nonatomic, copy) NSArray *groupsArray;
@property (nonatomic, copy) NSString *cellReuserIdentifier;
@property (nonatomic, copy) HQLTableViewCellConfigureBlock configureBlock;

@end

@implementation HQLGroupedArrayDataSource

#pragma mark - Init

- (id)initWithGroupsArray:(NSArray *)groupsArray
     cellReuserIdentifier:(NSString *)reuserIdentifier
           configureBlock:(HQLTableViewCellConfigureBlock)configureBlock {
    self = [super init];
    if (self) {
        _groupsArray = [groupsArray copy];
        _cellReuserIdentifier = reuserIdentifier;
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
    HQLNavigationButtonModel *groupModel = _groupsArray[indexPath.section];
    NSArray *itemsArray = groupModel.subfunctions;
    return itemsArray[(NSUInteger)indexPath.row];
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    HQLNavigationButtonModel *groupModel = _groupsArray[section];
    return groupModel.title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _groupsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HQLNavigationButtonModel *groupModel = _groupsArray[section];
    return groupModel.subfunctions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellReuserIdentifier
                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureBlock(cell,item);
    return cell;
}

@end
