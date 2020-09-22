//
//  AFCollectionViewLayoutAttributes.h
//  Cover Flow
//
//  Created by Ash Furrow on 2013-01-17.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, assign) BOOL shouldRasterize; // 光栅化
@property (nonatomic, assign) CGFloat maskingValue; // 实现 UICollectionViewCell 淡入淡出效果

@end

/**
 开启 shouldRasterize 后，CALayer 会被光栅化为 bitmap，layer 的阴影等效果也会被保存到 bitmap 中。
 */
