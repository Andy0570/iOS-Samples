//
//  HQLImageGrayCollectionViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/9/17.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLImageGrayCollectionViewController.h"

#import "HQLImageGrayCollectionViewCell.h"

#import "UIImage+PixelMix.h"
#import <UIImage+YYAdd.h>
#import <JKCategories.h>

@interface HQLImageGrayCollectionViewController ()
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation HQLImageGrayCollectionViewController

static NSString * const reuseIdentifier = @"HQLImageGrayCollectionViewCell";

// 因为 init 方法本身不会设置布局参数，因此子类要覆写 init 方法，设置布局参数
- (instancetype)init {
    
    // 初始化集合视图控制器 UICollectionViewController 时，必须设置 UICollectionViewLayout 类型的参数；
    // UICollectionViewLayout 是一个抽象类，用于指定集合视图应该具有的布局方式；
    // UICollectionViewFlowLayout （流水布局）是 UICollectionViewLayout 的子类；
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // 720x480
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat itemHeight = round(itemWidth * 480 / 720);
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);  // 集合元素大小
    flowLayout.minimumLineSpacing = 10;          // 集合元素行与行之间的最小距离 (垂直距离)
    flowLayout.minimumInteritemSpacing = 10;     // 集合元素列与列之间的最小距离（水平距离）
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10); // section 的边缘插入量，默认为{0,0,0,0}
    return [self initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Register cell classes
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([HQLImageGrayCollectionViewCell class])
                                bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib
          forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setupDataSource];
}

- (void)setupDataSource {
    UIImage *sourceImage = [UIImage imageNamed:@"fruits.png"];
    
    NSDictionary *item0 = @{
        @"title":@"原始图片",
        @"image":sourceImage
    };
    
    // 灰度图片
    NSDictionary *item1 = @{
        @"title":@"平均值算法",
        @"image":[sourceImage grayImageWithType:0]
    };
    
    // 灰度图片
    NSDictionary *item2 = @{
        @"title":@"人眼感知算法",
        @"image":[sourceImage grayImageWithType:1]
    };
    
    // 灰度图片
    NSDictionary *item3 = @{
        @"title":@"去饱和算法",
        @"image":[sourceImage grayImageWithType:2]
    };
    
    // 灰度图片
    NSDictionary *item4 = @{
        @"title":@"最大值分解算法",
        @"image":[sourceImage grayImageWithType:3]
    };
    
    // 灰度图片
    NSDictionary *item5 = @{
        @"title":@"最小值分解算法",
        @"image":[sourceImage grayImageWithType:4]
    };
    
    // 灰度图片
    NSDictionary *item6 = @{
        @"title":@"单一通道算法，取红色通道",
        @"image":[sourceImage grayImageWithType:5]
    };
    
    // 灰度图片
    NSDictionary *item7 = @{
        @"title":@"单一通道算法，取绿色通道",
        @"image":[sourceImage grayImageWithType:6]
    };
    
    // 灰度图片
    NSDictionary *item8 = @{
        @"title":@"单一通道算法，取蓝色通道",
        @"image":[sourceImage grayImageWithType:7]
    };
    
    // 灰度图片
    NSDictionary *item80 = @{
        @"title":@"自定义灰度阴影,NumberOfShades = 4",
        @"image":[sourceImage grayImageWithNumberOfShades:4]
    };
    
    // 灰度图片
    NSDictionary *item81 = @{
        @"title":@"自定义灰度阴影,NumberOfShades = 16",
        @"image":[sourceImage grayImageWithNumberOfShades:16]
    };
    
    // 灰度图片，JKCategories 框架
    NSDictionary *item9 = @{
        @"title":@"jk_covertToGrayImageFromImage",
        @"image":[UIImage jk_covertToGrayImageFromImage:sourceImage]
    };
    
    // YYKit 方法
    NSDictionary *item10 = @{
        @"title":@"imageByGrayscale",
        @"image":[sourceImage imageByGrayscale]
    };
    
    // YYKit 方法
    NSDictionary *item11 = @{
        @"title":@"imageByBlurSoft",
        @"image":[sourceImage imageByBlurSoft]
    };
    
    // YYKit 方法
    NSDictionary *item12 = @{
        @"title":@"imageByBlurLight",
        @"image":[sourceImage imageByBlurLight]
    };
    
    // YYKit 方法
    NSDictionary *item13 = @{
        @"title":@"imageByBlurExtraLight",
        @"image":[sourceImage imageByBlurExtraLight]
    };
    
    // YYKit 方法
    UIColor *tintColor = [UIColor colorWithRed:83/255.0 green:202/255.0 blue:195/255.0 alpha:1.0];
    NSDictionary *item14 = @{
        @"title":@"imageByBlurWithTint",
        @"image":[sourceImage imageByBlurWithTint:tintColor]
    };
    
    // icon 原始图片
    // 测试，在 Assert 保存一张白色图片，通过渲染 tint 值实现图片复用
    UIImage *locationImage = [UIImage imageNamed:@"store_location"];
    NSDictionary *item15 = @{
        @"title":@"原始图片",
        @"image": locationImage
    };
    
    // YYKit 方法
    NSDictionary *item16 = @{
        @"title":@"imageByTintColor",
        @"image":[locationImage imageByTintColor:tintColor]
    };
    
    // YYKit 方法
    NSDictionary *item17 = @{
        @"title":@"imageByBlurWithTint",
        @"image":[locationImage imageByBlurWithTint:tintColor]
    };
    
    // JKCategories 框架
    NSDictionary *item18 = @{
        @"title":@"jk_imageMaskedWithColor",
        @"image":[locationImage jk_imageMaskedWithColor:tintColor]
    };
    
    self.dataSource = @[item0, item1, item2, item3, item4, item5, item6, item7, item8,item80,item81, item9, item10, item11, item12, item13, item14, item15, item16, item17, item18 ];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HQLImageGrayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *currentDic = [self.dataSource jk_objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [currentDic objectForKey:@"title"];
    cell.imageView.image = (UIImage *)[currentDic objectForKey:@"image"];
    
    return cell;
}

@end
