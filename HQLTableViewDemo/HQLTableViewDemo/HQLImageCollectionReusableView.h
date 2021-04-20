//
//  HQLImageCollectionReusableView.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/9/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 集合视图 header
 
 只包含一张 UIImageView 图片的 UICollectionReusableView
 */
@interface HQLImageCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
