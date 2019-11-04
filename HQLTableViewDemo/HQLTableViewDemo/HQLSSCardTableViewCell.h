//
//  HQLSSCardTableViewCell.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/12/27.
//  Copyright © 2018 ToninTech. All rights reserved.
//

#import "MGSwipeTableCell.h"

UIKIT_EXTERN const CGFloat HQLSSCardTableViewCellHeight;

NS_ASSUME_NONNULL_BEGIN

/**
 社会保障卡卡包 cell
 
 元素：Logo、Title、姓名、身份证号码
 */
@interface HQLSSCardTableViewCell : MGSwipeTableCell

@property (nonatomic, strong) UILabel *idNumberLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *cardTypeLabel;
@property (nonatomic, strong) UIImageView *cardSelectedImageView; // 💡 添加「使用中...」的标识符

@end

NS_ASSUME_NONNULL_END
