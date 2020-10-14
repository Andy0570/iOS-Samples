//
//  HQLCommentCell.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCommentCell.h"
#import <YYKit.h>
#import <Masonry.h>

#import "HQLUser.h"
#import "HQLComment.h"

@interface HQLCommentCell ()
@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, assign) BOOL delegateFlag;
@end

@implementation HQLCommentCell

#pragma mark - Initialize

- (void)dealloc {
    self.delegate = nil;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.commentLabel.text = nil;
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

- (YYLabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[YYLabel alloc] init];
        _commentLabel.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium];
        _commentLabel.numberOfLines = 0;
        // |-10-30-10-11-label-11-10-|
        _commentLabel.preferredMaxLayoutWidth = kScreenWidth - 82;
    }
    return _commentLabel;
}

- (void)setComment:(HQLComment *)comment {
    _comment = comment;
    
    [self renderUI];
}

- (void)setDelegate:(id<HQLCommentCellDelegate>)delegate {
    _delegate = delegate;
    _delegateFlag = [delegate respondsToSelector:@selector(commentCellDidTappedUser:)];
}

#pragma mark - Private

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.contentView addSubview:containerView];
    [containerView addSubview:self.commentLabel];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 50, 0, 10));
    }];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containerView).with.insets(UIEdgeInsetsMake(7, 11, 7, 11));
    }];
}

- (void)renderUI {
    if (_comment.isReply) {
        // 回复评论，张三 回复 李四：XXX回复内容
        NSString *textString = [NSString stringWithFormat:@"%@ 回复 @%@：%@",_comment.fromeUser.nickname, _comment.toUser.nickname, _comment.content];
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        mutableAttributedString.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium];
        mutableAttributedString.color = [UIColor colorWithHexString:@"#323232"];
        mutableAttributedString.lineSpacing = 10.0f;
        
        // 评论用户高亮点击事件
        NSRange fromUserRange = NSMakeRange(0, _comment.fromeUser.nickname.length);
        __weak __typeof(self)weakSelf = self;
        [mutableAttributedString setTextHighlightRange:fromUserRange
                                                 color:[UIColor colorWithHexString:@"#FF9500"]
                                       backgroundColor:[UIColor colorWithHexString:@"#CECED2"]
                                             tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            // 通过 Delegate 回调点击响应事件
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.delegateFlag) {
                [strongSelf.delegate commentCellDidTappedUser:strongSelf.comment.fromeUser];
            }
        }];
        
        // 被回复用户高亮点击事件
        NSRange toUserRange = [textString rangeOfString:[NSString stringWithFormat:@"@%@", _comment.toUser.nickname]];
        [mutableAttributedString setTextHighlightRange:toUserRange
                                                 color:[UIColor colorWithHexString:@"#FF9500"]
                                       backgroundColor:[UIColor colorWithHexString:@"#CECED2"]
                                             tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            // 通过 Delegate 回调点击响应事件
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.delegateFlag) {
                [strongSelf.delegate commentCellDidTappedUser:strongSelf.comment.toUser];
            }
        }];
        
        self.commentLabel.attributedText = mutableAttributedString;
    } else {
        // 普通评论，张三：XXX评论内容
        NSString *textString = [NSString stringWithFormat:@"%@：%@",_comment.fromeUser.nickname, _comment.content];
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        mutableAttributedString.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium];
        mutableAttributedString.color = [UIColor colorWithHexString:@"#323232"];
        mutableAttributedString.lineSpacing = 10.0f;
        
        // 设置昵称高亮点击事件
        NSRange fromUserRange = NSMakeRange(0, _comment.fromeUser.nickname.length);
        __weak __typeof(self)weakSelf = self;
        [mutableAttributedString setTextHighlightRange:fromUserRange
                                                 color:[UIColor colorWithHexString:@"#FF9500"]
                                       backgroundColor:[UIColor colorWithHexString:@"#CECED2"]
                                             tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            // 通过 Delegate 回调点击响应事件
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.delegateFlag) {
                [strongSelf.delegate commentCellDidTappedUser:strongSelf.comment.fromeUser];
            }
        }];
        
        self.commentLabel.attributedText = mutableAttributedString;
    }
}

@end
