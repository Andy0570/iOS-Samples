//
//  SecondCollectionViewController.m
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/22.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "SecondCollectionViewController.h"

// View
#import "SecondCollectionViewCell.h"

@interface SecondCollectionViewController ()

// 图片数据源
@property (nonatomic, strong) NSArray *dataSourceArray;

@end

@implementation SecondCollectionViewController

static NSString * const reuseIdentifier = @"SecondCollectionViewCell";


#pragma mark - Initialize

- (instancetype)init {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置 Item 与屏幕大小相同
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,
                                 [UIScreen mainScreen].bounds.size.height + 20);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    // 💡 设置 Item 的滚动方向：水平滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [self initWithCollectionViewLayout:layout];
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SecondCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.title = @"引导页";
    
    // 💡设置分页
    self.collectionView.pagingEnabled = YES;
    // 隐藏水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // 取消弹簧效果
    self.collectionView.bounces = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 进入集合视图时，隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 退出集合视图时，显示导航栏
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - Custom Accessors

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"IMG_1183",@"IMG_1184",@"IMG_1185"];
    }
    return _dataSourceArray;
}


#pragma mark - IBActions

// 立即使用按钮被点击时，退出集合视图控制器
- (void)cellButtonDidClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - UICollectionViewDataSource

// 每组集合有几个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

// 分别配置每个元素
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    cell.imageView.image = [UIImage imageNamed:self.dataSourceArray[indexPath.item]];
    // 只有当显示最后一个集合元素时，才显示「立即使用」按钮，
    if (indexPath.item == self.dataSourceArray.count - 1) {
        cell.button.hidden = NO;
        [cell.button addTarget:self action:@selector(cellButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        // 默认隐藏「立即使用」按钮
        cell.button.hidden = YES;
    }
    return cell;
}


#pragma mark - UICollectionViewDelegate

// 当某一个集合中的元素被选中时，执行此方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected %ld section,%ld item !",(long)indexPath.section,(long)indexPath.item);
    
    // 如果当前选中的元素不是最后一个，则自动切换到下一个元素
    if (indexPath.item < self.dataSourceArray.count - 1) {
        NSIndexPath *nextIndex = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:0];
        [collectionView scrollToItemAtIndexPath:nextIndex
                               atScrollPosition:UICollectionViewScrollPositionLeft
                                       animated:YES];
    }
}

@end
