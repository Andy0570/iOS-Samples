//
//  ViewController.m
//  Chapter 2 Project 1
//
//  Created by Qilin Hu on 2020/8/31.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "ViewController.h"

static NSString * const reuseIdentifier = @"Cell";

@interface ViewController ()
@property (nonatomic, copy) NSArray *colorArray;
@end

@implementation ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // 初始化数据源
    const NSInteger numberOfColors = 100;
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:numberOfColors];
    for (NSInteger i = 0; i < numberOfColors; i++) {
        CGFloat red = arc4random()/(CGFloat)INT_MAX;
        CGFloat green = arc4random()/(CGFloat)INT_MAX;
        CGFloat blue = arc4random()/(CGFloat)INT_MAX;
        UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        [tempArray addObject:randomColor];
    }
    _colorArray = [NSArray arrayWithArray:tempArray];
    
    // 初始化集合视图
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _colorArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = _colorArray[indexPath.item];
    return cell;
}

@end
