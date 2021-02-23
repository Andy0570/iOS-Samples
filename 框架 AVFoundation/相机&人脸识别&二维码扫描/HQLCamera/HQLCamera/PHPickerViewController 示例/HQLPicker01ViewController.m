//
//  HQLPicker01ViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLPicker01ViewController.h"

// Framework
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
@import MobileCoreServices;

#import <JKCategories/UIView+JKToast.h>

@interface HQLPicker01ViewController () <PHPickerViewControllerDelegate>

@end

@implementation HQLPicker01ViewController {
    UIScrollView *scrollView;
    NSMutableArray <UIImageView *> *imageViews;
    UIButton *selectButton;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageViews = [NSMutableArray array];
    
    // 创建 ScrollView 滚动视图
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    [self.view addSubview:scrollView];
    
    // 选择照片按钮
    selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectButton setTitle:@"选择照片" forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectPressed:) forControlEvents:UIControlEventTouchUpInside];
    [selectButton sizeToFit];
    [self.view addSubview:selectButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    const CGSize size = self.view.bounds.size;
    const UIEdgeInsets safeArea = self.view.safeAreaInsets;
    
    selectButton.frame = ({
        CGRect frame = CGRectZero;
        frame.size.width = MIN(size.width - 20, 250);
        frame.size.height = 40;
        frame.origin.y = size.height - (frame.size.height + 20 + safeArea.bottom);
        frame.origin.x = (size.width - frame.size.width) * 0.5;
        frame;
    });
    
    scrollView.frame = ({
        CGRect frame = CGRectZero;
        frame.origin.y = safeArea.top + 10;
        frame.size.height = (selectButton.frame.origin.y -  20) - frame.origin.y;
        frame.size.width = size.width - 40;
        frame.origin.x = (size.width - frame.size.width) * 0.5;
        frame;
    });
    
    CGFloat y = 10;
    for (NSInteger i = 0; i < imageViews.count; i++) {
        UIImageView *imageView = imageViews[i];
        imageView.frame = ({
            CGRect frame = CGRectZero;
            frame.origin.y = y;
            frame.size.width = MIN(scrollView.bounds.size.width - 20, 300);
            frame.origin.x = (scrollView.bounds.size.width - frame.size.width) * 0.5;
            frame.size.height = MIN(frame.size.width * 0.75, 250);
            y += frame.size.height + 10;
            frame;
        });
    }
}

#pragma mark - Helper

- (UIImageView *)newImageViewFromImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = UIColor.blackColor;
    imageView.image = image;
    return imageView;
}

- (void)clearImageView {
    for (UIImageView *imageView in imageViews) {
        [imageView removeFromSuperview];
    }
    [imageViews removeAllObjects];
}

#pragma mark - PHPicker

-(void)selectPressed:(id)sender {
    if (@available(iOS 14.0, *)) {
        // 1.配置选择最多三张照片
        PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
        config.selectionLimit = 3;
        config.filter = [PHPickerFilter imagesFilter];
        
        // 2.初始化并呈现照片选择器
        PHPickerViewController *pickerViewController = [[PHPickerViewController alloc] initWithConfiguration:config];
        pickerViewController.delegate = self;
        [self presentViewController:pickerViewController animated:YES completion:nil];
    } else {
        [self.view jk_makeToast:@"Photos 框架最低支持 iOS 14"];
    }
}

/// 当用户完成选择或者点击取消按钮来关闭 PHPickerViewController 页面时调用。
/// @discussion 当这个方法被调用时，选取器不会被自动 dismissed。
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results  API_AVAILABLE(ios(14)){
    NSLog(@"-picker:%@ didFinishPicking:%@",picker, results);

    [self clearImageView];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    for (PHPickerResult *result in results) {
        NSLog(@"result: %@", result);
        NSLog(@"所选资产的本地标识符: %@",result.assetIdentifier);
        NSLog(@"所选资产的表现形式: %@",result.itemProvider);
        
        // 获取 UIImage
        [result.itemProvider loadObjectOfClass:UIImage.class completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            NSLog(@"object: %@, error: %@", object, error);
            
            if ([object isKindOfClass:UIImage.class]) {
                // 异步主队列执行
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImageView *imageView = [self newImageViewFromImage:(UIImage *)object];
                    [self->imageViews addObject:imageView];
                    [self->scrollView addSubview:imageView];
                    [self.view setNeedsLayout];
                });
            }
        }];
        
        // 获取文件
//        [result.itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(__kindof id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
//            NSLog(@"%@",item);
//            NSLog(@"%@",[item class]);
//            
//            if ([item isKindOfClass:NSURL.class]) {
//                NSError *error = nil;
//                NSData *data = [NSData dataWithContentsOfURL:item options:0 error:&error];
//                NSLog(@"data: %@",data);
//                NSLog(@"error: %@",error);
//            }
//        }];
    }
}
@end
