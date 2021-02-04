//
//  UIImageView+HQLWebCache.m
//  UIImageTips
//
//  Created by Qilin Hu on 2020/5/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "UIImageView+HQLWebCache.h"

// Frameworks
#import <SDWebImage.h>

@implementation UIImageView (HQLWebCache)

- (void)hql_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
               cornerRadius:(CGFloat)cornerRadius {
    // 1. 如果图像不需要切圆角
    if (cornerRadius == 0.0) {
        [self sd_setImageWithURL:url placeholderImage:placeholder];
        return;
    }
    
    // 2. 图像需要切圆角
    // 2.1 尝试从缓存中获取是否存在已经被切成圆角的图片
    NSURL *cacheURL = [url URLByAppendingPathComponent:@"radiusCache"];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheURL.absoluteString];
    if (cacheImage) {
        self.image = cacheImage;
        return;
    }
    
    // 2.2 从网络获取原图
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:SDWebImageProgressiveLoad
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            // 先调整大小
            UIImage *resizedImage = [image sd_resizedImageWithSize:self.bounds.size scaleMode:SDImageScaleModeAspectFill];
            // 再切圆角
            UIImage *radiusImage =
                [resizedImage sd_roundedCornerImageWithRadius:cornerRadius
                                                      corners:UIRectCornerAllCorners
                                                  borderWidth:1.0f
                                                  borderColor:[UIColor redColor]];
            self.image = radiusImage;
            
            // 需要重新缓存切成圆角的图片
            [[SDImageCache sharedImageCache] storeImage:radiusImage forKey:cacheURL.absoluteString completion:nil];
            
            // 清除原有非圆角图片缓存
            [[SDImageCache sharedImageCache] removeImageForKey:url.absoluteString withCompletion:nil];
            
        }
    }];
    
}
@end
