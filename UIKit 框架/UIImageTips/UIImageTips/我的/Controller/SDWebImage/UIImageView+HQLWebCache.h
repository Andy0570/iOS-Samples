//
//  UIImageView+HQLWebCache.h
//  UIImageTips
//
//  Created by Qilin Hu on 2020/5/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 # UIImageView 的扩展
 
 # 功能特性
 1. 通过 SDWebImage 下载图片并缓存
 2. 调整图片大小、切圆角、缓存
 
 */
@interface UIImageView (HQLWebCache)

- (void)hql_setImageWithURL:(nullable NSURL *)url
           placeholderImage:(nullable UIImage *)placeholder
               cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
