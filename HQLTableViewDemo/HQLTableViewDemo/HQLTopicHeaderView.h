//
//  HQLTopicHeaderView.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HQLUser, HQLTopic;

@protocol HQLTopicHeaderViewDelegate <NSObject>

@optional

/// 点击头像或者昵称的回调
- (void)topicHeaderViewDidClickedUser:(HQLUser *)user;

/// 点击话题文本的回调
- (void)topicHeaderViewDidClickedContent:(HQLTopic *)topic;

/// 点击更多按钮
- (void)topicHeaderViewDidClickedMoreButton;

/// 点击点赞按钮
- (void)topicHeaderViewDidClickedThumbButton:(UIButton *)thumbButton;

@end

@interface HQLTopicHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) HQLTopic *topic;
@property (nonatomic, weak) id<HQLTopicHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
