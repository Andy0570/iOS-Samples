//
//  RSKExampleViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/12.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "RSKExampleViewController.h"
#import <RSKImageCropper/RSKImageCropper.h>
#import <JKCategories/UIView+JKToast.h>

static const CGFloat kPhotoDiameter = 130.0f; // 照片直径
static const CGFloat kPhotoFrameViewPadding = 2.0f;

@interface RSKExampleViewController () <RSKImageCropViewControllerDelegate>

@property (nonatomic, strong) UIView *photoFrameView;
@property (nonatomic, strong) UIButton *addPhotoButton;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation RSKExampleViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.title = @"RSKImageCropper";
    self.view.backgroundColor = UIColor.whiteColor;
    
    // ---------------------------
    // 添加照片的圆形边框.
    // ---------------------------
    
    self.photoFrameView = [[UIView alloc] init];
    self.photoFrameView.backgroundColor = [UIColor colorWithRed:182/255.0f green:182/255.0f blue:187/255.0f alpha:1.0f];
    self.photoFrameView.translatesAutoresizingMaskIntoConstraints = NO;
    self.photoFrameView.layer.masksToBounds = YES;
    self.photoFrameView.layer.cornerRadius = (kPhotoDiameter + kPhotoFrameViewPadding) / 2;
    [self.view addSubview:self.photoFrameView];
    
    // ---------------------------
    // 添加"添加照片"按钮.
    // ---------------------------
    
    self.addPhotoButton = [[UIButton alloc] init];
    self.addPhotoButton.backgroundColor = [UIColor whiteColor];
    self.addPhotoButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.addPhotoButton.layer.masksToBounds = YES;
    self.addPhotoButton.layer.cornerRadius = kPhotoDiameter / 2;
    self.addPhotoButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addPhotoButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.addPhotoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.addPhotoButton setTitle:@"添加\n照片" forState:UIControlStateNormal];
    [self.addPhotoButton setTitleColor:[UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.addPhotoButton addTarget:self action:@selector(onAddPhotoButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addPhotoButton];
    
    // ----------------
    // 添加布局约束.
    // ----------------
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.didSetupConstraints) {
        return;
    }
    
    // ---------------------------
    // 相册的边框.
    // ---------------------------
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.photoFrameView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                                   constant:(kPhotoDiameter + kPhotoFrameViewPadding)];
    [self.photoFrameView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.photoFrameView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                               constant:(kPhotoDiameter + kPhotoFrameViewPadding)];
    [self.photoFrameView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.photoFrameView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f
                                               constant:0.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.photoFrameView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f
                                               constant:0.0f];
    [self.view addConstraint:constraint];
    
    // ---------------------------
    // "添加照片"按钮
    // ---------------------------
    
    constraint = [NSLayoutConstraint constraintWithItem:self.addPhotoButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                               constant:kPhotoDiameter];
    [self.addPhotoButton addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.addPhotoButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                               constant:kPhotoDiameter];
    [self.addPhotoButton addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.addPhotoButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                 toItem:self.photoFrameView attribute:NSLayoutAttributeCenterX multiplier:1.0f
                                               constant:0.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.addPhotoButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                 toItem:self.photoFrameView attribute:NSLayoutAttributeCenterY multiplier:1.0f
                                               constant:0.0f];
    [self.view addConstraint:constraint];
    
    self.didSetupConstraints = YES;
}

#pragma mark - Actions

- (void)onAddPhotoButtonTouch:(UIButton *)sender {
    UIImage *photo = [UIImage imageNamed:@"photo"];
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

#pragma mark - RSKImageCropViewControllerDelegate

/**
 通知 delegate 取消裁剪图像。
 */
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 通知 delegate 原始图像已经被裁剪。此外，还提供了一个裁剪矩形和用于生成图像的旋转角度。
 */
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle {
    [self.addPhotoButton setImage:croppedImage forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 通知 delegate 图像已经显示。
 */
- (void)imageCropViewControllerDidDisplayImage:(RSKImageCropViewController *)controller {
    NSLog(@"图像已经被显示。");
}

/**
 通知 delegate ，原始图像即将被裁剪。
 */
- (void)imageCropViewController:(RSKImageCropViewController *)controller willCropImage:(UIImage *)originalImage {
    NSLog(@"原始图像即将被裁剪。");
    // 当 `applyMaskToCroppedImage` 属性被设置为 YES 时使用
    // [SVProgressHUD show];
}

@end
