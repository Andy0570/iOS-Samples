//
//  HQLSegmentViewUsageController.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/3/21.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "HQLSegmentViewUsageController.h"

// Framework
#import <Masonry.h>
#import <YYKit.h>

// View
#import "HQLCustomSegmentView.h"

@interface HQLSegmentViewUsageController ()
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UISegmentedControl *segmentedControl2;
@property (nonatomic, strong) HQLCustomSegmentView *segmentedControl3;
@end

@implementation HQLSegmentViewUsageController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // segmentedControl
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.leading.equalTo(self.view.mas_leading).offset(16);
        make.trailing.equalTo(self.view.mas_trailing).offset(-16);
        make.height.mas_equalTo(44);
    }];
    self.segmentedControl.selectedSegmentIndex = 0;
    
    // segmentedControl2
    [self.view addSubview:self.segmentedControl2];
    [self.segmentedControl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom).offset(10);
        make.leading.equalTo(self.view.mas_leading).offset(16);
        make.trailing.equalTo(self.view.mas_trailing).offset(-16);
        make.height.mas_equalTo(50);
    }];
    self.segmentedControl2.selectedSegmentIndex = 0;
    
    // segmentedControl3
    [self.view addSubview:self.segmentedControl3];
    [self.segmentedControl3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl2.mas_bottom).offset(10);
        make.leading.equalTo(self.view.mas_leading).offset(16);
        make.trailing.equalTo(self.view.mas_trailing).offset(-16);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - Actions

-(void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    NSLog(@"select index = %ld", (long)segmentedControl.selectedSegmentIndex);
}

#pragma mark - Custom Accessors

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        NSArray *titleArray = @[@"Current", @"History"];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:titleArray];
        
        _segmentedControl.layer.cornerRadius = 10.0f;
        
        // 这个属性已经废弃，不再起任何作用
        // _segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
        
        _segmentedControl.backgroundColor = UIColorHex(#1F2124);
        _segmentedControl.selectedSegmentTintColor = UIColorHex(#7878805C);
        
        // 设置标题字体样式
        NSDictionary *titleAttributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:15.0f weight:UIFontWeightSemibold],
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        [_segmentedControl setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];
        
//        CGFloat segmentWidth = (kScreenWidth - 32 -  10) / 2;
//        [_segmentedControl setWidth:segmentWidth forSegmentAtIndex:0];
//        [_segmentedControl setWidth:segmentWidth forSegmentAtIndex:1];
//        [_segmentedControl setContentOffset:CGSizeMake(5, 0) forSegmentAtIndex:0];
//        [_segmentedControl setContentOffset:CGSizeMake(5, 0) forSegmentAtIndex:1];
        
        [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentedControl;
}

- (UISegmentedControl *)segmentedControl2 {
    if (!_segmentedControl2) {
        NSArray *titleArray = @[@"General", @"Health", @"Expected life"];
        _segmentedControl2 = [[UISegmentedControl alloc] initWithItems:titleArray];
        
        _segmentedControl2.layer.cornerRadius = 10.0f;
        
        // 这个属性已经废弃，不再起任何作用
        // _segmentedControl2.segmentedControlStyle = UISegmentedControlStylePlain;
        
        _segmentedControl2.backgroundColor = UIColorHex(#1F2124);
        _segmentedControl2.selectedSegmentTintColor = UIColorHex(#7878805C);
        
        // 设置标题字体样式
        NSDictionary *titleAttributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:15.0f weight:UIFontWeightSemibold],
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        [_segmentedControl2 setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];
        
//        CGFloat segmentWidth = (kScreenWidth - 32 -  10) / 2;
//        [_segmentedControl2 setWidth:segmentWidth forSegmentAtIndex:0];
//        [_segmentedControl2 setWidth:segmentWidth forSegmentAtIndex:1];
//        [_segmentedControl2 setContentOffset:CGSizeMake(5, 0) forSegmentAtIndex:0];
//        [_segmentedControl2 setContentOffset:CGSizeMake(5, 0) forSegmentAtIndex:1];
        
        [_segmentedControl2 addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentedControl2;
}

- (HQLCustomSegmentView *)segmentedControl3 {
    if (!_segmentedControl3) {
        _segmentedControl3 = [[HQLCustomSegmentView alloc] initWithLeftTitle:@"Current" rightTitle:@"History"];
        
        // __weak __typeof(self)weakSelf = self;
        _segmentedControl3.selectBlock = ^(NSInteger buttonIndex) {
            // __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            NSLog(@"select index = %ld", (long)buttonIndex);
        };
    }
    return _segmentedControl3;
}

@end
