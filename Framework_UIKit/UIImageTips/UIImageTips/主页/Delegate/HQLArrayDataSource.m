//
//  HQLArrayDataSource.m
//  Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLArrayDataSource.h"

@interface HQLArrayDataSource ()

@property (nonatomic, copy) NSArray *itemsArray;
@property (nonatomic, copy) NSString *cellReuserIdentifier;
@property (nonatomic, copy) HQLTableViewCellConfigureBlock configureBlock;

@end

@implementation HQLArrayDataSource

#pragma mark - Init

- (id)initWithItemsArray:(NSArray *)itemsArray
    cellReuserIdentifier:(NSString *)reuserIdentifier
          configureBlock:(HQLTableViewCellConfigureBlock)configureBlock {
    self = [super init];
    if (self) {
        _itemsArray = [itemsArray copy];
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
    return _itemsArray[(NSUInteger)indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellReuserIdentifier
                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureBlock(cell,item);
    return cell;
}

@end
