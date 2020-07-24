//
//  HQLFaceDetectiveViewController.m
//  HQLTakePhotoDemo
//
//  Created by ToninTech on 2017/4/6.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLFaceDetectiveViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+fixOrientation.h"

@interface HQLFaceDetectiveViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
/** 识别到的人脸图片*/
@property (nonatomic, strong) UIImage *recognizedFaceImg;
/** 识别到的人脸数量*/
@property (nonatomic, assign) NSUInteger numOfFace;
/** 显示的照片*/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
/** 拍照按钮*/
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
/** 上传按钮*/
@property (weak, nonatomic) IBOutlet UIButton *comformUpdate;

@end

@implementation HQLFaceDetectiveViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationControllerAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors
- (void)setNavigationControllerAppearance {
    // 设置导航栏标题&字体&颜色
    self.navigationItem.title = @"人脸识别";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [_comformUpdate setHidden:YES];
}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [UIImagePickerController new];
        if ([self isTakePhotoAvailable]) {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
            _imagePicker.delegate = self;
            _imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
            [self setFrontFacingCameraOnImagePicker:_imagePicker];
            [self configureCustomUIOnImagePicker:_imagePicker];
        }else {
            NSLog(@"请在iPhone的“设置-隐私-相机”选项中，允许APP访问你的相机");
        }
    }
    return _imagePicker;
}

- (BOOL)isTakePhotoAvailable {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            return YES;
        }
    }
    return NO;
}

- (void)setFrontFacingCameraOnImagePicker:(UIImagePickerController *)picker {
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        [picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
    }
}

- (void)configureCustomUIOnImagePicker:(UIImagePickerController *)picker {
    picker.showsCameraControls = YES;
    UIImage *image = [UIImage imageNamed:@"mask_green"];
    UIImageView *cameraOverLayerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 585)];
    cameraOverLayerImage.image = image;
    picker.cameraOverlayView = cameraOverLayerImage;
}

#pragma mark - IBAction
// 拍照
- (IBAction)takePicture:(UIButton *)sender {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
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

#pragma mark 人脸识别
- (void)faceDetectWithImage:(UIImage *)inputImage {
    
    NSDictionary *imageOptions =  [NSDictionary dictionaryWithObject:@(1) forKey:CIDetectorImageOrientation];
    
    // 将图像转换为CIImage
    CIImage *originFaceCIImage = [CIImage imageWithCGImage:inputImage.CGImage];
    
    // 图像识别能力：CIDetectorAccuracyHigh
    NSDictionary *opts = [NSDictionary dictionaryWithObject:
                          CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *faceDetector=[CIDetector detectorOfType:CIDetectorTypeFace
                                                context:context
                                                options:opts];
    
    // 识别出人脸数组
    NSArray *featuresArray = [faceDetector featuresInImage:originFaceCIImage options:imageOptions];
    
    _numOfFace = (unsigned long)[featuresArray count];
    NSLog(@"识别出人脸数：%lu",(unsigned long)_numOfFace);
    switch (_numOfFace) {
        case 0:
        {
            _textLabel.text = @"未检测到人脸,如多次拍照失败，请摘掉眼镜到光线明亮处再试！";
            _recognizedFaceImg = [UIImage imageNamed:@"transparencyPattern"];
            [_comformUpdate setHidden:YES];
            break;
        }
        case 1:
        {
            _textLabel.text = @"已检测到 1 张人脸";
            // 裁剪出人脸
            CIImage *image = [originFaceCIImage imageByCroppingToRect:[[featuresArray objectAtIndex:0] bounds]];
            UIImage *faceImage = [UIImage imageWithCGImage:[context createCGImage:image fromRect:image.extent]];
            _recognizedFaceImg = [self imageWithImageSimple:faceImage scaledToSize:CGSizeMake(512, faceImage.size.height*512/faceImage.size.width)];
            [_comformUpdate setHidden:NO];
            break;
        }
        default:
        {
            NSString *textString = [NSString stringWithFormat:@"检测到 %lu 张人脸，请重新拍照 ",(unsigned long)_numOfFace];
            _textLabel.text = textString;
            _recognizedFaceImg = [UIImage imageNamed:@"transparencyPattern"];
            [_comformUpdate setHidden:YES];
        }
            break;
    }
    _imageView.image = _recognizedFaceImg;
    [_takePhoto setTitle:@"重新拍照" forState:UIControlStateNormal];
}

#pragma mark 调整图片像素
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

#pragma mark image转换为base64格式
- (NSString *)imageToString:(UIImage *)image {
    // image -> data 转换为JPEG格式，压缩率为0.5
    NSData *pictureData = UIImageJPEGRepresentation(image, 0.5);
    // data -> string 将图片转换为base64字符串
    NSString *pictureString = [pictureData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return pictureString;
}


#pragma mark - UIImagePickerControllerDelegate methods

// 完成选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        UIImage *inputImage = [image fixOrientation];   // 修改图像方向信息
        [self faceDetectWithImage:inputImage];  // 人脸识别
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
