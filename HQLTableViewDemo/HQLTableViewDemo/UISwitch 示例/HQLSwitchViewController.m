//
//  HQLSwitchViewController.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/4/1.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "HQLSwitchViewController.h"

// Framework
#import <Masonry.h>
#import <YYKit.h>
#import <Toast.h>

// View
#import "HQLSwitchView.h"

@interface HQLSwitchViewController () <HQLSwitchViewDelegate>
@property (nonatomic, strong) UISwitch *switchControl;
@end

@implementation HQLSwitchViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.switchControl];
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(15);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(15);
        make.size.mas_equalTo(CGSizeMake(44, 25));
    }];
    
    // Custom Switch View
    HQLSwitchView *switchView = [[HQLSwitchView alloc] initWithFrame:CGRectMake(100, 200, 46, 32)];
    switchView.on = NO;
    switchView.delegate = self;
    [self.view addSubview:switchView];
}

#pragma mark - Actions

- (void)switchValueDidChange:(UISwitch *)switchControl {
    [self.view makeToast:[NSString stringWithFormat:@"%@", switchControl.isOn ? @"Yes" : @"No"]];
}

#pragma mark - HQLSwitchViewDelegate

- (void)switchView:(HQLSwitchView *)switchView didChangeValue:(BOOL)value {
    [self.view makeToast:[NSString stringWithFormat:@"%@", switchView.isOn ? @"Yes" : @"No"]];
}

#pragma mark - Custom Accessors

- (UISwitch *)switchControl {
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
        _switchControl.translatesAutoresizingMaskIntoConstraints = NO;
        // _switchControl.tintColor = [UIColor redColor]; // Display the border of Swicth.
        _switchControl.onTintColor = UIColorHex(#1F69A1);
        // _switchControl.thumbTintColor = UIColor.blueColor;
        // _switchControl.onImage = [UIImage imageNamed:@"device_category_bg"];
        [_switchControl addTarget:self
                           action:@selector(switchValueDidChange:)
                 forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}

@end
