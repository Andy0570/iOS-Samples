//
//  HQLCodeResignViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCodeResignViewController.h"
#import "HQLCodeResignView.h"
#import <Chameleon.h>
#import <Toast.h>
#import <Masonry.h>
#import <JKCategories/UIImage+JKColor.h>

@interface HQLCodeResignViewController ()
@property (nonatomic, strong) UIButton *submitButton;
@end

@implementation HQLCodeResignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak __typeof(self)weakSelf = self;
    HQLCodeResignView *codeResignView = [[HQLCodeResignView alloc] initWithCodeBits:4];
    codeResignView.completionHandler = ^(NSString * _Nonnull content) {
        // 对应位数输入完成时，允许提交按钮有效，允许提交
        weakSelf.submitButton.enabled = YES;
        [self.navigationController.view makeToast:content];
    };
    codeResignView.cancelHandler = ^(NSString * _Nonnull content) {
        // 对应位数输入未完成时，不允许提交
        weakSelf.submitButton.enabled = NO;
        [self.navigationController.view makeToast:content];
    };
    [self.view addSubview:codeResignView];
    [codeResignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(15.0f);
        make.right.mas_equalTo(self.view).mas_offset(-15.0f);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(100.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage jk_imageWithColor:HexColor(@"#108EE9")]
                             forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage jk_imageWithColor:HexColor(@"#1284D6")]
                             forState:UIControlStateDisabled];
    _submitButton.enabled = NO;
    _submitButton.layer.cornerRadius = 5.0f;
//    [_submitButton addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).mas_offset(20.0f);
        make.right.mas_equalTo(weakSelf.view).mas_offset(-20.0f);
        make.top.mas_equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop).mas_offset(260.0f);
        make.height.mas_equalTo(45.0f);
    }];
}



@end
