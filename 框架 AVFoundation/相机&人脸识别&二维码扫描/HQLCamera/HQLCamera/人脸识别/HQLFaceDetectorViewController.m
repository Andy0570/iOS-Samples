//
//  HQLFaceDetectorViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLFaceDetectorViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+fixOrientation.h"
#import <JKCategories/UIView+JKToast.h>

@interface HQLFaceDetectorViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/** 显示的照片*/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
/** 拍照按钮*/
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
/** 上传按钮*/
@property (weak, nonatomic) IBOutlet UIButton *comformUpdate;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
/** 识别到的人脸图片*/
@property (nonatomic, strong) UIImage *recognizedFaceImg;
/** 识别到的人脸数量*/
@property (nonatomic, assign) NSUInteger numOfFace;

@end

@implementation HQLFaceDetectorViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationControllerAppearance];
}

// 设置导航栏标题&字体&颜色
- (void)setNavigationControllerAppearance {
    self.navigationItem.title = @"人脸识别";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [_comformUpdate setHidden:YES];
}

#pragma mark - Custom Accessors

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark - IBAction

// 拍照，打开前置摄像头，拍摄照片
- (IBAction)takePicture:(UIButton *)sender {
    BOOL isSourceTypeAvailable = [self settingCameraSourceType];
    if (!isSourceTypeAvailable) return;
    
    BOOL isFrontCameraDeviceAvailable = [self settingFrontCameraDevice];
    if (!isFrontCameraDeviceAvailable) return;
    
    // 设定拍照的媒体类型，照片
    self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    
    // 设置摄像头捕捉模式为捕捉图片
    self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    
    // 设置照片质量
    self.imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    // 自定义相机预览图层
    [self setttingCameraOverlayView];
    
    // 以模态样式呈现照片选择器
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

// 上传照片
- (IBAction)UploadPicture:(id)sender {
    if (_numOfFace == 1) {
        _imageView.image = _recognizedFaceImg;
    }
    BOOL isImageViewNill = _imageView.image == nil;
    if (isImageViewNill) {
        NSLog(@"提示：请先拍摄照片后再上传");
    }else {
        NSString *base64Picture = [self imageToString:_imageView.image];
        NSLog(@"upload base64Picture:%@",base64Picture);
    }
}

#pragma mark - Private

// 配置从相机获取图片
- (BOOL)settingCameraSourceType {
    // 检查设备硬件是否可用
    BOOL isSourceTypeAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (isSourceTypeAvailable) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        [self.view jk_makeToast:@"相机硬件不可用，请检查后再试～"];
    }
    
    return isSourceTypeAvailable;
}

// 配置打开相机前置摄像头
- (BOOL)settingFrontCameraDevice {
    // 设置打开前置摄像头
    BOOL isFrontCameraDeviceAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    if (isFrontCameraDeviceAvailable) {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        [self.view jk_makeToast:@"前置摄像头不可用，请检查后再试～"];
    }
    
    return isFrontCameraDeviceAvailable;
}

// 设置自定义相机预览图层
- (void)setttingCameraOverlayView {
    self.imagePickerController.showsCameraControls = YES;
    
    UIImage *image = [UIImage imageNamed:@"mask_green"];
    const UIEdgeInsets safeArea = self.view.safeAreaInsets;
    UIImageView *cameraOverLayerImage = [[UIImageView alloc] initWithFrame:CGRectMake(safeArea.left, safeArea.top, 375, 585)];
    cameraOverLayerImage.image = image;
    self.imagePickerController.cameraOverlayView = cameraOverLayerImage;
}

// !!!: 人脸识别核心算法
- (void)faceDetectorWithImage:(UIImage *)image {

    /**
     图像识别能力：
     CIDetectorAccuracyHigh 表示较强的处理能力
     CIDetectorAccuracyLow 表示较弱的处理能力
     */
    NSDictionary *options = @{CIDetectorAccuracy: CIDetectorAccuracyHigh};
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:options];
    
    // 将图像转换为 CIImage 对象
    CIImage *originFaceCIImage = [CIImage imageWithCGImage:image.CGImage];
    NSDictionary *imageOptions = @{CIDetectorImageOrientation: @1};
    
    // 识别出人脸数组
    NSArray *features = [faceDetector featuresInImage:originFaceCIImage options:imageOptions];
    
    self.numOfFace = (unsigned long)features.count;
    NSLog(@"识别出人脸数：%lu",self.numOfFace);
    
    switch (self.numOfFace) {
        case 0: {
            self.textLabel.text = @"未检测到人脸,如多次拍照失败，请摘掉眼镜到光线明亮处再试！";
            self.comformUpdate.hidden = YES;
            break;
        }
        case 1: {
            self.textLabel.text = @"已检测到 1 张人脸";
            // 裁剪出人脸
            CIImage *image = [originFaceCIImage imageByCroppingToRect:[[features objectAtIndex:0] bounds]];
            UIImage *faceImage = [UIImage imageWithCGImage:[context createCGImage:image fromRect:image.extent]];
            self.recognizedFaceImg = [self imageWithImageSimple:faceImage scaledToSize:CGSizeMake(512, faceImage.size.height*512/faceImage.size.width)];
            self.comformUpdate.hidden = NO;
            break;
        }
        default: {
            NSString *textString = [NSString stringWithFormat:@"检测到 %lu 张人脸，请重新拍照 ",(unsigned long)_numOfFace];
            self.textLabel.text = textString;
            self.comformUpdate.hidden = YES;
        }
            break;
    }
    self.imageView.image = self.recognizedFaceImg;
    
    [self.takePhoto setTitle:@"重新拍照" forState:UIControlStateNormal];
}

// 调整图片像素
- ( UIImage *)imageWithImageSimple:( UIImage *)image scaledToSize:( CGSize )newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext (newSize);
    // Tell the old image to draw in this new context, with the desired new size
    [image drawInRect : CGRectMake ( 0 , 0 ,newSize. width ,newSize. height )];
    // Get the new image from the context
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext ();
    // End the context
    UIGraphicsEndImageContext ();
    // Return the new image.
    return newImage;
}

// image转换为base64格式
- (NSString *)imageToString:(UIImage *)image {
    // image -> data 转换为JPEG格式，压缩率为0.5
    NSData *pictureData = UIImageJPEGRepresentation(image, 0.5);
    // data -> string 将图片转换为base64字符串
    NSString *pictureString = [pictureData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return pictureString;
}

#pragma mark - <UIImagePickerControllerDelegate>

// 完成选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    // 从 info 中获取此时摄像头的媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // 如果是拍照，获取拍照的图形
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        // 修改图像方向信息
        UIImage *inputImage = [originalImage fixOrientation];
        // 进行人脸识别
        [self faceDetectorWithImage:inputImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
