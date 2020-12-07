//
//  FourthCollectionViewController.m
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/29.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "FourthCollectionViewController.h"

// View
#import "ThirdCollectionViewCell.h"

@interface FourthCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) NSArray *dataSourceArray;

@end

@implementation FourthCollectionViewController

static NSString * const reuseIdentifier = @"ThirdCollectionViewCell";

#pragma mark - Initialize

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return [self initWithCollectionViewLayout:layout];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"使用代理方式布局";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ThirdCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark - Custom Accessors

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[
            @"hashiqi001.jpeg",
            @"road.jpeg",
            @"hashiqi002.jpeg",
            @"IMG_1183.png",
            @"photo-1503249023995-51b0f3778ccf.jpeg",
            @"shamo.jpeg",
            @"photo-1509021348834-5fc022c5a559.jpeg",
            @"IMG_1185.png",
            @"photo-1509910673751-ce7e70e08512.jpeg",
            @"IMG_1184.png",
            @"star.jpeg",
            @"photo-1515224526905-51c7d77c7bb8.jpeg"
        ];
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
    
    ThirdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:[self.dataSourceArray objectAtIndex:indexPath.item]];
    cell.imageView.image = image;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

// 返回每个图片的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 分别设置每个图片的宽高
    UIImage *image = [UIImage imageNamed:self.dataSourceArray[indexPath.item]];
    CGFloat fixelWidth = CGImageGetWidth(image.CGImage);
    CGFloat fixelHeight = CGImageGetHeight(image.CGImage);
    
    // 1.计算宽高值
    // Item 的宽度 = （屏幕宽度-Section左右插入量-每个Item的水平Margin间隙） / Item个数
    CGFloat itemWidth = (self.collectionView.frame.size.width - 20 - 20 - 10*1) / 2;
    CGFloat itemHeight = fixelHeight * itemWidth / fixelWidth;
    return CGSizeMake(itemWidth, itemHeight);
}

// 边缘插入量
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets inserts = UIEdgeInsetsMake(20, 20, 20, 20);
    return inserts;
}

// 每一行之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 每一列之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

@end
