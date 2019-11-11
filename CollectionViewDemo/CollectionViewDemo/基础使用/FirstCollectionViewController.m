//
//  FirstCollectionViewController.m
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/22.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "FirstCollectionViewController.h"

@interface FirstCollectionViewController ()

@end

@implementation FirstCollectionViewController

static NSString * const reuseIdentifier = @"FirstCollectionViewCell";

#pragma mark - Lifecycle

// 因为 init 方法本身不会设置布局参数，因此子类要覆写 init 方法,设置布局参数。
- (instancetype)init {
    
    // 初始化集合视图控制器 UICollectionViewController 时，必须设置 UICollectionViewLayout 类型的参数；
    // UICollectionViewLayout 是一个抽象类，用于指定集合视图应该具有的布局方式
    // UICollectionViewFlowLayout 是 UICollectionViewLayout 的子类；
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100, 100);  // 集合元素大小
    flowLayout.minimumLineSpacing = 20;          // 集合元素行与行之间的最小距离 (垂直距离)
    flowLayout.minimumInteritemSpacing = 0;      // 同一行集合元素之间的最小距离（水平距离）
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20); // section 的边缘插入量，默认为{0,0,0,0}
    return [self initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // 是否保留之前的选择
    // 当集合视图第一次将要显示时，集合视图控制器每次都会重新加载集合视图数据，它也会清除已经选中的上次被显示的集合视图，通过设置该属性就可以改变这个行为。
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // 注册重用 cell 类，重用机制类似于 UITableView
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.title = @"基础使用";
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.90 green:0.49 blue:0.96 alpha:1];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
// 当指定的某个集合元素被选中时，是否应该高亮显示
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
// 指定的某个集合元素是否可以被选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected %ld section,%ld item !",(long)indexPath.section,(long)indexPath.item);
}

@end
