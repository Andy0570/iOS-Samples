//
//  SDMasterViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/9/12.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "SDMasterViewController.h"
#import "SDDetailViewController.h"
#import "PINDetailViewController.h"

#import <SDWebImage/SDWebImage.h>

@interface MyCustomTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *customTextLabel;
@property (nonatomic, strong) SDAnimatedImageView *customImageView;
@end

@implementation MyCustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _customImageView = [[SDAnimatedImageView alloc] initWithFrame:CGRectMake(20.0, 2.0, 60.0, 40.0)];
        _customImageView.contentMode = UIViewContentModeScaleAspectFill;
        _customImageView.clipsToBounds = YES;
        [self.contentView addSubview:_customImageView];
        
        _customTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 12.0, 200.0, 20.0)];
        [self.contentView addSubview:_customTextLabel];
    }
    return self;
}

@end


@interface SDMasterViewController ()
@property (nonatomic, strong) NSMutableArray<NSString *> *objects;
@end

@implementation SDMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"SDWebImage";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"clear Cache" style:UIBarButtonItemStylePlain target:self action:@selector(flushCache)];
    
    [self.tableView registerClass:MyCustomTableViewCell.class forCellReuseIdentifier:@"Cell"];
    
    //[self setupHTTPNTLMAuth];
    [self setupDataSources];
}

// HTTP NTLM auth example
// Add your NTLM image url to the array below and replace the credentials
- (void)setupHTTPNTLMAuth {
    [SDWebImageDownloader sharedDownloader].config.username = @"httpwatch";
    [SDWebImageDownloader sharedDownloader].config.password = @"httpwatch01";
    [[SDWebImageDownloader sharedDownloader] setValue:@"SDWebImage Demo" forHTTPHeaderField:@"AppName"];
    [SDWebImageDownloader sharedDownloader].config.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
}

- (void)setupDataSources {
    self.objects = [NSMutableArray arrayWithObjects:
                @"http://www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx?0.35786508303135633",     // requires HTTP auth, used to demo the NTLM auth
                @"http://assets.sbnation.com/assets/2512203/dogflops.gif",
                @"https://raw.githubusercontent.com/liyong03/YLGIFImage/master/YLGIFImageDemo/YLGIFImageDemo/joy.gif",
                @"http://apng.onevcat.com/assets/elephant.png",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp",
                @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
                @"http://littlesvr.ca/apng/images/SteamEngine.webp",
                @"http://littlesvr.ca/apng/images/world-cup-2014-42.webp",
                @"https://isparta.github.io/compare-webp/image/gif_webp/webp/2.webp",
                @"https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic",
                @"https://nokiatech.github.io/heif/content/image_sequences/starfield_animation.heic",
                @"https://s2.ax1x.com/2019/11/01/KHYIgJ.gif",
                @"https://raw.githubusercontent.com/icons8/flat-color-icons/master/pdf/stack_of_photos.pdf",
                @"https://nr-platform.s3.amazonaws.com/uploads/platform/published_extension/branding_icon/275/AmazonS3.png",
                @"http://via.placeholder.com/200x200.jpg",
                nil];
    
    for (int i=1; i<25; i++) {
        // From http://r0k.us/graphics/kodak/, 768x512 resolution, 24 bit depth PNG
        [self.objects addObject:[NSString stringWithFormat:@"http://r0k.us/graphics/kodak/kodak/kodim%02d.png", i]];
    }
    
    // 国美商城，推荐产品
    NSArray *GoodsRecommendArray =  @[@"http://gfs5.gomein.net.cn/T1blDgB5CT1RCvBVdK.jpg",
                                      @"http://gfs1.gomein.net.cn/T1loYvBCZj1RCvBVdK.jpg",
                                      @"http://gfs1.gomein.net.cn/T1w5bvB7K_1RCvBVdK.jpg",
                                      @"http://gfs1.gomein.net.cn/T1w5bvB7K_1RCvBVdK.jpg",
                                      @"http://gfs6.gomein.net.cn/T1L.VvBCxv1RCvBVdK.jpg",
                                      @"http://gfs9.gomein.net.cn/T1joLvBKhT1RCvBVdK.jpg",
                                      @"http://gfs5.gomein.net.cn/T1AoVvB7_v1RCvBVdK.jpg"];

    // 国美商城，商品手持图像
    NSArray *GoodsHandheldImagesArray =  @[@"http://gfs6.gomein.net.cn/T1CLLvBQbv1RCvBVdK.jpg",
                                           @"http://gfs6.gomein.net.cn/T1CCx_B5CT1RCvBVdK.jpg",
                                           @"http://gfs7.gomein.net.cn/T17QxvB7b_1RCvBVdK.jpg",
                                           @"http://gfs8.gomein.net.cn/T17CWsBmKT1RCvBVdK.jpg",
                                           @"http://gfs7.gomein.net.cn/T1nabsBCxT1RCvBVdK.jpg",
                                           @"http://gfs7.gomein.net.cn/T199_gBCDT1RCvBVdK.jpg",
                                           @"http://gfs7.gomein.net.cn/T1H.VsBKZT1RCvBVdK.jpg",
                                           @"http://gfs6.gomein.net.cn/T1JRW_BmLT1RCvBVdK.jpg",
                                           @"http://bizweb.dktcdn.net/100/364/149/files/persian-cat-dribbble.jpg",@"http://bizweb.dktcdn.net/100/364/149/files/90718184-652759422187425-6277242767806562304-n.jpg"];
    
    // GIF 图片
    NSArray *gifImages = @[@"http://gfs8.gomein.net.cn/T1RbW_BmdT1RCvBVdK.gif",@"https://media.giphy.com/media/r1IMdmkhUcpzy/giphy.gif?cid=ecf05e476c4ae43bc709d570be544c40d6d870b687244d7e&rid=giphy.gif&ct=g",@"https://n.sinaimg.cn/tech/transform/407/w186h221/20210910/9160-4c678d61c047c1d1d2141493949701f7.gif",@"https://imgur.com/jK5DXaB",@"https://www.negui.com/s/br/br7sx.gif",@"https://www.negui.com/s/7x/7x6m2.gif",@"https://www.negui.com/s/ad/ad0u3.gif",@"https://static.wixstatic.com/media/4cbe8d_f1ed2800a49649848102c68fc5a66e53~mv2.gif",@"http://www.fzlkz.com/uploads/allimg/c150905/14414293AK940-2Z02.jpg",@"http://www.fzlkz.com/uploads/allimg/c150905/14414293A94T0-MD1.jpg"];
    
    [self.objects addObjectsFromArray:GoodsRecommendArray];
    [self.objects addObjectsFromArray:GoodsHandheldImagesArray];
    [self.objects addObjectsFromArray:gifImages];
    
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)flushCache {
    [SDWebImageManager.sharedManager.imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    static UIImage *placeholderImage = nil;
    if (!placeholderImage) {
        placeholderImage = [UIImage imageNamed:@"placeholder_image"];
    }
    
    MyCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[MyCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.customImageView.sd_imageTransition = SDWebImageTransition.fadeTransition;
        cell.customImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayIndicator;
    }
    
    cell.customTextLabel.text = [NSString stringWithFormat:@"Image #%ld", (long)indexPath.row];
    __weak SDAnimatedImageView *imageView = cell.customImageView;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.objects[indexPath.row]] placeholderImage:placeholderImage options:0 context:@{SDWebImageContextImageThumbnailPixelSize : @(CGSizeMake(180, 120))} progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        SDWebImageCombinedOperation *operation = [imageView sd_imageLoadOperationForKey:imageView.sd_latestOperationKey];
        SDWebImageDownloadToken *token = operation.loaderOperation;
        if (@available(iOS 10.0, *)) {
            NSURLSessionTaskMetrics *metrics = token.metrics;
            if (metrics) {
                printf("Metrics: %s download in (%f) seconds\n", [imageURL.absoluteString cStringUsingEncoding:NSUTF8StringEncoding], metrics.taskInterval.duration);
            }
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *largeImageURLString = [self.objects[indexPath.row] stringByReplacingOccurrencesOfString:@"small" withString:@"source"];
    NSURL *largeImageURL = [NSURL URLWithString:largeImageURLString];
    
    SDDetailViewController *detailViewController = [[SDDetailViewController alloc] init];
    detailViewController.imageURL = largeImageURL;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
//    PINDetailViewController *detailViewController = [[PINDetailViewController alloc] init];
//    detailViewController.imageURL = largeImageURL;
//    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
