//
//  MBHudDemoViewController.m
//  HudDemo
//
//  Created by Matej Bukovinski on 30.9.09.
//  Copyright © 2009-2016 Matej Bukovinski. All rights reserved.
//

#import "MBHudDemoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD.h>
#import "MBProgressHUD+HQLCategory.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface MBExample : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) SEL selector;
@end

@implementation MBExample

+ (instancetype)exampleWithTitle:(NSString *)title selector:(SEL)selector {
    MBExample *example = [[self class] new];
    example.title = title;
    example.selector = selector;
    return example;
}

@end

@interface MBHudDemoViewController () <NSURLSessionDelegate>

@property (nonatomic, strong) NSArray<NSArray<MBExample *> *> *examples;
// Atomic, because it may be cancelled from main thread, flag is read on a background thread
@property (atomic, assign) BOOL canceled;

@end

@implementation MBHudDemoViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.examples =
    // 1
    @[@[[MBExample exampleWithTitle:@"不确定模式" selector:@selector(indeterminateExample)],
        [MBExample exampleWithTitle:@"带标签" selector:@selector(labelExample)],
        [MBExample exampleWithTitle:@"带详细标签" selector:@selector(detailsLabelExample)]],
      
      // 2
      @[[MBExample exampleWithTitle:@"确定模式" selector:@selector(determinateExample)],
        [MBExample exampleWithTitle:@"环形确定模式" selector:@selector(annularDeterminateExample)],
        [MBExample exampleWithTitle:@"条形确定模式" selector:@selector(barDeterminateExample)]],
      // 3
      @[[MBExample exampleWithTitle:@"仅显示文本" selector:@selector(textExample)],
        [MBExample exampleWithTitle:@"自定义视图" selector:@selector(customViewExample)],
        [MBExample exampleWithTitle:@"带按钮" selector:@selector(cancelationExample)],
        [MBExample exampleWithTitle:@"切换模式" selector:@selector(modeSwitchingExample)]],
      
      // 4
      @[[MBExample exampleWithTitle:@"显示在窗口" selector:@selector(windowExample)],
        [MBExample exampleWithTitle:@"模拟网络请求" selector:@selector(networkingExample)],
        [MBExample exampleWithTitle:@"带进度条的确定模式" selector:@selector(determinateNSProgressExample)],
        [MBExample exampleWithTitle:@"Dim background" selector:@selector(dimBackgroundExample)],
        [MBExample exampleWithTitle:@"Colored" selector:@selector(colorExample)]],
      
      // 5
      @[[MBExample exampleWithTitle:@"显示成功 HUD，3 秒后自动消失" selector:@selector(showSuccessHUD)],
        [MBExample exampleWithTitle:@"显示失败 HUD，3 秒后自动消失" selector:@selector(showFailHUD)],
        [MBExample exampleWithTitle:@"显示文本标签,3 秒后自动消失" selector:@selector(showLabelHUD)]],
      ];
    
    self.tableView.backgroundColor = UIColor.secondarySystemBackgroundColor;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
}

// MARK: 1.1 不确定模式
- (void)indeterminateExample {
    // 在根视图上显示HUD（ self.view 是一个可滚动的列表视图，因此不适合将 HUD 随着用户划动与内容一起移动）。
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // 激发异步任务，使 UIKit 有机会重新绘制 HUD 添加到视图层次结构。
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

        // Do something useful in the background
        [self doSomeWork];

        // 重要 - 分配回主线程。 始终在主线程上访问 UI 类（包括 MBProgressHUD）。
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

// MARK: 1.2 带标签
- (void)labelExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // 设置文本标签
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

// MARK: 1.3 带详细标签
- (void)detailsLabelExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // Set the label text.
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    // Set the details label text. Let's make it multiline this time.
    hud.detailsLabel.text = NSLocalizedString(@"Parsing data\n(1/1)", @"HUD title");

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

// MARK: 2.1 确定模式
- (void)determinateExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // 一个圆形的饼图，显示进度条
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

// MARK: 2.2 环形确定模式
- (void)annularDeterminateExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

// MARK: 2.3 条形确定模式
- (void)barDeterminateExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // Set the bar determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

// MARK: 3.1 仅显示文本
- (void)textExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(@"Message here!", @"HUD message title");
    hud.label.textColor = [UIColor whiteColor];
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    hud.userInteractionEnabled = NO;
    
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [hud hideAnimated:YES afterDelay:3.f];
}

// MARK: 3.2 自定义视图
- (void)customViewExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = NSLocalizedString(@"Done", @"HUD done title");

    [hud hideAnimated:YES afterDelay:3.f];
}

// MARK: 3.3 带按钮
- (void)cancelationExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");

    // 设置自定义按钮
    [hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title")
                forState:UIControlStateNormal];
    [hud.button addTarget:self
                   action:@selector(cancelWork:)
         forControlEvents:UIControlEventTouchUpInside];

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

- (void)cancelWork:(id)sender {
    self.canceled = YES;
}

// MARK: 3.4 切换模式
- (void)modeSwitchingExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                                              animated:YES];

    // Set some text to show the initial status.
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithMixedProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

// MARK: 4.1 显示在窗口
- (void)windowExample {
    // 覆盖整个屏幕。 类似于使用根视图控制器视图。
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

// MARK: 4.2 模拟网络请求
- (void)networkingExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // Set some text to show the initial status.
    hud.label.text = NSLocalizedString(@"Preparing...", @"HUD preparing title");
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);

    [self doSomeNetworkWorkWithProgress];
}

// MARK: 4.3 带进度的确定模式
- (void)determinateNSProgressExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    // Set up NSProgress
    NSProgress *progressObject = [NSProgress progressWithTotalUnitCount:100];
    hud.progressObject = progressObject;
    
    // Configure a cancel button.
    [hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [hud.button addTarget:progressObject action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgressObject:progressObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

// MARK: 4.4 Dim background

//typedef NS_ENUM(NSInteger, MBProgressHUDBackgroundStyle) {
//    /// 纯色背景
//    MBProgressHUDBackgroundStyleSolidColor,
//    /// UIVisualEffectView 或 UIToolbar.layer 背景视图
//    MBProgressHUDBackgroundStyleBlur
//};

- (void)dimBackgroundExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}

// MARK: 4.5 Colored
- (void)colorExample {
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view
                                              animated:YES];
	hud.contentColor = [UIColor colorWithRed:0.f green:0.6f blue:0.7f alpha:1.f];

	// Set the label text.
	hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");

	dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
		[self doSomeWork];
		dispatch_async(dispatch_get_main_queue(), ^{
			[hud hideAnimated:YES];
		});
	});
}

// !!!: 下面几个是我写的扩展方法
// MARK: 5.1 显示成功 HUD，带 Image 和 Label，3 秒后自动消失
- (void)showSuccessHUD {
    [MBProgressHUD hql_showSuccessHUD:@"提交成功" toView:self.navigationController.view];
}

// MARK: 5.2 显示失败 HUD，带 Image 和 Label，3 秒后自动消失
- (void)showFailHUD {
    [MBProgressHUD hql_showFailureHUD:@"网络请求失败" toView:self.navigationController.view];
}

// MARK: 5.3 显示文本标签,3 秒后自动消失
- (void)showLabelHUD {
    [MBProgressHUD hql_showTextHUD:@"请稍后再试~" toView:self.navigationController.view];
}

#pragma mark - Tasks

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

- (void)doSomeWorkWithProgressObject:(NSProgress *)progressObject {
	// This just increases the progress indicator in a loop.
	while (progressObject.fractionCompleted < 1.0f) {
		if (progressObject.isCancelled) break;
		[progressObject becomeCurrentWithPendingUnitCount:1];
		[progressObject resignCurrent];
		usleep(50000);
	}
}

- (void)doSomeWorkWithProgress {
    self.canceled = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
        if (self.canceled) break;
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [MBProgressHUD HUDForView:self.navigationController.view].progress = progress;
        });
        usleep(50000);
    }
}

- (void)doSomeWorkWithMixedProgress {
    // HUDForView: 找到顶层视图上的 HUD
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    // 不确定模式
    sleep(2);
    // 异步主线程，切换到确定模式
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    });
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
        usleep(50000);
    }
    // 异步主线程，回到不确定模式
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = NSLocalizedString(@"Cleaning up...", @"HUD cleanining up title");
    });
    sleep(2);
    // 同步主线程，自定义视图
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"Completed", @"HUD completed title");
    });
    sleep(2);
}

- (void)doSomeNetworkWorkWithProgress {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURL *URL = [NSURL URLWithString:@"https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1425/sample_iPod.m4v.zip"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL];
    [task resume];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examples.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.examples[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MBExample *example = self.examples[indexPath.section][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = example.title;
    cell.textLabel.textColor = self.view.tintColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [cell.textLabel.textColor colorWithAlphaComponent:0.1f];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MBExample *example = self.examples[indexPath.section][indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:example.selector];
#pragma clang diagnostic pop

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // Do something with the data at location...

    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"Completed", @"HUD completed title");
        [hud hideAnimated:YES afterDelay:3.f];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;

    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.progress = progress;
    });
}

@end
