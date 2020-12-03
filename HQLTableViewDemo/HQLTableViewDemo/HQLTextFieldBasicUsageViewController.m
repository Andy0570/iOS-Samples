//
//  HQLTextFieldBasicUsageViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/12/2.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLTextFieldBasicUsageViewController.h"
#import "SelwynExpandableTextView.h"
#import "UITextView+TextLimit.h"

#import <Chameleon.h>
#import <Masonry.h>

@interface HQLTextFieldBasicUsageViewController () <UITextViewDelegate>
/// 可高度自适应的 UITextView
@property (nonatomic, strong) SelwynExpandableTextView *rightTextView;
@end

@implementation HQLTextFieldBasicUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.flatWhiteColorDark;
    [self addSelwynExpandableTextView];
}

- (void)addSelwynExpandableTextView {
    self.rightTextView.maxLength = 120;
    self.rightTextView.showLength = YES;
    
    [self.view addSubview:self.rightTextView];
    [self.rightTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(40);
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
        make.height.mas_equalTo(80);
    }];
}


#pragma mark - Custom Accessors

- (SelwynExpandableTextView *)rightTextView {
    if (!_rightTextView) {
        _rightTextView = [[SelwynExpandableTextView alloc] init];
        _rightTextView.delegate = self;
        _rightTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _rightTextView.textContainer.lineFragmentPadding = 0;
        _rightTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _rightTextView.backgroundColor = [UIColor flatWhiteColor];
        _rightTextView.font = [UIFont systemFontOfSize:18.0f];
        _rightTextView.scrollEnabled = YES;
        _rightTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        _rightTextView.layoutManager.allowsNonContiguousLayout = NO;
        _rightTextView.showsVerticalScrollIndicator = YES;
        _rightTextView.showsHorizontalScrollIndicator = YES;
        
        if (@available(iOS 13.0, *)) {
            BOOL isDarkMode = (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
            _rightTextView.textColor = (isDarkMode ? UIColor.labelColor : rgb(51, 51, 51));
            _rightTextView.placeholderTextColor = UIColor.placeholderTextColor;
        } else {
            _rightTextView.textColor = rgb(51, 51, 51);
            _rightTextView.placeholderTextColor = rgb(187, 187, 187);
        }
    }
    return _rightTextView;
}

@end
