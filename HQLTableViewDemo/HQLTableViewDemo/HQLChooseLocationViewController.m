//
//  HQLChooseLocationViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLChooseLocationViewController.h"

#import "ChooseLocationView.h"
#import "CitiesDataTool.h"

@interface HQLChooseLocationViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ChooseLocationView *chooseLocationView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation HQLChooseLocationViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CitiesDataTool sharedManager] requestGetData];
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.chooseLocationView];
    
    self.chooseLocationView.address = @"广东省 广州市 越秀区";
    self.chooseLocationView.areaCode = @"440104";
    self.locationLabel.text = @"广东省 广州市 越秀区";
}

#pragma mark - Custom Accessors

// 容器视图遮罩图层，作用是接收手势识别器，执行回调
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _containerView.hidden =YES;
        
        // 在容器视图上添加手势识别器
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)];
        tapGestureRecognizer.delegate = self;
        [_containerView addGestureRecognizer:tapGestureRecognizer];
    }
    return _containerView;
}

- (ChooseLocationView *)chooseLocationView {
    if (!_chooseLocationView) {
        _chooseLocationView = [[ChooseLocationView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)];
        
        // 选择完成后的回调
        __weak __typeof(self)weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.locationLabel.text = strongSelf.chooseLocationView.address;
            strongSelf.view.transform = CGAffineTransformIdentity;
            strongSelf.containerView.hidden = YES;
        };
    }
    return _chooseLocationView;
}


#pragma mark - Actions

- (IBAction)chooseLocationAction:(id)sender {
    
    // 点击选择地址按钮，整个视图缩小 0.95
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform =CGAffineTransformMakeScale(0.95, 0.95);
    }];
    
    self.containerView.hidden = !self.containerView.hidden;
    self.chooseLocationView.hidden = self.containerView.hidden;
}

// 当用户触摸「地址选择器」空白区域时，触发该方法，执行选择完成后的回调！
- (void)tapContainerView:(UITapGestureRecognizer *)tap {
    // 如果有完成后的回调，则执行该回调
    if (self.chooseLocationView.chooseFinish) {
        self.chooseLocationView.chooseFinish();
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

/**
 当手势识别器尝试从 UIGestureRecognizerStatePossible 过渡时调用。
 返回 NO 会使它过渡到 UIGestureRecognizerStateFailed
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    // 如果触摸点在 _chooseLocationView 视图内，则返回 NO
    if (CGRectContainsPoint(self.chooseLocationView.frame, point)) {
        return NO;
    } else {
        return YES;
    }
}



@end
