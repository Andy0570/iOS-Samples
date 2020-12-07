//
//  AFViewController.m
//  Chapter 2 Project 6
//
//  Created by Ash Furrow on 2012-12-17.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"
#import "AFCollectionViewCell.h"

static NSString *CellIdentifier = @"Cell Identifier";

@implementation AFViewController
{
    // 图片模型
    NSArray *imageArray;
    // 背景颜色
    NSArray *colorArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化模型
    NSMutableArray *mutableImageArray = [NSMutableArray arrayWithCapacity:12];
    for (NSInteger i = 0; i < 12; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"%ld.jpg", (long)i];
        [mutableImageArray addObject:[UIImage imageNamed:imageName]];
    }
    imageArray = [NSArray arrayWithArray:mutableImageArray];
    
    NSMutableArray *mutableColorArray = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 10; i++)
    {
        CGFloat redValue = (arc4random() % 255) / 255.0f;
        CGFloat blueValue = (arc4random() % 255) / 255.0f;
        CGFloat greenValue = (arc4random() % 255) / 255.0f;
        
        [mutableColorArray addObject:[UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0f]];
    }
    colorArray = [NSArray arrayWithArray:mutableColorArray];
    
    // 初始化集合视图布局对象
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 20.0f;
    flowLayout.minimumLineSpacing = 20.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake(220, 220);
    
    // 初始化集合视图对象
    [self.collectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    // !!!: 默认值为 NO。该属性用于控制是否可以同时选择多个 row。
    self.collectionView.allowsMultipleSelection = YES;
    // !!!: 默认为 "YES"。如果为 "NO"，那么一旦我们开始跟踪，如果触摸移动，我们就不会尝试拖动。
    self.collectionView.canCancelContentTouches = NO;
    // !!!: 默认是 YES.如果 NO，则立即调用 -touchesShouldBegin:withEvent:inContentView: 方法，这对按压没有任何影响。
    self.collectionView.delaysContentTouches = NO;  
}

#pragma mark - UICollectionViewDataSource Methods

// 一共有多少组集合
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return colorArray.count;
}

// 每组集合有几个元素
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArray.count;
}

// 分别配置每个元素
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.image = imageArray[indexPath.item];
    cell.backgroundColor = colorArray[indexPath.section];
    return cell;
}

@end
