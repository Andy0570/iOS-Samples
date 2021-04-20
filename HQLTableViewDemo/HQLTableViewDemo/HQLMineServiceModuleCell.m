//
//  HQLMineServiceModuleCell.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/30.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMineServiceModuleCell.h"

// Framework
#import <Masonry.h>
#import <Chameleon.h>
#import <YYKit.h>

// Views
#import "HQLMineServiceNameHeaderView.h"
#import "HQLMineServiceItemCell.h"

// Models
#import "HQLTableViewGroupedModel.h"

// Store
#import "HQLPropertyListStore.h"

// 32+136
const CGFloat HQLMineServiceModuleHeight = 168.0f;
static NSString * const KPlistFileName = @"mineServiceModule.plist";
static NSString * const headerReuseIdentifier = @"HQLMineServiceNameHeaderView";
static NSString * const cellReuseIdentifier = @"HQLMineServiceItemCell";

@interface HQLMineServiceModuleCell () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<HQLTableViewModel *> *dataSourceArray;
@property (nonatomic, assign) BOOL delegateFlag;
@end

@implementation HQLMineServiceModuleCell

#pragma mark - Initialize

- (void)dealloc {
    _delegate = nil;
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupData];
        [self setupUI];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        // 初始化水平布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(HQLMineServiceItemHeight, HQLMineServiceItemHeight);
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, HQLMineServiceNameHeaderViewHeight);
        flowLayout.minimumInteritemSpacing = 20;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        
        // 初始化集合视图
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        // 注册重用 cell
        [_collectionView registerClass:[HQLMineServiceNameHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:headerReuseIdentifier];
        [_collectionView registerClass:[HQLMineServiceItemCell class]
            forCellWithReuseIdentifier:cellReuseIdentifier];
    }
    return _collectionView;
}

- (void)setDelegate:(id<HQLMineServiceModuleDelegate>)delegate {
    _delegate = delegate;
    _delegateFlag = [delegate respondsToSelector:@selector(selectServiceItemAtIndex:)];
}

#pragma mark - Private

- (void)setupData {
    HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:KPlistFileName modelsOfClass:HQLTableViewModel.class];
    self.dataSourceArray = store.dataSourceArray;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

// 每组集合有几个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

// 分别配置每个元素
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HQLMineServiceItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.navigationItem = (HQLTableViewModel *)self.dataSourceArray[indexPath.item];
    return cell;
}

// 设置头、尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reuseableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reuseableView = [self configureCollectionName:@"更多服务" atIndexPath:indexPath];
    }
    return reuseableView;
}

- (HQLMineServiceNameHeaderView *)configureCollectionName:(NSString *)name atIndexPath:(NSIndexPath *)indexPath {
    HQLMineServiceNameHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
    headerView.title = name;
    return headerView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegateFlag) {
        [self.delegate selectServiceItemAtIndex:indexPath.item];
    }
}

@end
