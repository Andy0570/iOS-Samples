//
//  HQLPhotoPicker03ViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/17.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLPhotoPicker03ViewController.h"
#import <HXPhotoPicker/HXPhotoPicker.h>

static const CGFloat KPhotoViewMargin = 12.0f;

@interface HQLPhotoPicker03ViewController () <HXPhotoViewDelegate>
@property (nonatomic, strong) HXPhotoManager *manager;
@property (nonatomic, strong) HXPhotoView *photoView;
@end

@implementation HQLPhotoPicker03ViewController

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
    
    /// !!!: 获取保存在本地文件的模型数组
    /// @param addData 是否添加到manager的数据中
    [self.manager getLocalModelsInFileWithAddData:YES];
    
    HXPhotoView *photoView = [[HXPhotoView alloc] initWithManager:self.manager];
    // hxNavigationBarHeight: 导航栏 + 状态栏 的高度
    photoView.frame = CGRectMake(KPhotoViewMargin, hxNavigationBarHeight + KPhotoViewMargin, self.view.hx_w - KPhotoViewMargin * 2, 0);
    photoView.showAddCell = YES; // 是否显示添加的cell，默认值为 YES
    photoView.delegate = self;
    [self.view addSubview:photoView];
    self.photoView = photoView;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存草稿" style:UIBarButtonItemStylePlain target:self action:@selector(saveBarButtonAction:)];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteBarButtonAction:)];
    
    self.navigationItem.rightBarButtonItems = @[deleteItem, saveItem];
}

#pragma mark - Custom Accessors

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
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

// 保存草稿
- (void)saveBarButtonAction:(UIBarButtonItem *)sender {
    // afterSelectedArray: 完成之后选择的所有数组
    if (!self.manager.afterSelectedArray.count) {
        [self.view hx_showImageHUDText:@"请先选择资源!"];
        return;
    }
    
    // !!!: 保存草稿
    if (![self.manager saveLocalModelsToFile]) {
        [self.view hx_showImageHUDText:@"保存草稿失败"];
        return;
    }
    
    [self.view hx_showImageHUDText:@"保存草稿成功"];
}

// 删除草稿
- (void)deleteBarButtonAction:(UIBarButtonItem *)sender {
    // !!!: 删除草稿
    if (![self.manager deleteLocalModelsInFile]) {
        [self.view hx_showImageHUDText:@"删除草稿失败"];
        return;
    }
    
    [self.view hx_showImageHUDText:@"删除草稿成功"];
}

#pragma mark - <HXPhotoViewDelegate>

/// 照片/视频发生改变、HXPohotView初始化、manager赋值时调用 - 选择、移动顺序、删除、刷新视图
/// 调用 refreshView 会触发此代理
/// @param allList 所有类型的模型数组
/// @param photos 照片类型的模型数组
/// @param videos 视频类型的模型数组
/// @param isOriginal 是否选择了原图
- (void)photoView:(HXPhotoView *)photoView
   changeComplete:(NSArray<HXPhotoModel *> *)allList
           photos:(NSArray<HXPhotoModel *> *)photos
           videos:(NSArray<HXPhotoModel *> *)videos
         original:(BOOL)isOriginal {
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/// 当view高度改变时调用
/// @param frame 位置大小
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    // 如果 HXPhotoView 是嵌套在容器视图中，则通过该方法更新容器视图高度
    // self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
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
