//
//  HQLMyStoreCollectionViewController.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/9/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMyStoreCollectionViewController.h"
#import "HQLMyStoreCollectionViewController+NavigationBar.h"

// Framework
#import <Masonry.h>
#import <Chameleon.h>
#import <YYKit.h>

// View
#import "HQLImageCollectionReusableView.h"
#import "HQLMineServiceModuleCell.h"
#import "HQLStoreManagerModuleCell.h"

static NSString * const headerReuseIdentifier = @"HQLImageCollectionReusableView";
static NSString * const serviceModuleReuseIdentifier = @"HQLMineServiceModuleCell";
static NSString * const storeManagerModuleReuseIdentifier = @"HQLStoreManagerModuleCell";

// 通过屏幕分辨率高度判断是否为刘海屏
#define IS_NOTCH_SCREEN \
([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) \
&& (([[UIScreen mainScreen] bounds].size.height == 812.0f) \
|| ([[UIScreen mainScreen] bounds].size.height == 896.0f))

@interface HQLMyStoreCollectionViewController () <HQLMineServiceModuleDelegate, HQLStoreManagerModuleDelegate>

@property (nonatomic, assign) CGFloat defaultOffSetY;

@end

@implementation HQLMyStoreCollectionViewController

#pragma mark - Initialize

- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        _defaultOffSetY = IS_NOTCH_SCREEN ? 88 : 64;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hql_defaultNavigationBarStyle];
    [self setupCollectionView];
}

#pragma mark - Private

- (void)setupCollectionView {
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma clang diagnostic pop
    }
    
    // 设置 Collection View 向上偏移量，让图片置顶到状态栏
//    CGFloat top = self.defaultOffSetY;
//    self.collectionView.contentInset = UIEdgeInsetsMake(-top, 0, 0, 0);
    
    self.collectionView.backgroundColor = HexColor(@"#F5F5F9");
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self.collectionView registerClass:[HQLImageCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier];
    [self.collectionView registerClass:[HQLMineServiceModuleCell class]
            forCellWithReuseIdentifier:serviceModuleReuseIdentifier];
    [self.collectionView registerClass:[HQLStoreManagerModuleCell class]
            forCellWithReuseIdentifier:storeManagerModuleReuseIdentifier];
}

// 每个控件执行前都要先判断用户是否登录
- (BOOL)isUserLogin {
    return YES;
}

#pragma mark - <UICollectionViewDataSource>

// 一共有多少组集合
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

// 每组集合有几个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

// 分别配置每个元素
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    switch (indexPath.section) {
        case 0: {
            // 更多服务
            HQLMineServiceModuleCell *serviceModuleCell = [collectionView dequeueReusableCellWithReuseIdentifier:serviceModuleReuseIdentifier forIndexPath:indexPath];
            serviceModuleCell.delegate = self;
            cell = serviceModuleCell;
            break;
        }
        case 1: {
            // 店长特权
            HQLStoreManagerModuleCell *storeManagerModuleCell = [collectionView dequeueReusableCellWithReuseIdentifier:storeManagerModuleReuseIdentifier forIndexPath:indexPath];
            storeManagerModuleCell.delegate = self;
            cell = storeManagerModuleCell;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

// 设置头、尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reuseableView;
    BOOL isHeaderView = [kind isEqualToString:UICollectionElementKindSectionHeader];
    if (isHeaderView) {
        HQLImageCollectionReusableView *imageResuableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
        imageResuableView.imageName = @"myStore_header";
        reuseableView = imageResuableView;
    }
    return reuseableView;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

// 设置集合元素大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            // 更多服务
            return CGSizeMake(kScreenWidth, HQLMineServiceModuleHeight);
            break;
        case 1:
            // 店长特权
            return CGSizeMake(kScreenWidth, HQLStoreManagerModuleHeight);
            break;
        default:
            return CGSizeZero;
            break;
    }
}

// 设置头、尾视图尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return CGSizeMake(kScreenWidth, 230);
            break;
        default:
            return CGSizeZero;
            break;
    }
}

#pragma mark - <HQLMineServiceModuleDelegate>

- (void)selectServiceItemAtIndex:(NSInteger)selectedIndex {
    if (![self isUserLogin]) return;
        
    switch (selectedIndex) {
        case 0: { // 扫码核销
            
            
            break;
        }
        case 1: { // 奖金提现
            
            
            break;
        }
        case 2: { // 银行卡
            
            
            break;
        }
        case 3: { // 销售曲线
            
            
            break;
        }
        case 4: { // 奖金记录
            
            
            break;
        }
        case 5: { // 奖金查询
            
            
            break;
        }
        case 6: { // 核销记录
            
            
            break;
        }
        default:
            break;
    }
}


#pragma mark - <HQLStoreManagerModuleDelegate>

- (void)selectStoreManagerItemAtIndex:(NSInteger)selectedIndex {
    if (![self isUserLogin]) return;
        
    switch (selectedIndex) {
        case 0: {
            // 营业收入
            
            break;
        }
        case 1: {
            // 业绩曲线
            
            break;
        }
        case 2: {
            // 申请记录
            
            break;
        }
        case 3: {
            // 提现申请
            
            break;
        }
        default:
            break;
    }
}

@end
