//
//  AFViewController.m
//  Chapter 2 Project 4
//
//  Created by Ash Furrow on 2012-12-17.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"
#import "AFCollectionViewCell.h"

static NSString *CellIdentifier = @"Cell Identifier";

@interface AFViewController ()

@end

@implementation AFViewController {
    // 模型对象
    NSMutableArray *datesArray;
    // 日期格式化对象
    NSDateFormatter *dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 实例化模型
    datesArray = [NSMutableArray array];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"h:mm:ss a" options:0 locale:[NSLocale currentLocale]]];
    
    // 初始化集合视图布局
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 40.0f;
    flowLayout.minimumLineSpacing = 40.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake(200, 200);
    
    // 配置集合视图
    [self.collectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    // 配置导航视图控制器
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(userTappedAddButton:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = @"Our Time Machine";
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return datesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.text = [dateFormatter stringFromDate:datesArray[indexPath.row]];
    return cell;
}

#pragma mark - User Interface Interaction Methods

- (void)userTappedAddButton:(id)sender {
    [self addNewDate];
}

#pragma mark - Private, Custom methods

- (void)addNewDate {

    // !!!: performBatchUpdates: 批量更新集合视图（系统会自动设置更新动画）
    [self.collectionView performBatchUpdates:^{
        // 创建新的日期对象，并更新模型
        NSDate *newDate = [NSDate date];
        [datesArray insertObject:newDate atIndex:0];
        
        // 更新集合视图
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    } completion:nil];
}

@end
