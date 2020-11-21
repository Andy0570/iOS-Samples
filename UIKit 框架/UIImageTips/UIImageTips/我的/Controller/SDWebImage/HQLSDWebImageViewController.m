//
//  HQLSDWebImageViewController.m
//  UIImageTips
//
//  Created by Qilin Hu on 2020/5/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLSDWebImageViewController.h"

// Frameworks
#import <SDWebImage.h>

// 数组，国美商城，推荐产品
#define GoodsRecommendArray  @[@"http://gfs5.gomein.net.cn/T1blDgB5CT1RCvBVdK.jpg",@"http://gfs1.gomein.net.cn/T1loYvBCZj1RCvBVdK.jpg",@"http://gfs1.gomein.net.cn/T1w5bvB7K_1RCvBVdK.jpg",@"http://gfs1.gomein.net.cn/T1w5bvB7K_1RCvBVdK.jpg",@"http://gfs6.gomein.net.cn/T1L.VvBCxv1RCvBVdK.jpg",@"http://gfs9.gomein.net.cn/T1joLvBKhT1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T1AoVvB7_v1RCvBVdK.jpg"]

// 国美商城，商品手持图像
#define GoodsHandheldImagesArray  @[@"http://gfs6.gomein.net.cn/T1CLLvBQbv1RCvBVdK.jpg",@"http://gfs6.gomein.net.cn/T1CCx_B5CT1RCvBVdK.jpg",@"http://gfs7.gomein.net.cn/T17QxvB7b_1RCvBVdK.jpg",@"http://gfs8.gomein.net.cn/T17CWsBmKT1RCvBVdK.jpg",@"http://gfs7.gomein.net.cn/T1nabsBCxT1RCvBVdK.jpg",@"http://gfs7.gomein.net.cn/T199_gBCDT1RCvBVdK.jpg",@"http://gfs7.gomein.net.cn/T1H.VsBKZT1RCvBVdK.jpg",@"http://gfs6.gomein.net.cn/T1JRW_BmLT1RCvBVdK.jpg"]

// 国美商城，Banner 图片
#define GoodsBeautySilderImagesArray @[@"http://gfs8.gomein.net.cn/T1QtA_BXdT1RCvBVdK.jpg",@"http://gfs9.gomein.net.cn/T1__ZvB7Aj1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T1SZ__B5VT1RCvBVdK.jpg"]

#define GoodsHomeSilderImagesArray @[@"slider_01",@"slider_02",@"slider_03"]

// 国美商城，底部图片
#define GoodsFooterImagesArray @[@"http://gfs5.gomein.net.cn/T1vpK_BCZT1RCvBVdK.jpg",@"http://gfs9.gomein.net.cn/T1cGK_BCZT1RCvBVdK.jpg",@"http://gfs6.gomein.net.cn/T1Kod_BCxT1RCvBVdK.jpg"]

// 国美商城，新福利
#define GoodsNewWelfareImagesArray @[@"http://gfs6.gomein.net.cn/T1.iJvBXVT1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T10_LvBjLv1RCvBVdK.jpg",@"http://gfs9.gomein.net.cn/T1ALVvBXZg1RCvBVdK.jpg"]

// 国美商城，最美小店
#define BeastBeautyShopArray @[@"http://gfs7.gomein.net.cn/T1xp_sB7KT1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T1Ao_sB7VT1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T12md_B7YT1RCvBVdK.jpg"]

// 国美商城，主页 GIF 动图
#define HomeBottomViewGIFImage @"http://gfs8.gomein.net.cn/T1RbW_BmdT1RCvBVdK.gif"



@interface HQLSDWebImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation HQLSDWebImageViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Actions

- (IBAction)loadImage:(id)sender {
    
//    NSURL *url2 = [NSURL URLWithString:@"https://gratisography.com/wp-content/uploads/2020/02/gratisography-abstract-monster-900x600.jpg"];
    NSURL *url = [NSURL URLWithString:@"https://gfs8.gomein.net.cn/T1QtA_BXdT1RCvBVdK.jpg"];
    // 通过 SDWebImage 框架加载图片
    [self.imageView sd_setImageWithURL:url
                      placeholderImage:[UIImage imageNamed:@"icon"]
                               options:SDWebImageProgressiveLoad | SDWebImageAvoidAutoSetImage | SDWebImageForceTransition | SDWebImageFromLoaderOnly
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        // SDWebImageAvoidAutoSetImage
        // SDWebImageForceTransition
        
        
        self.imageView.image =
            [image sd_roundedCornerImageWithRadius:10.0f
                                           corners:UIRectCornerAllCorners
                                       borderWidth:3.0f
                                       borderColor:[UIColor redColor]];

        // MARK: 查看图片下载来源
        switch (cacheType) {
            case SDImageCacheTypeNone:
                NSLog(@"无缓存");
                break;
            case SDImageCacheTypeDisk:
                NSLog(@"磁盘缓存");
                break;
            case SDImageCacheTypeMemory:
                NSLog(@"内存缓存");
                break;
            case SDImageCacheTypeAll:
                NSLog(@"同时来自内存缓存和磁盘缓存");
                break;
        }
    }];
    
//    self.imageView.layer.cornerRadius = 15;
//    self.imageView.layer.masksToBounds = YES;
}


@end
