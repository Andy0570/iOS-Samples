//
//  HQLImageViewController.m
//  HQLHomepwner
//
//  Created by ToninTech on 2017/5/18.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLImageViewController.h"

@interface HQLImageViewController ()

@end

@implementation HQLImageViewController

- (void)loadView {
    UIImageView *imageView = [[UIImageView alloc] init];
    // 按照"图片的宽高"比例缩放图片至图片的宽度或者高度和UIImageView一样, 并且让整个图片都在UIImageView中. 然后居中显示
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //  http://www.jianshu.com/p/8c3bc470ee7a
    imageView.contentMode = UIViewContentModeCenter;
    self.view = imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    // 添加捏合手势
    UIPinchGestureRecognizer *pinchRecognizer =
        [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(zoom:)];
    [self.view addGestureRecognizer:pinchRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 必须将 View 转换为 UIImageView 对象，以便向其发送 setImage： 消息
    UIImageView *imageView = (UIImageView *)self.view;
    // 寻找合适的比例因子
    float scaleFactor = MIN(self.view.frame.size.width / self.image.size.width,
                            self.view.frame.size.height / self.image.size.height);
    // 根据比例因子设置 frame
    CGRect popoverFrame = CGRectMake(0,
                                     0,
                                     self.image.size.width * scaleFactor,
                                     self.image.size.height * scaleFactor);
    // 显示图片
    UIGraphicsBeginImageContextWithOptions(popoverFrame.size, NO, 0.0);
    [self.image drawInRect:popoverFrame];
    UIImage *fitImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageView.image = fitImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

// 缩放
- (void)zoom:(UIGestureRecognizer *)gestureRecognizer
{
    // Cast the gesture recognizer into a pinch gesture recognizer
    UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)gestureRecognizer;
    // 捏合比例
    NSLog(@"Pinch Scale: %f", pinch.scale);
    CGRect imageFrame = self.view.frame;
    CGRect originalFrame = CGRectMake(0,
                                      0,
                                      self.image.size.width,
                                      self.image.size.height);
    float scaleFactor = MIN(imageFrame.size.width / self.image.size.width,
                            imageFrame.size.height / self.image.size.height);
    NSLog(@"ScaleFactor: %f", scaleFactor);
    float zoomWidth = pinch.scale * originalFrame.size.width * scaleFactor;
    float zoomHeight = pinch.scale * originalFrame.size.height * scaleFactor;
    CGRect zoomedRect = CGRectMake(0, 0, zoomWidth, zoomHeight);
    NSLog(@"zoomedRect: width: %f height: %f", zoomWidth, zoomHeight);
    NSLog(@"zoomedRect: x:%f, y:%f, width:%f, height:%f", zoomedRect.origin.x, zoomedRect.origin.y, zoomedRect.size.width, zoomedRect.size.height);
    UIGraphicsBeginImageContextWithOptions(zoomedRect.size, NO, 0.0);
    [self.image drawInRect:zoomedRect];
    UIImage *zoomedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *currentView = (UIImageView *)self.view;
    currentView.image = zoomedImage;
    UIGraphicsEndImageContext();
}

@end
