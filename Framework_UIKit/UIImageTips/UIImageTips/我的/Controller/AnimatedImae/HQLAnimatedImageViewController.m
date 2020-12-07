//
//  HQLAnimatedImageViewController.m
//  UIImageTips
//
//  Created by Qilin Hu on 2020/5/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLAnimatedImageViewController.h"

// Frameworks
#import <SDWebImage.h>

@interface HQLAnimatedImageViewController ()

@property (weak, nonatomic) IBOutlet SDAnimatedImageView *imgView;


@end

@implementation HQLAnimatedImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 添加动图
//    SDAnimatedImage *animatedImage = [SDAnimatedImage imageNamed:@"image.gif"];
//    self.imgView.image = animatedImage;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:@"https://gfs8.gomein.net.cn/T1RbW_BmdT1RCvBVdK.gif"]];
}



@end
