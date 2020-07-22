//
//  HQLTableIndexView.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 索引 label 的 tag 值
UIKIT_EXTERN const NSInteger HQLTableIndexViewTag;
// 动画的半径
UIKIT_EXTERN const CGFloat HQLTableIndexViewAnimationRadius;
// 透明变化率
UIKIT_EXTERN const CGFloat HQLTableIndexViewAlphaRate;

typedef void(^HQLTableIndexViewSelectedBlock)(NSInteger index);

@interface HQLTableIndexView : UIView

@property (nonatomic, readwrite, copy) NSArray *indexNames;
@property (nonatomic, copy) HQLTableIndexViewSelectedBlock selectedBlock;

@end

NS_ASSUME_NONNULL_END
