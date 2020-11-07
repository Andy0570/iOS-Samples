//
//  HQLCommentTableViewCell.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/13.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HQLTopic, HQLComment, HQLUser;

@protocol HQLCommentTableViewCellDelegate <NSObject>

@optional
/// 点击评论中的用户昵称
- (void)commentTableViewCellDidTappedUser:(HQLUser *)user;

/// 点击话题文本内容，直接回复
- (void)commentTableViewCellDidTappedContent:(HQLTopic *)topic;

/// 点击展开/收起，更新列表高度
- (void)commentTableViewCellUpdateHeight;

/// 更多按钮
- (void)commentTableViewCellDidClickedMoreButton;

/// 点赞按钮
- (void)commentTableViewCellDidClickedThumbButton:(UIButton *)thumbButton;

/// 点击“共x条回复”，显示单条评论详情
- (void)commentTableViewCellDidClickedMoreCommentButton:(HQLTopic *)topic;

@end

/// 评论回复 cell
@interface HQLCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) HQLTopic *topic;
@property (nonatomic, weak) id<HQLCommentTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
