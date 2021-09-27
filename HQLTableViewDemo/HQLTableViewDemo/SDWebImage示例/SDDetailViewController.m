//
//  SDDetailViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/9/12.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "SDDetailViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface SDDetailViewController ()
@property (nonatomic, strong) SDAnimatedImageView *imageView;
@end

@implementation SDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithTitle:@"Toggle Animation"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(toggleAnimation:)];
}

- (void)configView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [SDAnimatedImageView new];
    _imageView.frame = self.view.bounds;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    //_imageView.sd_imageTransition = SDWebImageTransition.fadeTransition;
    //_imageView.sd_imageTransition = SDWebImageTransition.curlUpTransition;
    //_imageView.sd_imageTransition = SDWebImageTransition.flipFromTopTransition;
    
    //_imageView.sd_imageIndicator = SDWebImageProgressIndicator.defaultIndicator;
    _imageView.sd_imageIndicator = SDWebImageActivityIndicator.mediumIndicator;
    //_imageView.sd_imageIndicator = SDWebImageActivityIndicator.largeIndicator;
    
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder_image"];
    [_imageView sd_setImageWithURL:_imageURL
                  placeholderImage:placeholderImage
                           options:SDWebImageProgressiveLoad | SDWebImageDelayPlaceholder];
    _imageView.shouldCustomLoopCount = YES;
    _imageView.animationRepeatCount = 0;
}

- (void)toggleAnimation:(UIResponder *)sender {
    self.imageView.isAnimating ? [self.imageView stopAnimating] : [self.imageView startAnimating];
}

@end
