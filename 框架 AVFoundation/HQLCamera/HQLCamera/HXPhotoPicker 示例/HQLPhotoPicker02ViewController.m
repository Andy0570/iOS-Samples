//
//  HQLPhotoPicker02ViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLPhotoPicker02ViewController.h"
#import <HXPhotoPicker/HXPhotoPicker.h>

static const CGFloat KPhotoViewMargin = 12.0f;

@interface HQLPhotoPicker02ViewController () <HXPhotoViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation HQLPhotoPicker02ViewController

#pragma mark - View life cycle

- (void)dealloc {
    [self.manager clearSelectedList];
}

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
    
    // 添加滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 添加照片视图
    CGFloat width = scrollView.frame.size.width;
    HXPhotoView *photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(KPhotoViewMargin, KPhotoViewMargin, width - KPhotoViewMargin * 2, 0) manager:self.manager];
    photoView.delegate = self;
    // 是否把相机功能放在外面 默认NO
    photoView.outerCamera = YES;
    // 预览大图时是否显示删除按钮
    photoView.previewShowDeleteButton = YES;
    [scrollView addSubview:photoView];
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

/// 当view高度改变时调用
/// @param frame 位置大小
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + KPhotoViewMargin);
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
