//
//  HQLSharePannelView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/3/22.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLSharePannelView.h"

// View
#import "HQLSharePannelCollectionViewCell.h"

// Model
#import "HQLTableViewGroupedModel.h"

// Store
#import "HQLPropertyListStore.h"

const CGFloat HQLSharePannelViewHeight = 120.f;
static NSString * const KPlistFileName = @"shareCollectionCells.plist";
static NSString * const cellReuseIdentifier = @"HQLSharePannelCollectionViewCell";

@interface HQLSharePannelView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<HQLTableViewModel *> *items;
@property (nonatomic, assign) BOOL delegateFlag;

@end

@implementation HQLSharePannelView

#pragma mark - View life cycle

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

// 我的页面 - 4 个导航按钮的容器视图
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        // 初始化水平布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(70, HQLSharePannelCollectionViewCellHeight);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 5, 20, 5);
        
        // 初始化集合视图
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        // 注册重用 cell
        [_collectionView registerClass:[HQLSharePannelCollectionViewCell class]
            forCellWithReuseIdentifier:cellReuseIdentifier];
    }
    return _collectionView;
}

- (void)setDelegate:(id<HQLSharePannelViewDelegate>)delegate {
    _delegate = delegate;
    _delegateFlag = [delegate respondsToSelector:@selector(selectedShareItemAtIndex:)];
}

#pragma mark - Private

- (void)setupData {
    HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:KPlistFileName modelsOfClass:HQLTableViewModel.class];
    self.items = store.dataSourceArray;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

// 每组集合有几个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

// 分别配置每个元素
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HQLSharePannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.navigationItem = (HQLTableViewModel *)self.items[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegateFlag) {
        [self.delegate selectedShareItemAtIndex:indexPath.item];
    }
}

@end
