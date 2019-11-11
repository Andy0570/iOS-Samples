//
//  RGCardCollectionViewController.m
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/26.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "RGCardCollectionViewController.h"

// View
#import "RGCardCollectionViewCell.h"

#import "RGCardViewLayout.h"

@interface RGCardCollectionViewController ()

@end

@implementation RGCardCollectionViewController

static NSString * const reuseIdentifier = @"RGCardCollectionViewCell";

- (instancetype)init {
    RGCardViewLayout *layout = [[RGCardViewLayout alloc] init];
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RGCardCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.title = @"3D效果卡片切换";
    self.collectionView.backgroundColor = [UIColor colorWithRed:123/255.0 green:75/255.0 blue:106/255.0 alpha:1.0];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RGCardCollectionViewCell *cell = (RGCardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell withIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(RGCardCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"i1"];
            cell.titleLabel.text = @"Glaciers";
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"i2"];
            cell.titleLabel.text = @"Parrots";
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"i3"];
            cell.titleLabel.text = @"Whales";
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"i4"];
            cell.titleLabel.text = @"Lake View";
            break;
        case 4:
            cell.imageView.image = [UIImage imageNamed:@"i5"];
            cell.titleLabel.text = @"Snow";
            break;
        default:
            break;
    }
}

@end
