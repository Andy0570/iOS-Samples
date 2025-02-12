//
//  HQLCommentTableViewCell.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/13.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCommentTableViewCell.h"

// Framework
#import <YYKit.h>
#import <Masonry.h>
#import <SDWebImage.h>

// View
#import "HQLCommentsView.h"

// Model
#import "HQLUser.h"
#import "HQLComment.h"
#import "HQLTopic.h"

// 缓存委托对象是否能响应特定的选择子
typedef struct {
    unsigned int respondsToTappedUserDelegate  : 1;
    unsigned int respondsToTappedContentDelegate  : 1;
    unsigned int respondsToUpdateCellHeightDelegate : 1;
    unsigned int respondsToMoreButtonActionDelegate : 1;
    unsigned int respondsToThumbButtonActionDelegate : 1;
    unsigned int respondsToMoreCommentButtonDelegate: 1;
} DelegateFlags;

@interface HQLCommentTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) YYLabel *nicknameLabel;
@property (nonatomic, strong) YYLabel *createDateTimeLabel;
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) UIButton *expandButton;
@property (nonatomic, strong) UIButton *thumbButton;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) HQLCommentsView *commentsView;

// 缓存标志
@property (nonatomic, assign) DelegateFlags delegateFlag;

@end

@implementation HQLCommentTableViewCell

#pragma mark - Initialize

- (void)dealloc {
    self.delegate = nil;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.avatarImageView.image = nil;
    self.nicknameLabel.text = nil;
    self.createDateTimeLabel.text = nil;
    self.contentLabel.text = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _avatarImageView.layer.cornerRadius = 15.0f;
        _avatarImageView.layer.masksToBounds = YES;
        
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarOrNicknameDidClicked)];
        [_avatarImageView addGestureRecognizer:tap];
    }
    return _avatarImageView;
}

- (YYLabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [[YYLabel alloc] init];
        _nicknameLabel.font = [UIFont systemFontOfSize:10.0f weight:UIFontWeightMedium];
        _nicknameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        
        __weak __typeof(self)weakSelf = self;
        _nicknameLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [weakSelf avatarOrNicknameDidClicked];
        };
    }
    return _nicknameLabel;
}

- (YYLabel *)createDateTimeLabel {
    if (!_createDateTimeLabel) {
        _createDateTimeLabel = [[YYLabel alloc] init];
        _createDateTimeLabel.font = [UIFont systemFontOfSize:10.0f weight:UIFontWeightMedium];
        _createDateTimeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _createDateTimeLabel;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15.0f];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _contentLabel.numberOfLines = 6;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.preferredMaxLayoutWidth = kScreenWidth - 60.0f;
        
        __weak __typeof(self)weakSelf = self;
        _contentLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [weakSelf contentDidClicked];
        };
    }
    return _contentLabel;
}

- (UIButton *)expandButton {
    if (!_expandButton) {
        _expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
            NSForegroundColorAttributeName:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000]
        };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"展开" attributes:attributes];
        [_expandButton setAttributedTitle:normalTitle forState:UIControlStateNormal];
        
        NSAttributedString *selectedTitle = [[NSAttributedString alloc] initWithString:@"收起" attributes:attributes];
        [_expandButton setAttributedTitle:selectedTitle forState:UIControlStateSelected];
        
        [_expandButton addTarget:self action:@selector(expandButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expandButton;
}

- (UIButton *)thumbButton {
    if (!_thumbButton) {
        _thumbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _thumbButton.adjustsImageWhenHighlighted = NO;

        [_thumbButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_thumbButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _thumbButton.titleLabel.font = [UIFont systemFontOfSize:10.0f weight:UIFontWeightMedium];
        
        [_thumbButton setImage:[UIImage imageNamed:@"comment_zan_normal"] forState:UIControlStateNormal];
        [_thumbButton setImage:[UIImage imageNamed:@"comment_zan_selected"] forState:UIControlStateSelected];
        
        [_thumbButton addTarget:self action:@selector(thumbButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thumbButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"comment_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (HQLCommentsView *)commentsView {
    if (!_commentsView) {
        _commentsView = [[HQLCommentsView alloc] initWithFrame:CGRectZero];
    }
    return _commentsView;
}

- (void)setTopic:(HQLTopic *)topic {
    _topic = topic;
    
    [self renderUI];
}

- (void)setDelegate:(id<HQLCommentTableViewCellDelegate>)delegate {
    _delegate = delegate;
    
    // 提前缓存方法的响应能力
    _delegateFlag.respondsToTappedUserDelegate = [delegate respondsToSelector:@selector(commentTableViewCellDidTappedUser:)];
    _delegateFlag.respondsToTappedContentDelegate = [delegate respondsToSelector:@selector(commentTableViewCellDidTappedContent:)];
    _delegateFlag.respondsToUpdateCellHeightDelegate = [delegate respondsToSelector:@selector(commentTableViewCellUpdateHeight)];
    _delegateFlag.respondsToMoreButtonActionDelegate = [delegate respondsToSelector:@selector(commentTableViewCellDidClickedMoreButton)];
    _delegateFlag.respondsToThumbButtonActionDelegate = [delegate respondsToSelector:@selector(commentTableViewCellDidClickedThumbButton:)];
    _delegateFlag.respondsToMoreCommentButtonDelegate = [delegate respondsToSelector:@selector(commentTableViewCellDidClickedMoreCommentButton:)];
}

#pragma mark - Actions

- (void)avatarOrNicknameDidClicked {
    if (_delegateFlag.respondsToTappedUserDelegate) {
        [self.delegate commentTableViewCellDidTappedUser:self.topic.user];
    }
}

- (void)contentDidClicked {
    if (_delegateFlag.respondsToTappedContentDelegate) {
        [self.delegate commentTableViewCellDidTappedContent:self.topic];
    }
}

- (void)moreButtonAction:(UIButton *)moreButton {
    if (_delegateFlag.respondsToMoreButtonActionDelegate) {
        [self.delegate commentTableViewCellDidClickedMoreButton];
    }
}

- (void)thumbButtonAction:(UIButton *)thumbButton {
    if (_delegateFlag.respondsToThumbButtonActionDelegate) {
        [self.delegate commentTableViewCellDidClickedThumbButton:thumbButton];
    }
}

- (void)expandButtonAction:(UIButton *)expandButton {
    expandButton.selected = !expandButton.isSelected;
    self.contentLabel.numberOfLines = expandButton.isSelected ? 0 : 6;
    
    if (_delegateFlag.respondsToUpdateCellHeightDelegate) {
        [self.delegate commentTableViewCellUpdateHeight];
    }
}

- (void)moreCommentsButtonAction:(id *)sender {
    if (_delegateFlag.respondsToMoreCommentButtonDelegate) {
        [self.delegate commentTableViewCellDidClickedMoreCommentButton:self.topic];
    }
}

#pragma mark - Private

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.avatarImageView];
    
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.createDateTimeLabel];
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentView addSubview:self.expandButton];
    [self.contentView addSubview:self.moreButton];
    [self.contentView addSubview:self.thumbButton];
    
    [self.contentView addSubview:self.commentsView];
    
    CGFloat padding = 10.0f;
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(padding);
        make.left.mas_equalTo(self.contentView).with.offset(padding);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView);
        make.left.mas_equalTo(self.avatarImageView.mas_right).with.offset(padding);
        make.height.mas_equalTo(@15);
        make.right.greaterThanOrEqualTo(self.thumbButton.mas_left).with.offset(padding);
    }];
    
    [self.createDateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nicknameLabel.mas_bottom);
        make.left.mas_equalTo(self.nicknameLabel);
        make.height.mas_equalTo(@15);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(self.nicknameLabel);
        make.right.mas_equalTo(self.contentView).with.offset(-padding);
    }];
    
    [self.expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(padding);
        make.left.mas_equalTo(self.contentLabel);
        make.height.mas_equalTo(@18);
        make.bottom.mas_equalTo(self.commentsView.mas_top).with.offset(-padding);
    }];
        
    [self.commentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).with.offset(padding).priorityLow();
        make.left.and.right.mas_equalTo(self.contentLabel);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-padding);
    }];

    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avatarImageView);
        make.right.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(24, 15));
    }];
    
    [self.thumbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avatarImageView);
        make.right.mas_equalTo(self.moreButton.mas_left);
        make.height.mas_equalTo(@15);
    }];
}

- (void)renderUI {
    // 头像
    UIImage *defaultHeadImage = [UIImage imageNamed:@"header_default_100x100"];
    [self.avatarImageView sd_setImageWithURL:_topic.user.avatarUrl
                            placeholderImage:defaultHeadImage
                                     options:SDWebImageProgressiveLoad];
    
    // 昵称
    self.nicknameLabel.text = _topic.user.nickname;
    
    // 点赞
    [self.thumbButton setTitle:_topic.thumbNumsString forState:UIControlStateNormal];
    self.thumbButton.selected = _topic.isThumb;
    
    // 时间
    self.createDateTimeLabel.text = _topic.createDateTimeString;
    
    // 内容
    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:15.0f],
        NSForegroundColorAttributeName : [UIColor blackColor]
    };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_topic.content attributes:attributes];
    attributedString.lineSpacing = 8.0f; // 文本行高
    self.contentLabel.attributedText = attributedString;
    
    CGFloat contentHeight = [_topic.content heightForFont:_contentLabel.font width:(kScreenWidth - 60.0f)];
    
    if (contentHeight < 148) {
        [self.expandButton removeFromSuperview];
    }
    
//    // 评论
//    if (_topic.comments.count == 0) {
//        return;
//    }
//
//    __weak __typeof(self)weakSelf = self;
//    [_topic.comments enumerateObjectsUsingBlock:^(HQLComment *currentComment, NSUInteger idx, BOOL * _Nonnull stop) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//
//        if (idx < 3) {
//            YYLabel *commentLabel = [strongSelf commentLabelWithComment:currentComment];
//            [strongSelf.verticalStackView addArrangedSubview:commentLabel];
//        } else {
//            UIButton *moreCommentButton = [strongSelf moreCommentButtonWithCommentsCount:strongSelf.topic.comments.count];
//            [strongSelf.verticalStackView addArrangedSubview:moreCommentButton];
//            *stop = YES;
//        }
//    }];
    
    self.commentsView.comments = [NSArray arrayWithArray:_topic.comments];
    
//    [self.commentsView sizeToFit];
//    
//    // 告诉 self.view 约束需要更新
//    [self.contentView setNeedsUpdateConstraints];
//
//    // 调用此方法告诉 self.view 检测是否需要更新约束，若需要则更新，下面添加的动画效果才起作用
//    [self.contentView updateConstraintsIfNeeded];
}

- (YYLabel *)commentLabelWithComment:(HQLComment *)comment {
    YYLabel *commentLabel = [[YYLabel alloc] init];
    commentLabel.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium];
    commentLabel.numberOfLines = 0;
    commentLabel.preferredMaxLayoutWidth = kScreenWidth - 82;
    
    if (comment.isReply) {
        // 回复评论，张三 回复 李四：XXX回复内容
        NSString *textString = [NSString stringWithFormat:@"%@ 回复 @%@：%@",comment.fromeUser.nickname, comment.toUser.nickname, comment.content];
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        mutableAttributedString.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium];
        mutableAttributedString.color = [UIColor colorWithHexString:@"#323232"];
        mutableAttributedString.lineSpacing = 10.0f;
        
        // 评论用户高亮点击事件
        NSRange fromUserRange = NSMakeRange(0, comment.fromeUser.nickname.length);
        __weak __typeof(self)weakSelf = self;
        [mutableAttributedString setTextHighlightRange:fromUserRange
                                                 color:[UIColor colorWithHexString:@"#FF9500"]
                                       backgroundColor:[UIColor colorWithHexString:@"#CECED2"]
                                             tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            // 通过 Delegate 回调点击响应事件
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.delegateFlag.respondsToTappedUserDelegate) {
                [strongSelf.delegate commentTableViewCellDidTappedUser:comment.fromeUser];
            }
        }];
        
        // 被回复用户高亮点击事件
        NSRange toUserRange = [textString rangeOfString:[NSString stringWithFormat:@"@%@", comment.toUser.nickname]];
        [mutableAttributedString setTextHighlightRange:toUserRange
                                                 color:[UIColor colorWithHexString:@"#FF9500"]
                                       backgroundColor:[UIColor colorWithHexString:@"#CECED2"]
                                             tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            // 通过 Delegate 回调点击响应事件
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.delegateFlag.respondsToTappedUserDelegate) {
                [strongSelf.delegate commentTableViewCellDidTappedUser:comment.toUser];
            }
        }];
        
        commentLabel.attributedText = mutableAttributedString;
    } else {
        // 普通评论，张三：XXX评论内容
        NSString *textString = [NSString stringWithFormat:@"%@：%@",comment.fromeUser.nickname, comment.content];
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        mutableAttributedString.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium];
        mutableAttributedString.color = [UIColor colorWithHexString:@"#323232"];
        mutableAttributedString.lineSpacing = 10.0f;
        
        // 设置昵称高亮点击事件
        NSRange fromUserRange = NSMakeRange(0, comment.fromeUser.nickname.length);
        __weak __typeof(self)weakSelf = self;
        [mutableAttributedString setTextHighlightRange:fromUserRange
                                                 color:[UIColor colorWithHexString:@"#FF9500"]
                                       backgroundColor:[UIColor colorWithHexString:@"#CECED2"]
                                             tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            // 通过 Delegate 回调点击响应事件
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.delegateFlag.respondsToTappedUserDelegate) {
                [strongSelf.delegate commentTableViewCellDidTappedUser:comment.fromeUser];
            }
        }];
        
        commentLabel.attributedText = mutableAttributedString;
    }
    
    return commentLabel;
}

// “共x条回复” 按钮
- (UIButton *)moreCommentButtonWithCommentsCount:(NSInteger)commentsCount {
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium],
        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#323232"]
    };
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"共 %ld 条回复",(long)commentsCount] attributes:attributes];
    [commentButton setAttributedTitle:title forState:UIControlStateNormal];
    
    [commentButton addTarget:self action:@selector(moreCommentsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return commentButton;
}

@end
