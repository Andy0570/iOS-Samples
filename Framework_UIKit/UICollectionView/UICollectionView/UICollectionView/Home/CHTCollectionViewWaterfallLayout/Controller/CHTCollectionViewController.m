//
//  CHTCollectionViewController.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/8/20.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "CHTCollectionViewController.h"

// Framework
#import <CHTCollectionViewWaterfallLayout.h>

// View
#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"

static const NSUInteger KCellCount = 10;
static NSString * const cellReuseIdentifier = @"CHTCollectionViewWaterfallCell";
static NSString * const headerReuseIdentifier = @"CHTCollectionViewWaterfallHeader";
static NSString * const footerReuseIdentifier = @"CHTCollectionViewWaterfallFooter";

@interface CHTCollectionViewController () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataSources;
@property (nonatomic, strong) NSArray *cellSizes;

@end

@implementation CHTCollectionViewController

#pragma mark - View life cycle

- (void)dealloc {
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

#pragma mark - Custom Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // MARK: 初始化瀑布流布局属性
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 15;
        layout.footerHeight = 10;
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 30;
        
        // 初始化集合视图
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:CHTCollectionViewWaterfallCell.class
            forCellWithReuseIdentifier:cellReuseIdentifier];
        [_collectionView registerClass:CHTCollectionViewWaterfallHeader.class
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:headerReuseIdentifier];
        [_collectionView registerClass:CHTCollectionViewWaterfallFooter.class
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:footerReuseIdentifier];
    }
    return _collectionView;
}

- (NSArray *)dataSources {
    if (!_dataSources) {
        _dataSources = @[@"image_1.jpg",@"image_2.png",@"image_3.jpg",@"image_4.jpg",@"image_5.jpg"];
    }
    return _dataSources;
}

#pragma mark - <UICollectionViewDataSource>

// 一共有多少组集合
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

// 每组集合有几个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return KCellCount;
}

// 分别配置每个元素
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHTCollectionViewWaterfallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.dataSources[indexPath.item % 5]];
    return cell;
}

// 设置头、尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reuseableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        // 设置 header view
        reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                           withReuseIdentifier:headerReuseIdentifier
                                                                  forIndexPath:indexPath];
    } else  if([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        // 设置 foot view
        reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                           withReuseIdentifier:footerReuseIdentifier
                                                                  forIndexPath:indexPath];
    }
    
    return reuseableView;
}

#pragma mark - <CHTCollectionViewDelegateWaterfallLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取图片的宽高，根据图片的比例计算Item的高度
    UIImage *currentItemImage = [UIImage imageNamed:self.dataSources[indexPath.item % 5]];
    CGFloat fixelWidth = CGImageGetWidth(currentItemImage.CGImage);
    CGFloat fixelHeight = CGImageGetHeight(currentItemImage.CGImage);
    
    CGFloat itemWidth = (self.view.frame.size.width - 20 - 20) / 2;
    CGFloat itemHeight = fixelHeight * itemWidth / fixelWidth;
    return CGSizeMake(itemWidth, itemHeight);
}

@end
