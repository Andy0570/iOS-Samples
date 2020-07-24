# HQLTakePhotoDemo

# UIImagePickerController

**UIImagePickerController** 类用于管理可定制的，基于系统支持的用户界面，用于在支持的设备上拍摄照片和电影，并且在你的app中为用户保存照片和电影。 图像选择器控制器管理用户交互并将这些交互的结果传递给委托对象。



## 使用步骤：

需要导入包：```import <MobileCoreServices/MobileCoreServices.h>```;
拍摄视频需要导入包：```#import <AssetsLibrary/AssetsLibrary.h>```
需要遵循的协议：```<UINavigationControllerDelegate,UIImagePickerControllerDelegate>```;

###  1️⃣  创建 UIImagePickerController 对象

```objective-c
UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
```



### 2️⃣ 设置 sourceType 

>  UIImagePickerControllerSourceType:
>
>  ```objective-c
>  UIImagePickerControllerSourceTypePhotoLibrary, // 照片库
>  UIImagePickerControllerSourceTypeCamera, // 内置摄像机
>  UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相册
>  ```

```objective-c
// 验证设备是否能够从所需的来源获取内容
BOOL isSourceTypeAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
if (!isSourceTypeAvailable) {
    NSLog(@"启动相机失败,您的相机功能未开启，请转到手机设置中开启相机权限!");
}else{
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
}
```

​      

###  3⃣️  设置摄像头捕捉模式 

>  UIImagePickerControllerCameraCaptureMode:
>
>  ```objective-c
>  UIImagePickerControllerCameraCaptureModePhoto, // 拍照模式，默认
>  UIImagePickerControllerCameraCaptureModeVideo   // 视频录制模式
>  ```

**拍照模式**:

```objective-c
// 设定拍照的媒体类型
imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
// 设置摄像头捕捉模式为捕捉图片，默认
imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
```

**录像模式**:

```objective-c
// 设定录像的媒体类型
imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
// 设置摄像头捕捉模式为捕捉视频
imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
```



### 4⃣️ 摄像头设备

> UIImagePickerControllerCameraDevice:
>
> ```objective-c
> UIImagePickerControllerCameraDeviceRear,   //后置摄像头，默认
> UIImagePickerControllerCameraDeviceFront   //前置摄像头         
> ```

```objective-c
// 设置前置摄像头
if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
}
```



### 5⃣️ 设置图片质量

> UIImagePickerControllerQualityType
>
> ```objective-c
> UIImagePickerControllerQualityTypeHigh // highest quality
> UIImagePickerControllerQualityTypeMedium // medium quality, suitable for transmission via Wi-Fi
> UIImagePickerControllerQualityTypeLow // lowest quality, suitable for tranmission via cellular network
> UIImagePickerControllerQualityType640x480 // VGA quality
> UIImagePickerControllerQualityTypeIFrame1280x720
> UIImagePickerControllerQualityTypeIFrame960x540
> ```

```objective-c
imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
```



### 6⃣️ 设置闪光灯模式

>UIImagePickerControllerCameraFlashMode
>
>```objective-c
>UIImagePickerControllerCameraFlashModeOff  = -1,
>UIImagePickerControllerCameraFlashModeAuto = 0,默认
>UIImagePickerControllerCameraFlashModeOn   = 1
>```

```objective-c
imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto
```



### 7⃣️ 遵循协议

```objective-c
imagePicker.delegate = self;
```



### 8⃣️  是否显示系统自带的摄像头控制面板，默认YES

```objective-c
//显示标准相机UI，
imagePicker.showsCameraControls = NO;
```



### 9⃣️ 设置自定义覆盖图层

```objective-c
UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
overlayImageView.image = [UIImage imageNamed:@"circle3.png"];
UIView *cameraOverlay = overlayImageView;

imagePicker.cameraOverlayView = cameraOverlay
```



### 🔟 以模态形式显示UIImagePickerController对象

```objective-c
[self presentViewController:imagePicker animated:YES completion:nil];
```



## UIImagePickerControllerDelegate

```objective-c
#pragma mark - 完成选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%s",__func__);
    
    // 从info取出此时摄像头的媒体类型
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // 【拍照模式】
        // 通过info字典获取选择的照片
        UIImage *image = info[UIImagePickerControllerOriginalImage];
     
        // 将照片放入UIImageView对象显示在UI界面
        self.imageView.image = image;
        
        // 保存图像到相簿
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        // 【录像模式】
        
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSString *path = url.path;
        
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            // 保存视频到相簿
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
    // 关闭UIImagePickerController对象
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 取消拍照
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"%s",__func__);
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 保存图像或视频完成的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存图片完成");
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存视频完成");
}

```



##  封装使用

**VideoCaptureDemo** 中将 **UIImagePickerController** 封装成了一个Object 类使用，可以参考：

### IDImagePickerCoordinator.h

```objective-c
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 图片选择协调器
 */
@interface IDImagePickerCoordinator : NSObject

#pragma mark - getter 方法
- (UIImagePickerController *)cameraVC;

@end
```

### IDImagePickerCoordinator.m

```objective-c
#import "IDImagePickerCoordinator.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface IDImagePickerCoordinator () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *camera;

@end

@implementation IDImagePickerCoordinator

#pragma mark - Init methods
- (instancetype)init
{
    self = [super init];
    if(self){
        _camera = [self setupImagePicker];
    }
    return self;
}

- (UIImagePickerController *)cameraVC
{
    return _camera;
}

#pragma mark - Private methods

- (UIImagePickerController *)setupImagePicker
{
    UIImagePickerController *camera;
    if([self isVideoRecordingAvailable]){
        camera = [UIImagePickerController new];
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        camera.mediaTypes = @[(NSString *)kUTTypeMovie];
        camera.delegate = self;
    }
    return camera;
}

- (BOOL)isVideoRecordingAvailable
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)setFrontFacingCameraOnImagePicker:(UIImagePickerController *)picker
{
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
        [picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
        return YES;
    }
    return NO;
}

- (void)configureCustomUIOnImagePicker:(UIImagePickerController *)picker
{
    UIView *cameraOverlay = [[UIView alloc] init];
    picker.showsCameraControls = NO;
    picker.cameraOverlayView = cameraOverlay;
}

#pragma mark - UIImagePickerControllerDelegate methods

// 完成选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    
}

// 完成选择视频
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSURL *recordedVideoURL= [info objectForKey:UIImagePickerControllerMediaURL];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:recordedVideoURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:recordedVideoURL
                                    completionBlock:^(NSURL *assetURL, NSError *error){}
         ];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end

```

使用时先导入头文件，设置属性：

```
@property (nonatomic, strong) IDImagePickerCoordinator *imagePickerCoordinator;
```

再调用：

```
self.imagePickerCoordinator = [IDImagePickerCoordinator new];
[self presentViewController:[_imagePickerCoordinator cameraVC] animated:YES completion:nil];
```



# AVFoundation

### HQLAVFoundationViewController.h

```
#import <UIKit/UIKit.h>

/**
 使用AVFoundation类拍照
 */
@interface HQLAVFoundationViewController : UIViewController

@end
```

### HQLAVFoundationViewController.m

````objective-c
#import "HQLAVFoundationViewController.h"
#import <AVFoundation/AVFoundation.h>
#define ThemeColor [UIColor colorWithDisplayP3Red:81/255.0 green:136/255.0 blue:247/255.0 alpha:1.0]

@interface HQLAVFoundationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *openCaptureBtn;
@property (weak, nonatomic) IBOutlet UIButton *canptureBtn;

@property (strong, nonatomic) AVCaptureSession *session;    //媒体管理会话
@property (strong, nonatomic) AVCaptureDeviceInput *captureInput;   //输入数据对象
@property (strong, nonatomic) AVCaptureStillImageOutput *imageOutput;   //输出数据对象
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureLayer; //视频预览图层


@end

@implementation HQLAVFoundationViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationControllerAppearance];
    //初始化摄像头
    [self initCaptureSession];
    
    self.openCaptureBtn.hidden = NO;
    self.canptureBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors
- (void)setNavigationControllerAppearance {
    // 设置导航栏标题&字体&颜色
    self.navigationItem.title = @"AVFoundation拍照";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:ThemeColor}];
}

#pragma mark 初始化摄像头
- (void)initCaptureSession {
    /*
     1️⃣ AVCaptureSession
     媒体捕捉会话，管理输入与输出之间的数据流，以及在出现问题时生成运行时错误。
     负责把捕获到的音频视频数据输出到输出设备上，一个会话可以有多个输入输入。
     */
    // 1.创建媒体管理会话
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    
    self.session = captureSession;
    
    // 判断分辨率是否支持 1280*720，支持就设置为：1280*720
    if ([captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    /*
     2️⃣ AVCaptureDevice
     关于相机硬件的接口。它被用于控制硬件特性，诸如镜头的位置、曝光、闪光灯等。
     */
    
    // 2.获取后置摄像头
    AVCaptureDevice *captureDevice = nil;
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if (camera.position == AVCaptureDevicePositionBack) {
            // 获得后置摄像头
            captureDevice = camera;
        }
    }
    if (!captureDevice) {
        NSLog(@"2.取得后置摄像头错误！");
        return;
    }
    
    // 取得前置摄像头
    //    AVCaptureDevice *frontCaptureDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    
    /*
     3️⃣ AVCaptureDeviceInput
     设备输入数据管理对象，管理输入数据
     */
    
    // 3.创建输入数据对象
    NSError *error = nil;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"3.创建输入数据对象错误");
        return;
    }
    
    self.captureInput = captureInput;
    
    /*
     4️⃣ AVCaptureOutput
     设备输出数据管理对象，管理输出数据，通常使用它的子类：
     AVCaptureAudioDataOutput   //输出音频管理对象，输出数据为NSData
     AVCaptureStillImageDataOutput  //输出图片管理对象，输出数据为NSData
     AVCaptureVideoDataOutput   //输出视频管理对象，输出数据为NSData
     
     AVCaptureFileOutput
     输出文件管理对象，输出数据以文件形式输出
     {//子类
     AVCaptureAudioFileOutput   //输出是音频文件
     AVCaptureMovieFileOutput   //输出是视频文件
     }
     */
    
    // 4.创建输出数据对象
    AVCaptureStillImageOutput *imageOutpot = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *setting = @{
                              AVVideoCodecKey:AVVideoCodecJPEG
                              };
    [imageOutpot setOutputSettings:setting];
    
    self.imageOutput = imageOutpot;
    
    // 5️⃣ 5.添加【输入数据对象】和【输出对象】到会话中
    if ([captureSession canAddInput:captureInput]) {
        [captureSession addInput:captureInput];
    }
    if ([captureSession canAddOutput:imageOutpot]) {
        [captureSession addOutput:imageOutpot];
    }
    
    
    /*
     6️⃣ AVCaptureVideoPreviewLayer
     实时预览图层
     AVCaptureVideoPreviewLayer 是 CALayer 的子类，可被用于自动显示相机产生的实时图像。它还有几个工具性质的方法，可将 layer 上的坐标转化到设备上。它看起来像输出，但其实不是。另外，它拥有 session (outputs 被 session 所拥有)。
     */
    
    // 6.创建实时预览图层
    AVCaptureVideoPreviewLayer *previewlayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    self.view.layer.masksToBounds = YES;
    previewlayer.frame = self.view.bounds;
    previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 【预览图层】插入在【拍照按钮】的下方
    [self.view.layer insertSublayer:previewlayer below:self.canptureBtn.layer];
    
    self.captureLayer = previewlayer;
}

#pragma mark - IBAction

#pragma mark 打开摄像头
- (IBAction)takePhoto:(UIButton *)sender {
    
    self.captureLayer.hidden = NO;
    self.canptureBtn.hidden = NO;
    self.openCaptureBtn.hidden = YES;
    [self.session startRunning];    //开始捕捉
    
}

#pragma mark 拍照
- (IBAction)takeMedia:(id)sender {
    // 根据设备输出获得连接
    AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    // 通过连接获得设备的输出数据
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        // 获取输出的JPG图片
        NSData *imgData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imgData];
        
        self.imageView.image = image;
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);   //保存到相册
        self.captureLayer.hidden = YES;
        self.canptureBtn.hidden = YES;
        self.openCaptureBtn.hidden = NO;
        [self.session stopRunning];
    }];
}

@end

````

> 关于 **AVFoundation** 视频录制的使用推荐阅读：[ctolib:在 iOS 上捕获 **视频**](http://www.ctolib.com/docs-objc-c-video-23-1.html)
>
> 以及源码：[**VideoCaptureDemo**](https://github.com/objcio/VideoCaptureDemo)
>
> 



### 配合使用 CoreImage 实现人脸识别

 人脸识别过程分3个步骤：

1. 首先建立人脸的【面纹数据库】;
2. 获取当前人脸面像图片;
3. 用当前的面纹编码与数据库中的面纹编码进行比对。

  **CIDetector** 是 **CoreImage** 中的一个特征识别滤镜。它可以找到图片中的人脸，但是是谁无法判断，需要数据库。要想识别可以看 **OpenCV** 和 **Face.com**。

```objective-c
#pragma mark - 识别人脸

/**
 识别人脸算法

 @param image 输入的图片
 */
- (void)faceDetectWithImage:(UIImage *)image {
    
    NSDictionary *imageOptions =  [NSDictionary dictionaryWithObject:@(5) forKey:CIDetectorImageOrientation];
    
    // 将图像转换为CIImage
    CIImage *personciImage = [CIImage imageWithCGImage:image.CGImage];
    
    // 设置识别参数
    NSDictionary *opts = [NSDictionary dictionaryWithObject:
                          CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    CIContext *context = [CIContext contextWithOptions:nil];
    //声明一个CIDetector，并设定识别器类型为人脸识别
    CIDetector *faceDetector=[CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
    
    // 识别出人脸数组
    // featuresInImage:方法 识别器会找到所给图像中的人脸，最后返回一个人脸数组
    NSArray *features = [faceDetector featuresInImage:personciImage options:imageOptions];
    
    // 得到图片的尺寸
    CGSize inputImageSize = [personciImage extent].size;
    // 利用仿射变换将image沿Y轴对称
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    // 将图片上移
    transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
    
    // 遍历识别到的人脸
    for (CIFaceFeature *faceFeature in features) {
        
        // 获取人脸的frame
        CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
        CGSize viewSize = _imageView.bounds.size;
        CGFloat scale = MIN(viewSize.width / inputImageSize.width,
                            viewSize.height / inputImageSize.height);
        
        CGFloat offsetX = (viewSize.width - inputImageSize.width * scale) / 2;
        CGFloat offsetY = (viewSize.height - inputImageSize.height * scale) / 2;
        // 缩放
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        // 修正
        faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, scaleTransform);
        faceViewBounds.origin.x += offsetX;
        faceViewBounds.origin.y += offsetY;
        
        // 描绘人脸区域
        UIView *faceView = [[UIView alloc] initWithFrame:faceViewBounds];
        faceView.layer.borderWidth = 2;
        faceView.layer.borderColor = [UIColor redColor].CGColor;
        [_imageView addSubview:faceView];
        
        // 判断是否有左眼位置
        if(faceFeature.hasLeftEyePosition){}
        // 判断是否有右眼位置
        if(faceFeature.hasRightEyePosition){}
        // 判断是否有嘴位置
        if(faceFeature.hasMouthPosition){}
        // 判断是否微笑
        if (faceFeature.hasSmile){}
    }
    
    // 裁剪识别到的人脸
    if ([features count]>0) {
      
        CIImage *image = [personciImage imageByCroppingToRect:[[features objectAtIndex:0] bounds]];
        UIImage *face = [UIImage imageWithCGImage:[context createCGImage:image fromRect:image.extent]];
        // 显示裁剪后的人脸
        _imageView.image = face;
        
        NSLog(@"识别人脸数：:%lu",(unsigned long)[features count]);
    }   
}
```

> 关于拍照完成后使用人脸识别并裁剪，显示的人脸图片方向自动逆时针旋转90°显示的问题：
> **原因**：iPhone 默认的方向是HOME 键位于左边的方向，故竖屏情况原始图像被拍摄后的EXIF方向值是6，被裁剪后方向信息会被删除，置为1。
>  **解决方法**：在人像识别之前先修改图像的EXIF信息为1，再进行人像识别，CIDetectorImageOrientation 值也需要改为1。
* [如何处理iOS中照片的方向](http://feihu.me/blog/2015/how-to-handle-image-orientation-on-iOS/)
* [iOS UIImagePickerController result image orientation after upload](http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload/10611036#10611036)
  输出结果：

![](https://ww3.sinaimg.cn/large/006tKfTcgy1fd6p1qwmyfj30em0o610i.jpg)

### 参考资料
#### 人脸识别
* [百度百科：人脸识别](http://baike.baidu.com/view/246859.htm)
* [eye blink detect眨眼检测算法](http://m.blog.csdn.net/article/details?id=14111901)
* [OpenCV — 人脸识别](http://blog.csdn.net/jscese/article/details/54409627)
* [iOS学习笔记27-摄像头](http://www.jianshu.com/p/f00c5031dccd)
* [30分钟搞定iOS自定义相机](http://www.jianshu.com/p/8b28892bae5a)
* [objc中国期刊#21相机与照片](https://www.objccn.io/issues/)
* [iOS 上的相机捕捉](https://www.objccn.io/issue-21-3/)
* [ctolib:在 iOS 上捕获 **视频**](http://www.ctolib.com/docs-objc-c-video-23-1.html)
* [objc中国期刊#21基于 OpenCV 的人脸识别](https://www.objccn.io/issue-21-9/)
* [ 【从零学习openCV】IOS7人脸识别实战](http://blog.csdn.net/shawn_ht/article/details/27868973)
* [libfacedetection ](https://github.com/ShiqiYu/libfacedetection)– C++ 人脸识别 包含正面和多视角人脸检测两个算法.优点:速度快(OpenCV haar+adaboost的2-3倍), 准确度高 (FDDB非公开类评测排名第二），能估计人脸角度
* [RSKImageCropper](https://github.com/ruslanskorb/RSKImageCropper)适用于iOS的图片裁剪器，类似Contacts app，可上下左右移动图片选取最合适的区域
* [iOS之使用CoreImage进行人脸识别](https://github.com/VictDog/FaceDetector)
* [CoreImage](http://www.cnblogs.com/zhanggui/p/4743128.html)
* [GitHub框架：**PBJVision**](https://github.com/piemonte/PBJVision)
* [TGCameraViewController](https://github.com/tdginternet/TGCameraViewController):基于 AVFoundation 的自定义相机。样式漂亮，轻量并且可以很容易地集成到 iOS 项目中。

### OpenCV
* [OpenCV官方学习文档](http://brightguo.com/opencv/)
* [OpenCV入门指南](http://blog.csdn.net/morewindows/article/category/1291764)
* [OPEN CV for iOS](http://blog.csdn.net/column/details/opencvonios.html)