//
//  PanViewController.m
//  GesturesDemo
//
//  Created by Qilin Hu on 2020/12/8.
//

#import "PanViewController.h"

@interface PanViewController ()

@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UILabel *horizontalVelocityLabel;
@property (weak, nonatomic) IBOutlet UILabel *verticalVelocityLabel;

@end

@implementation PanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加平移手势识别器
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
    [self.testView addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - Actions

// 当手指按住视图后，视图随手指在屏幕上移动，最简单的方法是让视图的中心随手势移动
-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    NSLog(@"Pan Gesture");
    
    // locationInView: 返回用户触摸点的 CGPoint 值
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    
//    self.testView.center = touchLocation;
    panGestureRecognizer.view.center = touchLocation;
    
    // 获取移动速度并显示到标签
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    // X 轴速度
    self.horizontalVelocityLabel.text = [NSString stringWithFormat:@"Horizontal Velocity: %.2f points/sec",velocity.x];
    // y 轴速度
    self.verticalVelocityLabel.text = [NSString stringWithFormat:@"Vertical Velocity: %.2f points.sec",velocity.y];
}

@end
