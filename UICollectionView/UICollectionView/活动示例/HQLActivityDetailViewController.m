//
//  HQLActivityDetailViewController.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/5/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLActivityDetailViewController.h"

// Views
#import "HQLActivityDetailHeaderView.h"
#import "HQLActivityDetailCell.h"

// Models
#include "HQLActivityDetailDataSource.h"

static NSString * const cellReuseIdentifier = @"HQLActivityDetailCell";
static NSString * const headerReuseIdentifier = @"HQLActivityDetailHeaderView";

@interface HQLActivityDetailViewController ()

@property (nonatomic, strong) HQLActivityDetailDataSource *dataSource;

// 缓存高度
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, strong) NSMutableArray *cellHeightArray;

@end

@implementation HQLActivityDetailViewController


#pragma mark - Controller life cycle

// 因为 init 方法本身不会设置布局参数，因此子类要覆写 init 方法，设置布局参数。
- (instancetype)init {
    
    // 初始化集合视图控制器 UICollectionViewController 时，必须设置 UICollectionViewLayout 类型的参数；
    // UICollectionViewLayout 是一个抽象类，用于指定集合视图应该具有的布局方式；
    // UICollectionViewFlowLayout （流水布局）是 UICollectionViewLayout 的子类；
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.itemSize = CGSizeMake(100, 100);  // 集合元素大小
//    flowLayout.minimumLineSpacing = 20;          // 集合元素行与行之间的最小距离 (垂直距离)
//    flowLayout.minimumInteritemSpacing = 10;     // 集合元素列与列之间的最小距离（水平距离）
//    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20); // section 的边缘插入量，默认为{0,0,0,0}
    return [self initWithCollectionViewLayout:flowLayout];
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加数据源
    self.dataSource = [[HQLActivityDetailDataSource alloc] init];
    // 计算并缓存 cell 高度
    
    [self.dataSource.model enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = [UIImage imageNamed:imageName];
        CGFloat fixelWidth = CGImageGetWidth(image.CGImage);
        CGFloat fixelheight = CGImageGetHeight(image.CGImage);
        

        CGFloat imgHeight = fixelheight * self.view.bounds.size.width / fixelWidth;
        [self.cellHeightArray addObject:[NSNumber numberWithFloat:imgHeight]];
    }];
        
    // 注册重用 cell
    [self.collectionView registerClass:[HQLActivityDetailCell class]
            forCellWithReuseIdentifier:cellReuseIdentifier];
    UINib *activityDetailHeaderView = [UINib nibWithNibName:NSStringFromClass([HQLActivityDetailHeaderView class]) bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:activityDetailHeaderView
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:headerReuseIdentifier];
    
    self.title = @"活动详情";
    self.collectionView.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Custom Accessors

- (NSMutableArray *)cellHeightArray {
    if (!_cellHeightArray) {
        _cellHeightArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _cellHeightArray;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.model.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 分别配置每个 cell
    HQLActivityDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    // 设置图片
    NSString *imageName = self.dataSource.model[indexPath.item];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HQLActivityDetailHeaderView *reuseableView;
        // 设置 header 内容
        reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
        reuseableView.titleLabel.text = @"羊角奶黄包你遇见过吗？";
        reuseableView.subTitleLabel.text = @"当经典羊角面包遇见海盐蜂蜜口味流心，入口柔软咸香";
        
        // 动态计算高度
        CGSize labelBaseSize = CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX);
        CGSize titleLabelSize = [reuseableView.titleLabel sizeThatFits:labelBaseSize];
        CGSize subTitleLabelSize = [reuseableView.subTitleLabel sizeThatFits:labelBaseSize];
        self.titleHeight = titleLabelSize.height + subTitleLabelSize.height + 40;
        NSLog(@"titleHeight = %lf",self.titleHeight);
        return reuseableView;
    }
    return nil;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// 设置 section header 大小。
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    // FIXME: 需要动态计算高度
    return CGSizeMake(self.collectionView.bounds.size.width, 105);
}

// 设置 item 大小。
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *itemHeight = self.cellHeightArray[indexPath.item];
    return CGSizeMake(self.view.frame.size.width, itemHeight.floatValue);
}

// 设置 cell 边缘插入量。
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置item间距。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置行间距。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
