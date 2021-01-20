//
//  HQLLogoutFooterView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/1/20.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLLogoutFooterView.h"

// Framework
#import <Chameleon.h>
#import <JKCategories.h>
#import <Masonry.h>

// 主题色
#define COLOR_THEME    HexColor(@"#54CAC3")

// APP 底色
#define COLOR_BACKGROUND    HexColor(@"#F5F5F9")

const CGFloat HQLLogoutFooterViewHeight = 80.0f;

@interface HQLLogoutFooterView ()
@property (nonatomic, strong) UIButton *logoutButton;
@end

@implementation HQLLogoutFooterView

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self setupUI];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) { return nil; }
    
    [self setupUI];
    return self;
}

- (void)setupUI {
    self.backgroundColor = rgb(249, 249, 249);
    [self addSubview:self.logoutButton];
    
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(35);
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.height.mas_equalTo(@45);
    }];
}

#pragma mark - Custom Accessors

- (UIButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 设置按钮标题、颜色、字体
        NSDictionary *normalAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:17],
            NSForegroundColorAttributeName:[UIColor whiteColor]
        };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"退出登录"
                                                                          attributes:normalAttributes];
        [_logoutButton setAttributedTitle:normalTitle forState:UIControlStateNormal];
        
        NSDictionary *highLightedAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:17],
            NSForegroundColorAttributeName:COLOR_THEME
        };
        NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"退出登录"
                                                                               attributes:highLightedAttributes];
        [_logoutButton setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
        
        // 按钮点击高亮效果，通过 UIColor 颜色设置背景图片
        [_logoutButton jk_setBackgroundColor:COLOR_THEME forState:UIControlStateNormal];
        [_logoutButton jk_setBackgroundColor:COLOR_BACKGROUND forState:UIControlStateHighlighted];
        
        // 设置按钮圆角
        _logoutButton.layer.cornerRadius = 10.f;
        _logoutButton.layer.masksToBounds = YES;
        
        [_logoutButton addTarget:self action:@selector(logoutButtionDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}

#pragma mark - Actions

- (void)logoutButtionDidClicked:(id)sender {
    if (self.logoutButtonActionBlock) {
        self.logoutButtonActionBlock();
    }
}


@end
