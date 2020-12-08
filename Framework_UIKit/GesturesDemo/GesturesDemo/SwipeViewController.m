//
//  SwipeViewController.m
//  GesturesDemo
//
//  Created by Qilin Hu on 2020/12/8.
//

#import "SwipeViewController.h"

@interface SwipeViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewOrange;
@property (weak, nonatomic) IBOutlet UIView *viewBlack;
@property (weak, nonatomic) IBOutlet UIView *viewGreen;

@end

@implementation SwipeViewController

/**
 Tips
 
 因为视图中添加手势识别器发生在 runtime，而非 compile time，所以每一个手势识别器只能添加到一个视图上。
 如果只创建一个手势识别器，添加到多个视图，手势识别器将不能正常工作。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化滑动手势识别器，滑动方向为右滑，添加到 viewOrange
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightOrange.direction = UISwipeGestureRecognizerDirectionRight; // 手指从左往右滑动
    [self.viewOrange addGestureRecognizer:swipeRightOrange];
    
    // 初始化滑动手势识别器，滑动方向为左滑，添加到 viewOrange
    UISwipeGestureRecognizer *swipeLeftOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftOrange.direction = UISwipeGestureRecognizerDirectionLeft; // 手指从右往左滑动
    [self.viewOrange addGestureRecognizer:swipeLeftOrange];
    
    // viewBlack 添加右滑手势识别器
    UISwipeGestureRecognizer *swipeRightBlack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightBlack.direction = UISwipeGestureRecognizerDirectionRight;
    [self.viewBlack addGestureRecognizer:swipeRightBlack];
    
    // viewGreen 添加左滑手势识别器
    UISwipeGestureRecognizer *swipeLeftGreen = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftGreen.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.viewGreen addGestureRecognizer:swipeLeftGreen];
}

#pragma mark - Actions

// 所有视图向右移动
- (void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    NSLog(@"Swipe Right");
    
    CGFloat width = self.view.frame.size.width;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, width, 0);
        self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, width, 0);
        self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, width, 0);
    }];
}

// 所有视图向左移动
- (void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    NSLog(@"Swipe Left");
    
    CGFloat width = self.view.frame.size.width;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, -width, 0);
        self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, -width, 0);
        self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, -width, 0);
    }];
}

@end
