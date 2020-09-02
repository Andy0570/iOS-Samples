//
//  HQLFloatingTabBar.m
//  FloatingTabBarDemo
//
//  Created by Qilin Hu on 2020/8/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLFloatingTabBar.h"
#import <POP.h>
#import <Masonry.h>
#import <JKCategories/UIButton+JKImagePosition.h>
#import <JKCategories/UIButton+JKTouchAreaInsets.h>
#import "HQLFloatingButton.h"

@interface HQLFloatingTabBar ()

@property (nonatomic, strong) HQLFloatingButton *leftBarButton;
@property (nonatomic, strong) HQLFloatingButton *rightBarButton;
@property (nonatomic, strong) UIButton *publishBarButton;

@end

@implementation HQLFloatingTabBar

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        self.layer.cornerRadius = 25.0f;
        self.layer.masksToBounds = YES;
        
        [self addSubViews];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Method Undefined"
                                   reason:@"Use Designated Initializer Method"
                                 userInfo:nil];
    return nil;
}

#pragma mark - Custom Accessors

- (HQLFloatingButton *)leftBarButton {
    if (!_leftBarButton) {
        _leftBarButton = [HQLFloatingButton button];

        // 默认标题
        NSDictionary *normalAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:10],
            NSForegroundColorAttributeName:[UIColor blackColor]
        };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"首页" attributes:normalAttributes];
        [_leftBarButton setAttributedTitle:normalTitle forState:UIControlStateNormal];
        
        // 选中标题
        NSDictionary *selectedAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:10],
            NSForegroundColorAttributeName:[UIColor colorWithRed:71/255.0f green:193/255.0f blue:182/255.0f alpha:1.0]
        };
        NSAttributedString *selectedTitle = [[NSAttributedString alloc] initWithString:@"首页" attributes:selectedAttributes];
        [_leftBarButton setAttributedTitle:selectedTitle forState:UIControlStateSelected];
        
        // 图片
        [_leftBarButton setImage:[UIImage imageNamed:@"tab_home_normal"] forState:UIControlStateNormal];
        [_leftBarButton setImage:[UIImage imageNamed:@"tab_home_selected"] forState:UIControlStateSelected];
        
        // 调整图文布局、增加额外热区
        [_leftBarButton jk_setImagePosition:LXMImagePositionTop spacing:2];
        _leftBarButton.jk_touchAreaInsets = UIEdgeInsetsMake(20, 0, 7, 6);
        
        [_leftBarButton addTarget:self action:@selector(leftBarButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBarButton;
}

- (HQLFloatingButton *)rightBarButton {
    if (!_rightBarButton) {
        _rightBarButton = [HQLFloatingButton button];
        
        // 默认标题
        NSDictionary *normalAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:10],
            NSForegroundColorAttributeName:[UIColor blackColor]
        };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"去逛街" attributes:normalAttributes];
        [_rightBarButton setAttributedTitle:normalTitle forState:UIControlStateNormal];
        
        // 选中标题
        NSDictionary *selectedAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:10],
            NSForegroundColorAttributeName:[UIColor colorWithRed:71/255.0f green:193/255.0f blue:182/255.0f alpha:1.0]
        };
        NSAttributedString *selectedTitle = [[NSAttributedString alloc] initWithString:@"去逛街" attributes:selectedAttributes];
        [_rightBarButton setAttributedTitle:selectedTitle forState:UIControlStateSelected];
        
        // 图片
        [_rightBarButton setImage:[UIImage imageNamed:@"tab_market_normal"] forState:UIControlStateNormal];
        [_rightBarButton setImage:[UIImage imageNamed:@"tab_market_selected"] forState:UIControlStateSelected];
        
        // 调整图文布局、增加额外热区
        [_rightBarButton jk_setImagePosition:LXMImagePositionTop spacing:2];
        _rightBarButton.jk_touchAreaInsets = UIEdgeInsetsMake(20, 0, 7, 6);
        
        [_rightBarButton addTarget:self action:@selector(rightBarButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarButton;
}

- (UIButton *)publishBarButton {
    if (!_publishBarButton) {
        _publishBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishBarButton.jk_touchAreaInsets = UIEdgeInsetsMake(9, 9, 9, 9);
        
        [_publishBarButton setBackgroundImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
        [_publishBarButton setBackgroundImage:[UIImage imageNamed:@"publish"] forState:UIControlStateHighlighted];
        [_publishBarButton addTarget:self action:@selector(publishBarButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBarButton;
}

#pragma mark - Actions

- (void)leftBarButtonWasPressed:(UIButton *)sender {
    self.leftBarButton.selected = YES;
    self.rightBarButton.selected = NO;
    
    if (self.leftBarButtonActionBlock) {
        self.leftBarButtonActionBlock();
    }
}

- (void)rightBarButtonWasPressed:(UIButton *)sender {
    self.leftBarButton.selected = NO;
    self.rightBarButton.selected = YES;
    
    if (self.rightBarButtonActionBlock) {
        self.rightBarButtonActionBlock();
    }
}

- (void)publishBarButtonWasPressed:(UIButton *)sender {
    if (self.publishBarButtonActionBlock) {
        self.publishBarButtonActionBlock();
    }
}

#pragma mark - Public

- (void)show {
    // !!!: 将 HQLFloatingTabBar 添加到 UIWindow 应用窗口
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] firstObject];
    [mainWindow addSubview:self];
    
    // 默认选中首页
    self.leftBarButton.selected = YES;
    self.rightBarButton.selected = NO;
}

- (void)executeCompressAnimation {
    [self pop_removeAllAnimations];
    
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBounds];
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    basicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    basicAnimation.duration = 0.25;
    [self pop_addAnimation:basicAnimation forKey:@"pop_tabBar_size"];
    
    POPBasicAnimation *colorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    colorAnimation.toValue = [UIColor colorWithRed:84/255.0f green:202/255.0f blue:195/255.0f alpha:1.0];
    colorAnimation.duration = 0.25;
    [self pop_addAnimation:colorAnimation forKey:@"pop_tabBar_color"];
}

- (void)executeStretchAnimation {
    [self pop_removeAllAnimations];
    
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBounds];
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    basicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 50)];
    basicAnimation.duration = 0.25;
    [self pop_addAnimation:basicAnimation forKey:@"pop_tabBar_size"];
        
    POPBasicAnimation *colorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    colorAnimation.toValue = [UIColor colorWithWhite:1.0 alpha:0.8];
    [self pop_addAnimation:colorAnimation forKey:@"pop_tabBar_color"];
}

#pragma mark - Private

- (void)addSubViews {
    [self addSubview:self.leftBarButton];
    [self addSubview:self.publishBarButton];
    [self addSubview:self.rightBarButton];
    
    CGFloat padding = 20.f;
    [self.publishBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [self.leftBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(padding);
        make.right.mas_equalTo(self.publishBarButton.mas_left).with.offset(-padding);
    }];
    [self.rightBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(padding);
        make.left.mas_equalTo(self.publishBarButton.mas_right).with.offset(padding);
    }];
}

@end
