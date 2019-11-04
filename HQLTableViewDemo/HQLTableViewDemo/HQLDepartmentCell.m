//
//  HQLDepartmentCell.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/21.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLDepartmentCell.h"

@interface HQLDepartmentCell ()

@property (nonatomic, strong) UIImageView *blueArrowImageView;

@end

@implementation HQLDepartmentCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        self.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor grayColor];
        self.textLabel.highlightedTextColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.blueArrowImageView];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UIImageView *)blueArrowImageView {
    if (!_blueArrowImageView) {
        _blueArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"department_arrow.png"]];
        _blueArrowImageView.frame = CGRectMake(2, 14, 16, 16);
    }
    return _blueArrowImageView;
}

#pragma mark - Private

// 设置选中动画
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.blueArrowImageView.hidden = !selected;
    self.textLabel.highlighted = selected;
    if (selected) {
        self.backgroundColor = [UIColor whiteColor]; // 选中时当前cell背景为白色
        [UIView animateWithDuration:0.1 animations:^{
            
            CGRect frame = self.textLabel.frame;
            frame.origin.x = 25;
            self.textLabel.frame = frame;
            
        } completion:^(BOOL finished) {
            // 默认选中第一行效果出不来，故显式设置。
            self.blueArrowImageView.hidden = NO;
            CGRect frame = self.textLabel.frame;
            frame.origin.x = 25;
            self.textLabel.frame = frame;
        }];
    }else {
        self.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.textLabel.frame;
            frame.origin.x = 15;
            self.textLabel.frame = frame;
        }];
    }
}

// 高亮效果
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    self.blueArrowImageView.hidden = !highlighted;
    if (highlighted) {
        self.backgroundColor = [UIColor whiteColor]; // 高亮时当前cell背景为白色
    }
}

@end
