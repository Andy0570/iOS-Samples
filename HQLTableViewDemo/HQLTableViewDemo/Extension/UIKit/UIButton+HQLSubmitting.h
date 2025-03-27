//
//  UIButton+HQLSubmitting.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/6/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 参考 UIButton+Submitting.h
 
 需要将提交时的按钮背景颜色设置为主题色
 */
@interface UIButton (HQLSubmitting)

/**
 *  @author foxsofter, 15-04-02 15:04:59
 *
 *  @brief  按钮点击后，禁用按钮并在按钮上显示ActivityIndicator，以及title
 *
 *  @param title 按钮上显示的文字
 */
- (void)hql_beginSubmitting:(NSString *)title;

/**
 *  @author foxsofter, 15-04-02 15:04:13
 *
 *  @brief  按钮点击后，恢复按钮点击前的状态
 */
- (void)hql_endSubmitting;

/**
 *  @author foxsofter, 15-04-02 15:04:17
 *
 *  @brief  按钮是否正在提交中
 */
@property(nonatomic, readonly, getter=isHQLSubmitting) NSNumber *hql_submitting;

@end

NS_ASSUME_NONNULL_END
