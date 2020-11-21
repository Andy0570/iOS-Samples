//
//  CustomViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "CustomViewController.h"
#import <YYKit.h>
#import <Masonry.h>

@interface CustomViewController ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CustomViewController

#pragma mark - Initialize

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        [self setupUI];
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.backgroundView.frame = [UIScreen mainScreen].bounds;
    self.contentView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height, CGRectGetWidth([UIScreen mainScreen].bounds), 300.0);
    
    self.backgroundView.alpha  = 0.0f;
    // MARK: 通过 Spring 动画实现转场显示
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.backgroundView.alpha = 1.0f;
        strongSelf.contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300.f, CGRectGetWidth([UIScreen mainScreen].bounds), 300.0f);
        
    } completion:nil];
}

#pragma mark - Custom Accessors

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.5f];
        
        // 添加点击手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)];
        [_backgroundView addGestureRecognizer:tapGestureRecognizer];
    }
    return _backgroundView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#FFE6E6"];
    }
    return _contentView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"B";
        _label.font = [UIFont systemFontOfSize:120.f];
        _label.textColor = [UIColor lightGrayColor];
    }
    return _label;
}

#pragma mark - Actions

// 点击背景遮罩视图，退出当前视图
- (void)backgroundViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    // MARK: 通过 Spring 动画实现转场消失
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.95 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.backgroundView.alpha = 0.0f;
        strongSelf.contentView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height, CGRectGetWidth([UIScreen mainScreen].bounds), 300.0);
        
    } completion:^(BOOL finished) {
        
        // 动画Animated必须是NO，不然消失之后，会有0.35s时间，再点击无效
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Private

- (void)setupUI {
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.label];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
    }];
}



@end
