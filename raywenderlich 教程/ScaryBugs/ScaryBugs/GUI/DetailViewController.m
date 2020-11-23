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

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

#pragma mark - Actions

// 以模态方式显示图片选择器，并访问系统相册获取照片
- (IBAction)addPictureTapped:(id)sender {
    if (!self.picker) {
        
        // 1. 显示加载进度条
        [SVProgressHUD showWithStatus:@"正在加载中..."];
        
        // 2.切换到后台线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.delegate = self;
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.picker.allowsEditing = NO;
            
            // 3.返回主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:self->_picker animated:YES completion:nil];
                [SVProgressHUD dismiss];
            });
        });
    } else {
        [self presentViewController:_picker animated:YES completion:nil];
    }
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
