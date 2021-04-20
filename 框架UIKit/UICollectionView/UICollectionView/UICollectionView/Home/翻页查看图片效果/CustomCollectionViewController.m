//
//  CustomCollectionViewController.m
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/25.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "CustomCollectionViewController.h"

// View
#import "CustomCollectionViewCell.h"

// Layout
#import "CustomCollectionViewFlowLayout.h"

@interface CustomCollectionViewController ()

@property (nonatomic, strong) NSArray *dataSourceArray;

@end

@implementation CustomCollectionViewController

static NSString * const reuseIdentifier = @"CustomCollectionViewCell";


#pragma mark - Initialize

- (instancetype)init {
    CustomCollectionViewFlowLayout *layout = [[CustomCollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(250, 354);
    return [super initWithCollectionViewLayout:layout];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"自定义";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}


#pragma mark - Custom Accessors

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"photo1.jpg",
                             @"photo2.jpg",
                             @"photo3.jpg",
                             @"photo4.jpg",
                             @"photo5.jpg",
                             @"photo6.jpg",
                             @"photo7.jpg",
                             @"photo8.jpg",
                             @"photo9.jpg"];
    }
    return _dataSourceArray;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 自定义集合元素
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.dataSourceArray[indexPath.item]];
    
    return cell;
}

@end
