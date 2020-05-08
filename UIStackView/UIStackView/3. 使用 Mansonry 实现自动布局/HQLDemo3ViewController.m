//
//  HQLDemo3ViewController.m
//  UIStackView
//
//  Created by Qilin Hu on 2020/5/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLDemo3ViewController.h"

// Frameworks
#import <Masonry.h>
#import <YYKit.h>

@interface HQLDemo3ViewController ()
@property (nonatomic, strong) UIView *masonryView; // 容器视图
@end

@implementation HQLDemo3ViewController


#pragma mark - Controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:63/100.0f alpha:1.0];
    [self addSubViews];
}


#pragma mark - Custom Accessors

- (UIView *)masonryView {
    if (!_masonryView) {
        _masonryView = [[UIView alloc] init];
        _masonryView.backgroundColor = [UIColor whiteColor];
    }
    return _masonryView;
}

#pragma mark - Private

- (void)addSubViews {
    // 添加容器视图
    [self.view addSubview:self.masonryView];
    [self.masonryView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view.mas_top).with.offset(64);
        }
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(CGFloatPixelRound((kScreenWidth - 10*5)/4) + 10*2);
    }];
    
    // 容器视图中添加子视图
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithDisplayP3Red:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        [views addObject:view];
        [self.masonryView addSubview:view];
    }
    
    // MARK: 让所有子视图均匀以「固定间隔」均匀分布
    [views mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                       withFixedSpacing:10
                            leadSpacing:10
                            tailSpacing:10];
    
    __weak __typeof(self)weakSelf = self;
    [views mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.top.and.height.equalTo(weakSelf.masonryView);
        make.centerY.equalTo(weakSelf.masonryView);
        make.height.mas_equalTo(CGFloatPixelRound((kScreenWidth - 10*5)/4));
    }];
}




@end
