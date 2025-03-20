//
//  PINDetailViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/9/12.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "PINDetailViewController.h"

#import <PINRemoteImage/PINImageView+PINRemoteImage.h>
#import <PINRemoteImage/PINRemoteImageCaching.h>
#import <PINRemoteImage/PINRemoteImage.h>

@interface PINDetailViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation PINDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
}

- (void)configView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = self.view.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setPin_updateWithProgress:YES];
    
    [imageView pin_setImageFromURL:self.imageURL];
    
    self.imageView = imageView;
    [self.view addSubview:imageView];
}

@end
