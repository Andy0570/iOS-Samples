//
//  ThirdCollectionViewController.m
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/23.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "ThirdCollectionViewController.h"

// View
#import "ThirdCollectionViewCell.h"

// Other
#import "WaterFlowCollectionViewLayout.h"

static NSString * const reuseIdentifier = @"ThirdCollectionViewCell";

@interface ThirdCollectionViewController () <WaterFlowCollectionViewDelegate>

@property (nonatomic, strong) NSArray *dataSourceArray;

@end

@implementation ThirdCollectionViewController

#pragma mark - Initialize

- (instancetype)init {
    // 初始化自定义布局类
    WaterFlowCollectionViewLayout *layout = [[WaterFlowCollectionViewLayout alloc] init];
    layout.delegate = self;
    return [super initWithCollectionViewLayout:layout];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"瀑布流";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ThirdCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark - Custom Accessors

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"hashiqi001.jpeg",
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
                             @"photo-1515224526905-51c7d77c7bb8.jpeg"];
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


// 💡通过遵守并实现代理的方式设置布局参数
// 视图控制器将布局所需要的参数返回给自定义的 UICollectionViewLayout 实例
#pragma mark - WaterFlowCollectionViewDelegate

// 返回某一项 item 元素的高度 2⃣️
- (CGFloat)heightForItemInWaterFlowLayout:(WaterFlowCollectionViewLayout *)waterFlowLayout widthForItem:(CGFloat)width atIndexPath:(NSUInteger)indexPath {
    // 获取图片的宽高，根据图片的比例计算Item的高度
    UIImage *image = [UIImage imageNamed:self.dataSourceArray[indexPath]];
    CGFloat fixelWidth = CGImageGetWidth(image.CGImage);
    CGFloat fixelHeight = CGImageGetHeight(image.CGImage);
    CGFloat itemHeight = fixelHeight * width / fixelWidth;
    return itemHeight;
}

// 列数
- (NSInteger)numberOfColumInWaterFlowLayout:(WaterFlowCollectionViewLayout *)waterFlowLayout {
    return 2;
}

// 每一列之间的距离
- (CGFloat)columMarginInWaterFlowLayout:(WaterFlowCollectionViewLayout *)waterFlowLayout {
    return 10;
}

// 每一行之间的距离
- (CGFloat)rowMarginInWaterFlowLayout:(WaterFlowCollectionViewLayout *)waterFlowLayout {
    return 10;
}

// 边缘插入量
- (UIEdgeInsets)sectionInsetInWaterFlow:(WaterFlowCollectionViewLayout *)waterFlowLayout {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
