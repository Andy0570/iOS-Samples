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

@property (nonatomic, strong) NSArray *dataSourceArray;

@end

@implementation SecondCollectionViewController

static NSString * const reuseIdentifier = @"SecondCollectionViewCell";

#pragma mark - Lifecycle

- (instancetype)init {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 20); // 设置 Item 与屏幕大小相同 ⚠️ 大小设置控制台显示有问题
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    // 设置滚动方向：水平滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SecondCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.title = @"引导页";
    
    // 设置分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO; // 取消弹簧效果
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"IMG_1183",@"IMG_1184",@"IMG_1185"];
    }
    return _dataSourceArray;
}

#pragma mark - IBActions

- (void)cellButtonDidClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.imageView.image = [UIImage imageNamed:self.dataSourceArray[indexPath.item]];
    if (indexPath.item == self.dataSourceArray.count - 1) {
        cell.button.hidden = NO;
        [cell.button addTarget:self action:@selector(cellButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        cell.button.hidden = YES;
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected %ld section,%ld item !",(long)indexPath.section,(long)indexPath.item);
}

@end
