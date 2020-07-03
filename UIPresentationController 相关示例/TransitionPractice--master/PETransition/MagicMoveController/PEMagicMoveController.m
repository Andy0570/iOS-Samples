//
//  PEMagicMoveController.m
//  PETransition
//
//  Created by Petry on 16/9/11.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PEMagicMoveController.h"
#import "PEMagicMoveCell.h"
#import "PEMagicMovePushController.h"


@interface PEMagicMoveController ()

@end

@implementation PEMagicMoveController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    //collectionView必须添加UICollectionViewFlowLayout布局配置
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(150, 180);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self = [super initWithCollectionViewLayout:layout];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"神奇移动效果";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"PEMagicMoveCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot)];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)backToRoot
{
    self.navigationController.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PEMagicMoveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _clickIndex = indexPath;
    PEMagicMovePushController *vc = [[PEMagicMovePushController alloc] init];
    //设置导航控制器的代理为推出的控制器,可以达到自定义不同控制器推出效果的目的
    self.navigationController.delegate = vc;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
