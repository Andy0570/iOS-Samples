//
//  HQLArrayDataSource.m
//  PhotoData
//
//  Created by HuQilin on 2017/6/11.
//  Copyright © 2017年 ToninTech. All rights reserved.
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
