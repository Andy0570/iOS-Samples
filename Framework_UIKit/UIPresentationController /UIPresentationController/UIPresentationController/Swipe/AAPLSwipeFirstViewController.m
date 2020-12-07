//
//  AAPLSwipeFirstViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AAPLSwipeFirstViewController.h"
#import "AAPLSwipeTransitionDelegate.h"

@interface AAPLSwipeFirstViewController ()
@property (nonatomic, strong) AAPLSwipeTransitionDelegate *customTransitionDelegate;
@end

@implementation AAPLSwipeFirstViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 这个手势识别器也可以在 storyboard 中定义，但为了清晰起见，还是用代码创建。
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    // !!!: 向右滑动？
    interactiveTransitionRecognizer.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"CustomTransition"])
    {
        UIViewController *destinationViewController = segue.destinationViewController;
        
        // Unlike in the Cross Dissolve demo, we use a separate object as the
        // transition delegate rather then (our)self.  This promotes
        // 'separation of concerns' as AAPLSwipeTransitionDelegate will
        // handle pairing the correct animation controller and interaction
        // controller for the presentation.
        AAPLSwipeTransitionDelegate *transitionDelegate = self.customTransitionDelegate;
        
        // If this will be an interactive presentation, pass the gesture
        // recognizer along to our AAPLSwipeTransitionDelegate instance
        // so it can return the necessary
        // <UIViewControllerInteractiveTransitioning> for the presentation.
        // 如果是由手势识别器触发的转换动画，则设置手势识别器，否则为 nil
        if ([sender isKindOfClass:UIGestureRecognizer.class])
            transitionDelegate.gestureRecognizer = sender;
        else
            transitionDelegate.gestureRecognizer = nil;
        
        // Set the edge of the screen to present the incoming view controller
        // from.  This will match the edge we configured the
        // UIScreenEdgePanGestureRecognizer with previously.
        //
        // NOTE: We can not retrieve the value of our gesture recognizer's
        //       configured edges because prior to iOS 8.3
        //       UIScreenEdgePanGestureRecognizer would always return
        //       UIRectEdgeNone when querying its edges property.
        transitionDelegate.targetEdge = UIRectEdgeRight;
        
        // Note that the view controller does not hold a strong reference to
        // its transitioningDelegate.  If you instantiate a separate object
        // to be the transitioningDelegate, ensure that you hold a strong
        // reference to that object.
        destinationViewController.transitioningDelegate = transitionDelegate;
        
        // Setting the modalPresentationStyle to FullScreen enables the
        // <ContextTransitioning> to provide more accurate initial and final
        // frames of the participating view controllers.
        destinationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
}


#pragma mark - Custom Accessors

- (AAPLSwipeTransitionDelegate *)customTransitionDelegate {
    if (!_customTransitionDelegate)
        _customTransitionDelegate = [[AAPLSwipeTransitionDelegate alloc] init];
    
    return _customTransitionDelegate;
}

#pragma mark - Actions


- (IBAction)interactiveTransitionRecognizerAction:(UIScreenEdgePanGestureRecognizer *)sender
{
    // 该手势识别器只识别 Began 状态，处理 presentation 或者 dismissal 操作
    if (sender.state == UIGestureRecognizerStateBegan)
        // !!!: 由手势识别器触发 Segue 事件，发送者是 UIGestureRecognizer 类或其子类对象
        [self performSegueWithIdentifier:@"CustomTransition" sender:sender];
    
    // 其余的事件都由 AAPLSwipeTransitionInteractionController 处理
}

#pragma mark -
#pragma mark Unwind Actions

//| ----------------------------------------------------------------------------
//! Action for unwinding from AAPLSwipeSecondViewController.
//
- (IBAction)unwindToSwipeFirstViewController:(UIStoryboardSegue *)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
