//
//  FirstCollectionViewController.m
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/22.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "FirstCollectionViewController.h"

// Frameworks
#import "UIView+Toast.h"

static NSString * const reuseIdentifier = @"FirstCollectionViewCell";

@interface FirstCollectionViewController ()

@end

@implementation FirstCollectionViewController


#pragma mark - Initialize

// 因为 init 方法本身不会设置布局参数，因此子类要覆写 init 方法，设置布局参数。
- (instancetype)init {
    
    // 初始化集合视图控制器 UICollectionViewController 时，必须设置 UICollectionViewLayout 类型的参数；
    // UICollectionViewLayout 是一个抽象类，用于指定集合视图应该具有的布局方式；
    // UICollectionViewFlowLayout （流水布局）是 UICollectionViewLayout 的子类；
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100, 100);  // 集合元素大小
    flowLayout.minimumLineSpacing = 20;          // 集合元素行与行之间的最小距离 (垂直距离)
    flowLayout.minimumInteritemSpacing = 10;     // 集合元素列与列之间的最小距离（水平距离）
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20); // section 的边缘插入量，默认为{0,0,0,0}
    return [self initWithCollectionViewLayout:flowLayout];
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // 是否保留之前的选择
    // 当集合视图第一次将要显示时，集合视图控制器每次都会重新加载集合视图数据，
    // 它也会清除已经选中的上次被显示的集合视图，通过设置该属性就可以改变这个行为。
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = @"基础使用";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 注册重用 cell 类，重用机制类似于 UITableView
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:reuseIdentifier];
}


#pragma mark - <UICollectionViewDataSource>

// 一共有多少组集合
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

// 每组集合有几个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

// 分别配置每个元素
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // 配置 cell，这里简单设置 cell 的背景颜色
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.467 green:0.847 blue:0.847 alpha:1];
    return cell;
}


#pragma mark - <UICollectionViewDelegate>

/*
// 当指定的某个集合元素被选中时，是否应该高亮显示
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// 指定的某个集合元素是否可以被选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// 是否为某一个集合元素指定动作菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

// 是否可以执行方法
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

// 为某一个集合元素指定 Action 方法
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

// 当某一个集合中的元素被选中时，执行此方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 在页面上弹出一个 Toast 通知！
    NSString *toastString = [NSString stringWithFormat:@"你选中了第 %ld 组第 %ld 个元素！",(long)indexPath.section,(long)indexPath.item];
    [self.view makeToast:toastString];
}

@end
