//
//  HPMailDirectDrawCell.h
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/5.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

// 邮件状态
typedef NS_ENUM(NSUInteger, HPMailDirectDrawCellStatus) {
    HPMailDirectDrawCellStatusUnread,
    HPMailDirectDrawCellStatusRead,
    HPMailDirectDrawCellStatusReplied,
};

/**
 直接绘制视图
 */
@interface HPMailDirectDrawCell : UITableViewCell

@property (nonatomic, copy) NSString *email;   // 邮箱
@property (nonatomic, copy) NSString *subject; // 主题
@property (nonatomic, copy) NSString *date;    // 日期
@property (nonatomic, copy) NSString *snippet; // 摘要
@property (nonatomic, assign) HPMailDirectDrawCellStatus mailStatus; // 邮件状态
@property (nonatomic, assign) BOOL hasAttachment;  // 是否有附件
@property (nonatomic, assign) BOOL isMailSelected; // 是否已发送

@end
