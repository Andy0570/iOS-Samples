//
//  HQLSwitchView.h
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/4/1.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQLSwitchView;

NS_ASSUME_NONNULL_BEGIN

@protocol HQLSwitchViewDelegate <NSObject>
- (void)switchView:(HQLSwitchView *)switchView didChangeValue:(BOOL)value;
@end

/**
 自定义 Switch 开关
 
 参考：<https://juejin.cn/post/6844903750977454088>
 */
@interface HQLSwitchView : UIView

@property (nonatomic, assign, getter=isOn) BOOL on;
@property (nonatomic, weak) id<HQLSwitchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
