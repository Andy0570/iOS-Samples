//
//  AF26ViewController.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/8/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AF26ViewController.h"

#import "AF26CollectionViewCell.h"

@interface AF26ViewController ()

@property (nonatomic, copy) NSArray *imageArray;
@property (nonatomic, copy) NSArray *colorArray;

@end

@implementation AF26ViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化模型,创建并加载图片数据
    NSMutableArray *mutableImageArray = [NSMutableArray arrayWithCapacity:12];
    for (NSInteger i = 0; i < 12; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%ld.jpg",(long)i];
        [mutableImageArray addObject:[UIImage imageNamed:imageName]];
    }
    self.imageArray = [NSArray arrayWithArray:mutableImageArray];
    
    // 初始化模型，创建并加载颜色数据，作为一组 cell 的背景颜色
    NSMutableArray *mutableColorArray = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 10; i++) {
        CGFloat redValue = (arc4random() % 255) / 255.0f;
        CGFloat blueValue = (arc4random() % 255) / 255.0f;
        CGFloat greenValue = (arc4random() % 255) / 255.0f;
        
        [mutableColorArray addObject:[UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0f]];
    }
    self.colorArray = [NSArray arrayWithArray:mutableColorArray];
    
    // 配置集合视图布局
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 20.0f;
    flowLayout.minimumLineSpacing = 20.0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake(220, 220);
    
    // 配置集合视图
    // MARK: 这里通过 Nib 方式注册重用 cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(AF26CollectionViewCell.class) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.collectionView.allowsMultipleSelection = YES;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.colorArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AF26CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.image = self.imageArray[indexPath.item];
    cell.backgroundColor = self.colorArray[indexPath.section];
    return cell;
}

@end
