//
//  HQLSuccessViewController.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/3/27.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "HQLSuccessViewController.h"

// Framework
#import <Masonry.h>

@interface HQLSuccessViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation HQLSuccessViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - Custom Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@"LaunchImage"];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end
