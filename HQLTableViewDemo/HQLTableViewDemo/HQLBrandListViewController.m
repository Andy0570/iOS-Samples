//
//  HQLBrandListViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/5/27.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLBrandListViewController.h"

// Frameworks
#import <Chameleon.h>
#import <MJRefresh.h>
#import <Masonry.h>
#import <Mantle.h>
#import <YYKit.h>

// View
#import "HQLBrandListCategoryCell.h"

#import "HQLCollectionCycleScrollView.h"
#import "HQLBrandItemCell.h"

// Model
#import "HQLBrandModel.h"

// table view cell
static NSString * const cellReuseIdentifier = @"HQLBrandListCategoryCell";

// collection view cell
static NSString * const headerReuseIdentifier = @"HQLCollectionCycleScrollView";
static NSString * const itemReuseIdentifier = @"HQLBrandItemCell";

static const CGFloat KTableViewWidth = 95.0f;

@interface HQLBrandListViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, HQLCollectionCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray <NSString *> *categoryDataSourceArray;
@property (nonatomic, copy) NSArray <NSString *> *bannerDataSourceArray;
@property (nonatomic, strong) NSArray <HQLBrandModel *> *brandDataSourceArray;

@end

@implementation HQLBrandListViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 发起网络请求，获取数据
    [self requestForCategoryData];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"商品品牌";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.equalTo(self.view);

        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view.mas_top);
        }

        make.width.mas_equalTo(KTableViewWidth);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.tableView.mas_right);
        make.top.and.bottom.mas_equalTo(self.tableView);
        make.right.equalTo(self.view.mas_right);
    }];
}

#pragma mark - Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = HexColor(@"#F9F9F9");
        _tableView.rowHeight = HQLBrandListCategoryCellHeight;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];

        _tableView.dataSource = self;
        _tableView.delegate = self;

        // 注册重用 cell
        [_tableView registerClass:[HQLBrandListCategoryCell class] forCellReuseIdentifier:cellReuseIdentifier];
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 3;
        layout.minimumLineSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = rgb(249, 249, 249);
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        // 注册重用 cell
        [_collectionView registerClass:[HQLBrandItemCell class] forCellWithReuseIdentifier:itemReuseIdentifier];
        
        // header view cell
        [_collectionView registerClass:[HQLCollectionCycleScrollView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:headerReuseIdentifier];
        
        // 设置上拉刷新控件，支持获取更多品牌
        self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestForMoreBrandData)];
    }
    return _collectionView;
}

- (NSArray<NSString *> *)categoryDataSourceArray {
    if (!_categoryDataSourceArray) {

        // 1.构造 BrandCategory.plist 文件 URL 路径
        NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        NSURL *url = [bundleURL URLByAppendingPathComponent:@"BrandCategory.plist"];
        
        // 2.读取 mainPageNavBtn.plist 文件，并存放进 jsonArray 数组
        NSArray *jsonArray;
        if (@available(iOS 11.0, *)) {
            NSError *readFileError = nil;
            jsonArray = [NSArray arrayWithContentsOfURL:url error:&readFileError];
            if (!jsonArray || jsonArray.count == 0) {
                NSLog(@"%@, NSPropertyList File read error:\n%@", @(__PRETTY_FUNCTION__), readFileError.localizedDescription);
                return nil;
            }
        } else {
            jsonArray = [NSArray arrayWithContentsOfURL:url];
            if (!jsonArray || jsonArray.count == 0) {
                NSLog(@"%@, NSPropertyList File read error.", @(__PRETTY_FUNCTION__));
                return nil;
            }
        }
        
        _categoryDataSourceArray = [NSArray arrayWithArray:jsonArray];
    }
    return _categoryDataSourceArray;
}

- (NSArray<NSString *> *)bannerDataSourceArray {
    if (!_bannerDataSourceArray) {
        _bannerDataSourceArray = @[@"https://gfs8.gomein.net.cn/T1QtA_BXdT1RCvBVdK.jpg",
                                   @"https://gfs9.gomein.net.cn/T1__ZvB7Aj1RCvBVdK.jpg",
                                   @"https://gfs5.gomein.net.cn/T1SZ__B5VT1RCvBVdK.jpg"];
    }
    return _bannerDataSourceArray;
}

- (NSArray<HQLBrandModel *> *)brandDataSourceArray {
    if (!_brandDataSourceArray) {
        
        // 1.构造 BrandModel.plist 文件 URL 路径
        NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        NSURL *url = [bundleURL URLByAppendingPathComponent:@"BrandModel.plist"];
        
        // 2.读取 BrandModel.plist 文件，并存放进 jsonArray 数组
        NSArray *jsonArray;
        if (@available(iOS 11.0, *)) {
            NSError *readFileError = nil;
            jsonArray = [NSArray arrayWithContentsOfURL:url error:&readFileError];
            if (!jsonArray || jsonArray.count == 0) {
                NSLog(@"%@, NSPropertyList File read error:\n%@", @(__PRETTY_FUNCTION__), readFileError.localizedDescription);
                return nil;
            }
        } else {
            jsonArray = [NSArray arrayWithContentsOfURL:url];
            if (!jsonArray || jsonArray.count == 0) {
                NSLog(@"%@, NSPropertyList File read error.", @(__PRETTY_FUNCTION__));
                return nil;
            }
        }
        
         // 3.将 jsonArray 数组中的 JSON 数据转换成 HQLMainPageNavBtnModel 模型
        NSError *decodeError = nil;
        _brandDataSourceArray = [MTLJSONAdapter modelsOfClass:HQLBrandModel.class
                                               fromJSONArray:jsonArray
                                                       error:&decodeError];
        if (!_brandDataSourceArray) {
            NSLog(@"%@, jsonArray decode error:\n%@", @(__PRETTY_FUNCTION__), decodeError.localizedDescription);
            return nil;
        }
    }
    return _brandDataSourceArray;
}


#pragma mark - Private

// 加载获取分类数据
- (void)requestForCategoryData {
    
    // 模拟网络请求，1s 后更新
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                            delayInSeconds *NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        // 刷新列表 UI
        [self.tableView reloadData];
        
        // 初始化默认选中第一条数据
        NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:firstIndex animated:NO scrollPosition:UITableViewScrollPositionTop];
    });
}

// 加载获取更多品类导航数据
- (void)requestForMoreBrandData {
    
    // 模拟网络请求，5s 后更新下拉刷新
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                            delayInSeconds *NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        // 刷新列表 UI
        [self.collectionView reloadData];
        
        // 没有更多数据
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    });
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryDataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HQLBrandListCategoryCell
    *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.name = (NSString *)self.categoryDataSourceArray[indexPath.row];
    
    return cell;
}


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 重新加载品类数据
    
//    HQLCategoryModel *categoryModel = self.categoryDataSourceArray[indexPath.row];
//    [self requestForCollectionDataWithCategoryId:categoryModel.ID];
    [self requestForMoreBrandData];
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.brandDataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HQLBrandItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemReuseIdentifier forIndexPath:indexPath];
    HQLBrandModel *brandModel = (HQLBrandModel *)self.brandDataSourceArray[indexPath.item];
    cell.brandModel = brandModel;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    // 添加 banner 图
    HQLCollectionCycleScrollView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
    
    // 将图片 URL 添加到 SDCycleScrollView
    NSMutableArray *imageURLArray = [NSMutableArray arrayWithCapacity:self.bannerDataSourceArray.count];
    // NSString -> NSURL
    for (NSString *urlStr in self.bannerDataSourceArray) {
        [imageURLArray addObject:[NSURL URLWithString:urlStr]];
    }
    headerView.imageGroupArray = imageURLArray;
    headerView.delegate = self;
    return headerView;
}


#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // item 宽度 = (kScreenWidth - KTableViewWidth - 5 - 5*2 - 3*2) /3
    CGFloat width = CGFloatPixelFloor((kScreenWidth - KTableViewWidth - 21) / 3);
    return CGSizeMake(width, width + 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.width, HQLCollectionCycleScrollViewHeight);
}


#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 1.找到对应的模型
    HQLBrandModel *brandModel = (HQLBrandModel *)self.brandDataSourceArray[indexPath.row];
    
    // 2.跳转到品牌主页
    NSLog(@"点击了 %@",brandModel.name);
}


#pragma mark - HQLCollectionCycleScrollViewDelegate

// 选中了某一个 Banner 图片后调用
- (void)selectedScrollViewItemAtIndex:(NSInteger)index {
    // 1.找到对应模型

    // 2.根据 URL 跳转到 Web 页面（1.10.2.2）
    NSLog(@"%ld",(long)index);
}



@end
