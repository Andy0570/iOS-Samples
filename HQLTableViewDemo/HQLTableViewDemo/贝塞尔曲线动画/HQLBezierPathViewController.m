//
//  HQLBezierPathViewController.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/8/13.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "HQLBezierPathViewController.h"

// View
#import "HQLFlowLineView.h"

@interface HQLBezierPathViewController ()
@property (nonatomic, strong) HQLFlowLineView *lineView1;
@end

@implementation HQLBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubView];
}

- (void)setupSubView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.lineView1];
    
    // 先禁止所有动画
    // direction = 0:取消动画
    [self.lineView1 configWithCount:200 delay:0 direction:0 isNight:YES];
    
    // 根据逻辑开启动画
    [self.lineView1 configWithCount:200 delay:0 direction:1 isNight:YES];
}

#pragma mark - Custom Accessors

- (HQLFlowLineView *)lineView1 {
    if (!_lineView1) {
        CGRect frame = CGRectMake(20, 100, 189, 16);
        _lineView1 = [[HQLFlowLineView alloc] initWithFrame:frame withSvgFile:@"flow_girdToLoad_svg"];
    }
    return _lineView1;
}

@end
