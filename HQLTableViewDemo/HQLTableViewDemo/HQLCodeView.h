//
//  HQLCodeView.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 自定义验证码展示视图，由一个 Label 和一个下划线组成
@interface HQLCodeView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UILabel *codeLabel; // 单个数字 Label
@property (nonatomic, strong) UIView *lineView;

@end

NS_ASSUME_NONNULL_END
