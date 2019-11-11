//
//  HPMailDirectDrawCell.m
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/5.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "HPMailDirectDrawCell.h"

@implementation HPMailDirectDrawCell

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // 添加手势识别器
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    [self addGestureRecognizer:gesture];
}

// 覆盖 drawRect 方法
- (void)drawRect:(CGRect)rect {

    // 1.邮箱状态
    UIImage *statusImage = nil;
    switch (self.mailStatus) {
        case HPMailDirectDrawCellStatusUnread:
            statusImage = [UIImage imageNamed:@"mail_unread"];
            break;
        case HPMailDirectDrawCellStatusRead:
            statusImage = [UIImage imageNamed:@"mail_read"];
            break;
        case HPMailDirectDrawCellStatusReplied:
            statusImage = [UIImage imageNamed:@"mail_replied"];
            break;
    }
    CGRect statusRect = CGRectMake(8, 4, 12, 12);
    [statusImage drawInRect:statusRect];
    
    // 2.附件
    UIImage *attachmentImage = nil;
    if (self.hasAttachment) {
        attachmentImage = [UIImage imageNamed:@"mail_attachment"];
    }
    CGRect attachmentRect = CGRectMake(8, 20, 12, 12);
    [attachmentImage drawInRect:attachmentRect];
    
    // 3.邮件选中状态
    UIImage *selectedImage = [UIImage imageNamed:
        (self.isMailSelected ? @"mail_selected" : @"mail_unselected")];
    CGRect selectedRect = CGRectMake(8, 36, 12, 12);
    [selectedImage drawInRect:selectedRect];
    
    // 或者，能够使用 Core Graphics绘制矢量图像
    
    CGFloat fontSize = 13;
    CGFloat width = rect.size.width;
    CGFloat remainderWidth = width - 28;
    
    // 4.邮箱
    CGFloat emailWidth = remainderWidth - 72;
    UIFont *emailFont = [UIFont boldSystemFontOfSize:fontSize];
    NSDictionary *attrs = @{NSFontAttributeName : emailFont};
    [self.email drawInRect:CGRectMake(28, 4, emailWidth, 16) withAttributes:attrs];
    
    // 5.主题、6.摘要
    UIFont *stdFont = [UIFont systemFontOfSize:fontSize];
    NSDictionary *attrs2 = @{NSFontAttributeName : stdFont};
    [self.subject drawInRect:CGRectMake(28, 24, remainderWidth, 16) withAttributes:attrs2];
    [self.snippet drawInRect:CGRectMake(28, 44, remainderWidth, 16) withAttributes:attrs2];
    
    // 7.日期
    UIFont *verdana = [UIFont fontWithName:@"Verdana" size:10];
    NSDictionary *attrs3 = @{NSFontAttributeName : verdana};
    [self.date drawInRect:CGRectMake(width - 60, 4, 60, 16) withAttributes:attrs3];
}

#pragma mark - IBActions

- (void)cellTapped:(UIGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    if (location.x >= 0 && location.x <= 20 && location.y >= 30) {
        self.isMailSelected = !self.isMailSelected;
        [self setNeedsDisplayInRect:CGRectMake(0, 30, 20, self.frame.size.height)];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
//    self.isMailSelected = selected;
//    [self setNeedsDisplayInRect:CGRectMake(8, 36, 12, 12)];
}

@end
