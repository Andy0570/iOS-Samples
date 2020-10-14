//
//  HQLCommentCell.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HQLUser, HQLComment;

@protocol HQLCommentCellDelegate <NSObject>
@optional
/// 点击评论中的用户昵称
- (void)commentCellDidTappedUser:(HQLUser *)user;
@end

@interface HQLCommentCell : UITableViewCell

@property (nonatomic, strong) HQLComment *comment;
@property (nonatomic, weak) id<HQLCommentCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
