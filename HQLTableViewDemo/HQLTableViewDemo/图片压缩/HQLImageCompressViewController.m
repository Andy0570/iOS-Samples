//
//  HQLImageCompressViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/9/17.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLImageCompressViewController.h"
#import "UIImage+Compress.h"
#import <JKCategories.h>

@interface HQLImageCompressViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation HQLImageCompressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectMake(0, 0, 200, 200);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:imageView];
    imageView.center = self.view.center;
    self.imageView = imageView;
    
    [self testImageCompress2];
}

// 测试图片压缩
- (void)testImageCompress1 {
    // 原始图片参数，1.7MB，1125x1440
    UIImage *image = [UIImage imageNamed:@"38732428.png"];
    self.imageView.image = image;
    
    // CGImageGet... 方法获取图片宽高
    CGFloat fixelWidth = CGImageGetWidth(image.CGImage);
    CGFloat fixelHeight = CGImageGetHeight(image.CGImage);
    NSLog(@"原始图片尺寸：{%f, %f}", fixelWidth, fixelHeight);
    // 原始图片尺寸：{1125.000000, 1440.000000}
    
    NSData *data = UIImagePNGRepresentation(image);
    NSLog(@"原始图片字节大小：%ld", data.length);
    // 原始图片字节大小：2051012
    
    // 1TB=1024GB、1GB=1024MB、1MB=1024KB、1KB=1024byte、1byte=8bit
    UIImage *compressImage = [image compressWithQulitySize:1024*1024]; // 1MB = 1048576
    NSData *compressImageData = UIImageJPEGRepresentation(compressImage, 1.0);
    NSLog(@"压缩图片字节大小 = %ld",compressImageData.length);
    // 压缩图片字节大小 = 807870
}

// 测试图片压缩
// !!!: 实际测试，把图片压缩获得的 NSData 数据转换为 UIImage 数据后，图片字节会变大
- (void)testImageCompress2 {
    // 原始图片参数，1.7MB，1125x1440
    UIImage *image = [UIImage imageNamed:@"38732428.png"];
    self.imageView.image = image;
    
    // CGImageGet... 方法获取图片宽高
    CGFloat fixelWidth = CGImageGetWidth(image.CGImage);
    CGFloat fixelHeight = CGImageGetHeight(image.CGImage);
    NSLog(@"原始图片尺寸：{%f, %f}", fixelWidth, fixelHeight);
    // 原始图片尺寸：{1125.000000, 1440.000000}
    
    NSData *data = UIImagePNGRepresentation(image);
    NSLog(@"原始图片字节大小：%ld", data.length);
    // 原始图片字节大小：2051012
    
    /**
    // 1TB=1024GB、1GB=1024MB、1MB=1024KB、1KB=1024byte、1byte=8bit
    NSData *compressImageData = [UIImage jk_compressImage:image toBytes:1024*1024]; // 1MB = 1048576
    NSLog(@"压缩图片字节大小 = %ld",compressImageData.length);
    // 压缩图片字节大小 = 549030
    
    // Data -> UIImage
    UIImage *compressImage = [UIImage imageWithData:compressImageData];
    self.imageView.image = compressImage;
    
    // UIImage -> PNG Data
    NSData *compressImageData2 = UIImagePNGRepresentation(compressImage);
    NSLog(@"压缩图片字节大小 = %ld",compressImageData2.length);
    // 压缩图片字节大小 = 2134135
    
    // UIImage -> JPEG Data 
    NSData *compressImageData3 = UIImageJPEGRepresentation(compressImage, 1.0);
    NSLog(@"压缩图片字节大小 = %ld",compressImageData3.length);
    // 压缩图片字节大小 = 807870
     */
}

@end
