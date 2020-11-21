//
//  AFCollectionViewLayoutAttributes.h
//  Dimensions
//
//  Created by Ash Furrow on 2013-01-13.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

// 新增属性的枚举类型，图片的布局方式
typedef enum : NSUInteger{
    AFCollectionViewFlowLayoutModeAspectFit,    //Default
    AFCollectionViewFlowLayoutModeAspectFill
}AFCollectionViewFlowLayoutMode;

/**
 !!!: 子类化 UICollectionViewLayoutAttributes ，新增自定义属性
 */
@interface AFCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, assign) AFCollectionViewFlowLayoutMode layoutMode;

@end
