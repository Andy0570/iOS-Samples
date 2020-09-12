//
//  AFViewController.m
//  Chapter 1 Project 1
//
//  Created by Qilin Hu on 2020/8/31.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AFViewController.h"

static NSString * const reuseIdentifier = @"Cell";

@interface AFViewController ()
@property (nonatomic, copy) NSArray *colorArray;
@end

@implementation AFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // 注册重用集合视图 Cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 初始化数据源模型，创建 100 个随机颜色
    const NSInteger numberOfColors = 100;
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:numberOfColors];
    for (NSInteger i = 0; i < numberOfColors; i++) {
        CGFloat red = arc4random()/(CGFloat)INT_MAX;
        CGFloat green = arc4random()/(CGFloat)INT_MAX;
        CGFloat blue = arc4random()/(CGFloat)INT_MAX;
        UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        [tempArray addObject:randomColor];
    }

    // !!!: 使用 NSMutableArray 可变数组创建数据，赋值到数据源时使用 NSArray 不可变数组，以提高性能。
    _colorArray = [NSArray arrayWithArray:tempArray];
}

#pragma mark <UICollectionViewDataSource>

// 每组集合有几个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _colorArray.count;
}

// 分别配置每个元素
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = _colorArray[indexPath.item];
    return cell;
}

@end
