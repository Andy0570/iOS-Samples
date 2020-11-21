//
//  HQLZYCornerRadiusViewController.m
//  UIImageTips
//
//  Created by Qilin Hu on 2020/5/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLZYCornerRadiusViewController.h"

// Frameworks
#import <ZYCornerRadius/UIImageView+CornerRadius.h>

@interface HQLZYCornerRadiusViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation HQLZYCornerRadiusViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // FIXME: xib 创建的图像不起作用
    // 设置图片圆角
//    [self.imgView zy_cornerRadiusAdvance:20.0f
//                          rectCornerType:UIRectCornerAllCorners];
    
    // 设置圆形图片
     [self.imgView zy_cornerRadiusRoundingRect];
}





@end
