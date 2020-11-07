//
//  HQLArrayDataSource.m
//  PhotoData
//
//  Created by HuQilin on 2017/6/11.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLArrayDataSource.h"

@interface HQLArrayDataSource ()

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NSString *cellReuseIdentifier;
@property (nonatomic, copy) HQLTableViewCellConfigureBlock configureBlock;

@end

@implementation HQLArrayDataSource

#pragma mark - Initialize

- (instancetype)initWithItems:(NSArray *)items cellReuseIdentifier:(NSString *)reuseIdentifier configureCellBlock:(HQLTableViewCellConfigureBlock)configureBlock{
    self = [super init];
    if (self) {
        _items = [items copy];
        _cellReuseIdentifier = reuseIdentifier;
        _configureBlock = [configureBlock copy];
    }
    return self;
}

#pragma mark - Public

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(_items.count > indexPath.row, @"Index Out Of Array Bounds.");
    return _items[(NSUInteger)indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellReuseIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureBlock(cell,item);
    return cell;
}

@end
