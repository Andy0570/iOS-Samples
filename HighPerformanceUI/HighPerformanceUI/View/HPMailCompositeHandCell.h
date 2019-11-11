//
//  HPMailCompositeHandCell.h
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/6.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPMailModel;

UIKIT_EXTERN const CGFloat HPMailCompositeHandCellHeight;

/**
 复合视图，手写代码
 */
@interface HPMailCompositeHandCell : UITableViewCell

@property (nonatomic, strong) HPMailModel *model;

@end
