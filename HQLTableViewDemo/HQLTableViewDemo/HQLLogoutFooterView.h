//
//  HQLLogoutFooterView.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/1/20.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLLogoutFooterViewHeight;

@interface HQLLogoutFooterView : UIView
@property (nonatomic, copy) dispatch_block_t logoutButtonActionBlock;
@end

NS_ASSUME_NONNULL_END
