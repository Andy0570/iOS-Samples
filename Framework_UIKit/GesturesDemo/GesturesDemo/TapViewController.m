//
//  TapViewController.m
//  GesturesDemo
//
//  Created by Qilin Hu on 2020/12/8.
//

#import "TapViewController.h"

@interface TapViewController ()

@property (weak, nonatomic) IBOutlet UIView *testView;

@end

@implementation TapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.1 初始化手势识别器
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    // 1.2 添加手势识别器
    [self.testView addGestureRecognizer:singleTapGestureRecognizer];
    
    // 2.1 初始化双击手势识别器
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    // 2.2 设定需要点击两次才能触发双击手势
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    // 2.3 添加手势识别器
    [self.testView addGestureRecognizer:doubleTapGestureRecognizer];
    
    // 3.单击手势遇到双击手势时，只响应双击手势
    // 设置手势识别优先级，只有当双击手势识别失败时，才识别单击手势
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
}

#pragma mark - Actions

// 在第一次单击 testView 时，把它的宽放大 2 倍；第二次点击时，恢复为原来大小。
- (void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    NSLog(@"Single Tap");
    
    CGFloat newWidth = 150.0;
    if (self.testView.frame.size.width == 150.0) {
        newWidth = 300.0;
    }

    CGPoint currentCenter = self.testView.center;

    self.testView.frame = CGRectMake(self.testView.frame.origin.x, self.testView.frame.origin.y, newWidth, self.testView.frame.size.height);
    self.testView.center = currentCenter;
}

// 第一次双击时，testView 长、宽均变为原来二倍，第二次双击时，恢复原来大小。
- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    NSLog(@"Double Tap");
    
    CGSize newSize = CGSizeMake(150.0, 150.0);
    if (self.testView.frame.size.width == 150.0) {
        newSize.width = 300.0;
        newSize.height = 300.0;
    }
    
    CGPoint currentCenter = self.testView.center;
    self.testView.frame = CGRectMake(self.testView.frame.origin.x, self.testView.frame.origin.y, newSize.width, newSize.height);
    self.testView.center = currentCenter;
}

@end
