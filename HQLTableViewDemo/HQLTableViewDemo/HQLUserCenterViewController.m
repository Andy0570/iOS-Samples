//
//  HQLUserCenterViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/13.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLUserCenterViewController.h"
#import <SDWebImage.h>
#import <Masonry.h>
#import "HQLUser.h"

@interface HQLUserCenterViewController ()

@property (nonatomic, strong) UIImageView *avatorImageView;

@end

@implementation HQLUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.user.nickname];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 简单显示用户中心页面
    self.avatorImageView = [[UIImageView alloc] init];
    self.avatorImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *defaultHeadImage = [UIImage imageNamed:@"header_default_100x100"];
    [self.avatorImageView sd_setImageWithURL:self.user.avatarUrl
                            placeholderImage:defaultHeadImage
                                     options:SDWebImageProgressiveLoad];
    [self.view addSubview:self.avatorImageView];
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
}

@end
