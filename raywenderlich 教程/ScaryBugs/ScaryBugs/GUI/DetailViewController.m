//
//  DetailViewController.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2020/11/21.
//

#import "DetailViewController.h"
#import "RWTScaryBugDoc.h"
#import "RWTScaryBugData.h"
#import "RWTUIImageExtras.h"
#import "SVProgressHUD.h"
#import <AVFoundation/AVFoundation.h>

@implementation DetailViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

#pragma mark - Actions

// 以模态方式显示图片选择器，并访问系统相册获取照片
- (IBAction)addPictureTapped:(id)sender {
    // MARK: 相机权限校验
    __weak __typeof(self)weakSelf = self;
    [self cameraAuthorizationStatusForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            // 打开相册
            [weakSelf presentSelectPhotoController];
        } else {
            // 引导用户至系统设置
            [weakSelf presentGoSettingAlert];
        }
    }];
}

// 用户更新输入文本框内容后，同步更新模型数据
- (IBAction)titleFieldTextChanged:(id)sender {
    self.detailItem.data.title = self.titleField.text;
    [self.detailItem saveData];  // #1
}

#pragma mark - Private

- (void)configureView {
    // 配置星级评论视图
    self.rateView.rateStyle = XHStarRateViewRateStyeHalfStar;
    self.rateView.isAnimation = YES;
    self.rateView.delegate = self;
    
    // 配置其他 UI
    self.titleField.delegate = self;
    if (self.detailItem) {
        self.titleField.text = self.detailItem.data.title;
        if (self.detailItem.data.rating) {
            self.rateView.currentRating = self.detailItem.data.rating;
        }
        
        if (self.detailItem.fullImage) {
            self.imageView.image = self.detailItem.fullImage;
            
            // 设置图片视差效果
            // 图片视差效果：水平方向
            UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
            effectX.maximumRelativeValue = @(-50);
            effectX.minimumRelativeValue = @(50);
            [self.imageView addMotionEffect:effectX];
            
            // 图片视差效果：垂直方向
            UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
            effectY.maximumRelativeValue = @(-50);
            effectY.minimumRelativeValue = @(50);
            [self.imageView addMotionEffect:effectY];
        }
    }
}

// 返回当前相机授权权限
- (void)cameraAuthorizationStatusForMediaType:(AVMediaType)cameraMediaType completionHandler:(void (^)(BOOL granted))handler {
    AVAuthorizationStatus cameraAuthorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:cameraMediaType];
    switch (cameraAuthorizationStatus) {
        case AVAuthorizationStatusAuthorized:
            handler(YES);
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            handler(NO);
            break;
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:cameraMediaType completionHandler:^(BOOL granted) {
                handler(granted);
            }];
            break;
    }
}

// 打开相册
- (void)presentSelectPhotoController {
    if (!self.picker) {
        
        // 1. 显示加载进度条
        [SVProgressHUD showWithStatus:@"正在加载中..."];
                
        // 2.主线程执行
        // !!!: UIImagePickerController 的初始化和设置工作只能在主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.delegate = self;
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.picker.allowsEditing = NO;
            [self presentViewController:self->_picker animated:YES completion:nil];
            [SVProgressHUD dismiss];
        });
    } else {
        [self presentViewController:_picker animated:YES completion:nil];
    }
}

// 当用户拒绝时，引导用户至系统设置页开启
- (void)presentGoSettingAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在设置-隐私-相机中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openURLtoSetting];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 打开系统设置页面
- (void)openURLtoSetting {
    NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:settingsUrl];
    if (! canOpenURL) { return; }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:settingsUrl options:@{} completionHandler:nil];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:settingsUrl];
#pragma clang diagnostic pop
        }
    });
}

#pragma mark - UITextFieldDelegate

// 用户点击键盘返回按钮，收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - XHStarRateViewDelegate

// 用户设置评分后，同步更新模型数据
-(void)starRateView:(XHStarRateView *)starRateView ratingDidChange:(CGFloat)currentRating {
    self.detailItem.data.rating = currentRating;
    [self.detailItem saveData]; // #2
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    UIImage *fullImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 1.显示加载进度
    [SVProgressHUD showWithStatus:@"调整图片大小..."];
    
    if (fullImage) {
        // 2.切换到后台线程
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            
            UIImage *thumbImage = [fullImage imageByScalingAndCroppingForSize:CGSizeMake(44, 44)];
            
            // 3.返回主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.detailItem.fullImage = fullImage;
                self.detailItem.thumbImage = thumbImage;
                self.imageView.image = fullImage;
                [self.detailItem saveImages]; // 保存图片到磁盘
                [SVProgressHUD dismiss];
            });
        });
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 取消选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Override

// Implement the method shouldAutorotateToInterfaceOrientation
- (BOOL)shouldAutorotateToInterfaceOrientation {
    return YES;
}

@end
