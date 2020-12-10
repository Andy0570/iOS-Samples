//
//  HQLWebViewCell.h
//  WKWebViewDemo
//
//  Created by Qilin Hu on 2020/6/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HQLWebViewCellHeightUpdateBlock)(CGFloat webViewHeight);

@interface HQLWebViewCell : UITableViewCell

@property (nonatomic, copy) NSString *HTMLString;
@property (nonatomic, copy) HQLWebViewCellHeightUpdateBlock webViewCellHeightUpdateBlock;

@end

NS_ASSUME_NONNULL_END
