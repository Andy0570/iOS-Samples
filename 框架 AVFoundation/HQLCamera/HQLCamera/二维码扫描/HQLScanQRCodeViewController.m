//
//  HQLScanQRCodeViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/7/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface HQLScanQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate, CALayerDelegate>

/**
 * UI
 */
@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UIImageView *scanline;
@property (weak, nonatomic) IBOutlet UILabel *result;

// 扫描区域的高度约束值（宽度一致）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanViewHeight;

// 扫描线的顶部约束值
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanLineTop;

@property (strong, nonatomic) CALayer *maskLayer;

/**
 * AVFoundation 框架中的 5 个核心类
 */
@property (strong, nonatomic) AVCaptureSession *session;                // 媒体管理会话
@property (strong, nonatomic) AVCaptureDevice *device;                  // 设备管理器
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInput;        // 输入数据对象
@property (strong, nonatomic) AVCaptureMetadataOutput *metadataOutput;  // 输出数据对象
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer; // 视频预览图层

@end

@implementation HQLScanQRCodeViewController

#pragma mark - View life cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加输入和输出设备
    if ([self.session canAddInput:self.deviceInput]) {
        [self.session addInput:self.deviceInput];
    }
    if ([self.session canAddOutput:self.metadataOutput]) {
        [self.session addOutput:self.metadataOutput];
    }
    
    // 设置本次扫描的数据类型:AVMetadataObjectTypeQRCode
    self.metadataOutput.metadataObjectTypes = self.metadataOutput.availableMetadataObjectTypes;
    
    // 添加预览图层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    // 创建周围的遮罩层
    CALayer *maskLayer = [[CALayer alloc] init];
    maskLayer.frame = self.view.bounds;
    
    // 此时设置的颜色就是中间扫描区域的最终的颜色
    maskLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2].CGColor;
    maskLayer.delegate = self;
    [self.view.layer insertSublayer:maskLayer above:self.previewLayer];
    
    //让代理方法调用 将周围的蒙版颜色加深
    [maskLayer setNeedsDisplay];
    
    self.maskLayer = maskLayer;
    
    // 关键设置扫描的区域，方法二：直接转换,但是要在 AVCaptureInputPortFormatDescriptionDidChangeNotification 通知里设置，否则 metadataOutputRectOfInterestForRect: 转换方法会返回 (0, 0, 0, 0)。
    
    __weak __typeof(self)weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock: ^(NSNotification *_Nonnull note) {
        weakSelf.metadataOutput.rectOfInterest = [weakSelf.previewLayer metadataOutputRectOfInterestForRect:self.scanView.frame];
    }];
    
    // 开始扫描
    [self.session startRunning];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //如果是第二次进来 那么动画已经执行完毕 要重新开始动画的话 必须让约束归位
    if (self.scanLineTop.constant == self.scanViewHeight.constant - 4) {
        self.scanLineTop.constant -= self.scanViewHeight.constant - 4;
        [self.view layoutIfNeeded];
    }
    
    // 扫描线条动画
    [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        self.scanLineTop.constant = self.scanViewHeight.constant - 4;
        [self.view layoutIfNeeded];
    } completion:NULL];
}

#pragma mark - Custom Accessors

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        
        // 判断是否支持高分辨率
        if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            _session.sessionPreset = AVCaptureSessionPresetHigh;
        }
    }
    return _session;
}

- (AVCaptureDevice *)device {
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)deviceInput {
    if (!_deviceInput) {
        NSError *error = nil;
        _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        if (error) {
            NSLog(@"3.创建输入数据对象错误");
        }
    }
    return _deviceInput;
}

- (AVCaptureMetadataOutput *)metadataOutput {
    if (!_metadataOutput) {
        _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return _metadataOutput;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = self.view.bounds;
    }
    return _previewLayer;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

// !!!: 如果扫描到了二维码 回调该代理方法
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects && metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.lastObject;
        NSString *resultString = metadataObject.stringValue;
        
        NSLog(@"%@",resultString);
        self.result.text = resultString;
        
        [self.session stopRunning];
        [self.scanView removeFromSuperview];
    }
}

#pragma mark - CALayerDelegate

// 蒙版中间一块要空出来
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if (layer == self.maskLayer) {
        UIGraphicsBeginImageContextWithOptions(self.maskLayer.frame.size, NO, 1.0);
        
        // 蒙版新颜色
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0].CGColor);
        CGContextFillRect(ctx, self.maskLayer.frame);
        
        // 转换坐标
        CGRect scanFrame = [self.view convertRect:self.scanView.frame fromView:self.scanView.superview];
        
        // 空出中间一块
        CGContextClearRect(ctx, scanFrame);
    }
}


@end
