//
//  HQLSharePannelController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/3/22.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLSharePannelController.h"

// Framework
//#import <WechatOpenSDK/WXApi.h>
//#import <WechatOpenSDK/WXApiObject.h>
#import <Masonry.h>
#import <YYKit.h>

// View
#import "HQLSharePannelHeaderView.h"
#import "HQLSharePannelFooterView.h"
#import "HQLSharePannelView.h"

const CGFloat HQLSharePannelControllerHeight = 228.0f;

static NSString * const headerReuseIdentifier = @"HQLSharePannelHeaderView";
static NSString * const footerReuseIdentifier = @"HQLSharePannelFooterView";
static NSString * const cellReuseIdentifier = @"HQLSharePannelView";

@interface HQLSharePannelController () <UICollectionViewDataSource, HQLSharePannelViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HQLSharePannelController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
    
    // 添加微信回调通知
    //[WXApiManager sharedManager].delegate = self;
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 34);
    flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 40);
    flowLayout.itemSize = CGSizeMake(kScreenWidth, HQLSharePannelViewHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:HQLSharePannelHeaderView.class
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:headerReuseIdentifier];
    [self.collectionView registerClass:HQLSharePannelFooterView.class
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:footerReuseIdentifier];
    [self.collectionView registerClass:HQLSharePannelView.class
            forCellWithReuseIdentifier:cellReuseIdentifier];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottomMargin);
    }];
}

//// MARK: 1.获取图片 URL
//- (void)requestPosterImageInScene:(enum WXScene)scene {
//    HQLQuzhuanPosterRequest *request = [[HQLQuzhuanPosterRequest alloc] init];
//    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//        DDLogInfo(@"返回数据模型:\n%@",request.responseJSONObject);
//        NSNumber *code = request.responseJSONObject[@"code"];
//        if (code.intValue != 1000) {
//            DDLogError(@"%@ Response Code Error:\n%@",@(__PRETTY_FUNCTION__), request.responseJSONObject);
//            [self.view makeToast:@"分享失败"];
//            return;
//        }
//
//        NSDictionary *innerDictionary = request.responseJSONObject[@"data"];
//        NSString *urlString = innerDictionary[@"url"];
//        if ([urlString jk_isValidUrl]) {
//
//        } else {
//            [self.view makeToast:@"分享失败"];
//        }
//
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        DDLogError(@"%@, Request Error:\n%@", @(__PRETTY_FUNCTION__), request.error);
//
//        NSString *errorMsg = request.error.localizedDescription;
//        [self.view makeToast:errorMsg];
//    }];
//}
//
//// MARK: 2.下载图片
//- (UIImage *)downloadPosterImageFromURL:(NSURL *)url {
//    __block UIImage *resultImage;
//    [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageHighPriority progress:NULL completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//
//        if (error) {
//            resultImage = [UIImage imageNamed:@"Mine_avator_default"];
//        } else {
//            resultImage = image;
//        }
//    }];
//    return resultImage;
//}
//
//// MARK: 3.分享图片到聊天界面
//- (void)SendWeChatImageShareRequest:(NSString *)urlString inScene:(enum WXScene)scene {
//    UIImage *image = [self downloadPosterImageFromURL:[NSURL URLWithString:urlString]];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
//
//    // 发送 Image 消息给微信
//    [WXApiRequestHandler sendImageData:imageData tagName:NULL messageExt:NULL action:NULL thumbImage:NULL inScene:scene];
//}

#pragma mark - UICollectionViewDataSource

// 每组集合有几个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

// 分别配置每个元素
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HQLSharePannelView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

// 设置头、尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reuseableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 设置 header view
        HQLSharePannelHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
        reuseableView = headerView;
    } else  if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        // 设置 foot view
        HQLSharePannelFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerReuseIdentifier forIndexPath:indexPath];
        __weak __typeof(self)weakSelf = self;
        footerView.cancelButtonActionBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:NULL];
        };
        reuseableView = footerView;
    }
    return reuseableView;
}

#pragma mark - HQLSharePannelViewDelegate

- (void)selectedShareItemAtIndex:(NSInteger)index {
//    enum WXScene scene = ((selectedIndex == 0) ? WXSceneSession : WXSceneTimeline);
//    [self requestPosterImageInScene:scene];
}

#pragma mark - WXApiManagerDelegate

//- (void)managerDidReceiveMessageResponse:(SendMessageToWXResp *)response {
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}

@end
