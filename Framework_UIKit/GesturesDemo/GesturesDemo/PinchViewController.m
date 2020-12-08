//
//  PinchViewController.m
//  GesturesDemo
//
//  Created by Qilin Hu on 2020/12/8.
//

#import "PinchViewController.h"

@interface PinchViewController ()

@property (weak, nonatomic) IBOutlet UIView *testView;

@end

@implementation PinchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加捏合手势识别器
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchWithGestureRecognizer:)];
    [self.testView addGestureRecognizer:pinchGestureRecognizer];
}

#pragma mark - Actions

// 通过改变 scale 来改变 testView 的变换（transform），这样会产生放大或缩小效果。
- (void)handlePinchWithGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    NSLog(@"Pinch Gesture");
    
    CGFloat scale = pinchGestureRecognizer.scale;
    pinchGestureRecognizer.view.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, scale, scale);
    pinchGestureRecognizer.scale = 1.0;     // 重设scale
}

@end
