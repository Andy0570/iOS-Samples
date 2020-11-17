//
//  HQLPhotoPicker01ViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/12.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLPhotoPicker01ViewController.h"
#import <HXPhotoPicker/HXPhotoPicker.h>

#import "HQLPhotoPicker02ViewController.h"

@interface HQLPhotoPicker01ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *showAlertButton;
@property (nonatomic, strong) HXPhotoManager *manager;

@end

@implementation HQLPhotoPicker01ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 适配深色模式，动态设置背景颜色
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            BOOL isDarkMode = (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
            return isDarkMode ? UIColor.blackColor : UIColor.whiteColor;
        }];
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
}

#pragma mark - Custom Accessors

// 相册管理器
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.type = HXConfigurationTypeWXMoment;
        _manager.configuration.openCamera = YES; // 是否打开相机功能
        _manager.configuration.lookLivePhoto = YES; // 是否开启查看 LivePhoto 功能，默认 NO
        _manager.configuration.photoMaxNum = 9; // 照片最大选择数，默认 9
        _manager.configuration.videoMaxNum = 9; // 视频最大选择数，默认 1
        _manager.configuration.maxNum = 18;     // 最大选择数
        _manager.configuration.videoMaximumSelectDuration = 500.0f; // 视频能选择的最大秒数，默认 3分钟/180秒
        _manager.configuration.saveSystemAblum = YES; // 拍摄的 照片/视频 是否保存到系统相册，默认 NO
        _manager.configuration.showDateSectionHeader = NO; // 是否需要显示日期 section，默认 NO
        _manager.configuration.requestImageAfterFinishingSelection = YES;
        // 设置保存的文件名称
        _manager.configuration.localFileName = @"customFileName"; // 模型数组保存草稿时存在本地的文件名称 default HXPhotoPickerModelArray
    }
    return _manager;
}

#pragma mark - Actions

// MARK: 显示选择媒体源弹窗
- (IBAction)showAlertButtonAction:(id)sender {
    // 1.设置 cell 数据源模型
    HXPhotoBottomViewModel *cameraCellModel = [[HXPhotoBottomViewModel alloc] init];
    cameraCellModel.cellHeight = 62.0f;
    cameraCellModel.title = [NSBundle hx_localizedStringForKey:@"拍摄"];
    cameraCellModel.subTitle = [NSBundle hx_localizedStringForKey:@"照片或视频"];
    
    HXPhotoBottomViewModel *photoCellModel = [[HXPhotoBottomViewModel alloc] init];
    photoCellModel.cellHeight = 56.0f;
    photoCellModel.title = [NSBundle hx_localizedStringForKey:@"从手机相册选择"];
    
    NSArray *cellModels = @[cameraCellModel, photoCellModel];
    
    // 2.弹窗
    __weak __typeof(self)weakSelf = self;
    [HXPhotoBottomSelectView showSelectViewWithModels:cellModels selectCompletion:^(NSInteger index, HXPhotoBottomViewModel * _Nonnull model) {
        [weakSelf selectBottomViewAtIndex:index];
    } cancelClick:nil];
}

// MARK: 保存草稿功能
- (void)saveLocalModelsToFile {
    if (![self.manager saveLocalModelsToFile]) {
        [self.view hx_showImageHUDText:@"保存草稿失败"];
    }
}

#pragma mark - Private

- (void)selectBottomViewAtIndex:(NSInteger)index {
    if (index == 0) {
        // MARK: 1.检查系统相机可用性
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self.view hx_showImageHUDText:@"此设备不支持相机!"];
            return;
        }
        
        // MARK: 2.检查相机访问权限
        __weak __typeof(self)weakSelf = self;
        [self cameraAuthorizationStatusForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                // 打开相机
                [weakSelf presentCustomCameraViewController];
            } else {
                // 引导用户至系统设置
                [weakSelf presentGoSettingAlert];
            }
        }];
    } else {
        // 打开相册
        [self presentSelectPhotoController];
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

// 打开相机
- (void)presentCustomCameraViewController {
    __weak __typeof(self)weakSelf = self;
    [self hx_presentCustomCameraViewControllerWithManager:self.manager done:^(HXPhotoModel *model, HXCustomCameraViewController *viewController) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // 完成之后将拍摄之后的模型添加到已选数组中
        [strongSelf.manager afterListAddCameraTakePicturesModel:model];
        [strongSelf pushNextViewController];
    } cancel:nil];
}

// 打开相册
- (void)presentSelectPhotoController {
    __weak __typeof(self)weakSelf = self;
    [self hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf pushNextViewController];
    } cancel:nil];
}

// 推入下一个视图控制器
- (void)pushNextViewController {
    HQLPhotoPicker02ViewController *vc = [[HQLPhotoPicker02ViewController alloc] init];
    vc.manager = self.manager;
    [self.navigationController pushViewController:vc animated:NO];
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

#pragma mark - Override

// 重写该方法，监控特性集合（traitCollection）属性的变换
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        [self preferredStatusBarUpdateAnimation];
        [self changeStatus];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        // 获取当前的主题外观（UIUserInterfaceStyle）设置：浅色模式/深色模式
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return UIStatusBarStyleLightContent;
        }
    }
    return UIStatusBarStyleDefault;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
- (void)changeStatus {
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        // 获取当前的主题外观（UIUserInterfaceStyle）设置：浅色模式/深色模式
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            return;
        }
    }
#endif
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}
#pragma clang diagnostic pop

@end
