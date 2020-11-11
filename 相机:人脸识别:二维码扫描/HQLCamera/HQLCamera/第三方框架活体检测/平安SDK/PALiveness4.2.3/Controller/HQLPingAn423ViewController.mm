//
//  HQLPingAn423ViewController.m
//  HQLTakePhotoDemo
//
//  Created by Qilin Hu on 2018/5/27.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "HQLPingAn423ViewController.h"

// Framework
#import <YYKit.h>

// Controller
#import "PALivenessDetector.h"   // 活体检测类
#import "PALivenessController.h" // 活体检测视图控制器类

// Views
#import "PALivenessFinishView.h"

@interface HQLPingAn423ViewController () <PALivenessDetectorDelegate, PALivenessFinishViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *faceImage;

@property (nonatomic, strong) PALivenessController *livenessController;

@property (nonatomic, strong) PALivenessFinishView *finishView;
@property (nonatomic, strong) UIViewController *finishViewController;

@end

@implementation HQLPingAn423ViewController

#pragma mark - Lifecycle

- (void)dealloc
{
    self.finishView = nil;
    self.finishViewController = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Custom Accessors

- (PALivenessController *)livenessController {
    if (!_livenessController) {
        _livenessController = [[PALivenessController alloc] initWithSetDelegate:self livenessDetectionType:DETECTION_TYPE_MouthOpen];
    }
    return _livenessController;
}

- (PALivenessFinishView *)finishView {
    if (!_finishView) {
        _finishView = [[PALivenessFinishView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) delegate:self];
    }
    return _finishView;
}

- (UIViewController *)finishViewController {
    if (!_finishViewController) {
        _finishViewController = [[UIViewController alloc] init];
        [_finishViewController.view addSubview:self.finishView];
    }
    return _finishViewController;
}

#pragma mark - IBActions

- (IBAction)detectButtonDidClicked:(id)sender {
    
    //  ------3.活体检测
    [self.livenessController.detector resetWithDetectionType:DETECTION_TYPE_MouthOpen];
    [self presentViewController:self.livenessController animated:YES completion:nil];
}

#pragma mark - PALivenessDetectorDelegate

/**
 活体检测成功回调
 
 @param faceImage  人脸正面照（即上传到服务器的照片）
 @param info       人脸正面照信息（自主选择）
 */
- (void)livenessDidSuccessfulWithFaceImage:(UIImage *)faceImage faceImageInfo:(NSDictionary *)info {
    NSLog(@"活体检测成功！");
//    // 1.更新请求数据模型
//    [self updateFormUploadModelWithImage:faceImage];
//
//    // 2.发起网络请求
//    [self uploadCertificationInfo];
    
}


/**
 活体检测失败回调
 
 @param errorType 活体检测失败枚举类型
 */
- (void)livenessDidFailWithErrorType:(PALivenessControllerDetectionFailureType)errorType {
    
    [self.finishView setFailureType:errorType];
    [self presentViewController:self.finishViewController animated:YES completion:nil];
}

/**
 活体检测被取消的回调
 */
- (void)livenessDidCancel {
    
    [self.finishView setFailureType:PALivenessControllerDetectionFailureTypeTimeOut];
    [self presentViewController:self.finishViewController animated:YES completion:nil];
}

#pragma mark - PALivenessFinishViewDelegate

// 重新检测
- (void)finishViewRecheckButtonDidClicked {
    
    // 重设检测器
    [self.livenessController.detector resetWithDetectionType:DETECTION_TYPE_MouthOpen];
    // 推出失败页面，开始检测
    [self.finishViewController dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:self.livenessController animated:YES completion:nil];
    }];
}

// 返回按钮
- (void)finishViewBackButtonDidClicked {
    [self.finishViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
