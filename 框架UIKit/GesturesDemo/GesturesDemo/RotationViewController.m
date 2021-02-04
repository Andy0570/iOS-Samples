//
//  RotationViewController.m
//  GesturesDemo
//
//  Created by Qilin Hu on 2020/12/8.
//

#import "RotationViewController.h"

@interface RotationViewController ()

@property (weak, nonatomic) IBOutlet UIView *testView;

@end

@implementation RotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加旋转手势识别器
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationWithGestureRecognizer:)];
    [self.testView addGestureRecognizer:rotationGestureRecognizer];
}

#pragma mark - Actions

- (void)handleRotationWithGestureRecognizer:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    NSLog(@"Rotation Gesture");
    
    rotationGestureRecognizer.view.transform = CGAffineTransformRotate(rotationGestureRecognizer.view.transform, rotationGestureRecognizer.rotation);
    rotationGestureRecognizer.rotation = 0.0;
}

@end
