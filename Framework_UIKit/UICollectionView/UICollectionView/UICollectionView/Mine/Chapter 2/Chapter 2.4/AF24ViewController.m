//
//  AF24ViewController.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/8/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AF24ViewController.h"

// View
#import "AFCollectionViewCell.h"

@interface AF24ViewController ()

@property (nonatomic, strong) NSMutableArray *datesArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation AF24ViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 实例化模型
    self.datesArray = [NSMutableArray array];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"h:mm:ss a" options:0 locale:[NSLocale currentLocale]]];
    
    // 初始化集合视图布局
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 40.0f;
    flowLayout.minimumLineSpacing = 40.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake(200, 200);
    
    // 配置集合视图
    [self.collectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    // 配置导航栏按钮
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(userTappedAddButton:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = @"Our Time Machine";
}

#pragma mark - User Interface Interaction Methods

-(void)userTappedAddButton:(id)sender {
    [self addNewDate];
}

#pragma mark - Private, Custom methods

-(void)addNewDate {
    [self.collectionView performBatchUpdates:^{
        // create a new date object and update our model
        NSDate *newDate = [NSDate date];
        [self.datesArray insertObject:newDate atIndex:0];
        
        // update our collection view
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    } completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.text = [self.dateFormatter stringFromDate:self.datesArray[indexPath.row]];
    return cell;
}

@end
