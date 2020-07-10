//
//  AAPLSwipeSecondViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AAPLSwipeSecondViewController.h"
#import "AAPLSwipeTransitionDelegate.h"

@interface AAPLSwipeSecondViewController ()

@end

@implementation AAPLSwipeSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 这个手势识别器也可以在 storyboard 中定义，但为了清晰起见，还是用代码创建。
    // !!!: 把返回的手势识别操作器链接到转场动画中
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    interactiveTransitionRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
}


//| ----------------------------------------------------------------------------
//! Action method for the interactiveTransitionRecognizer.
//
- (IBAction)interactiveTransitionRecognizerAction:(UIScreenEdgePanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        // "BackToFirstViewController" is the identifier of the unwind segue
        // back to AAPLSwipeFirstViewController.  Triggering it will dismiss
        // this view controller.
        [self performSegueWithIdentifier:@"BackToFirstViewController" sender:sender];
    }
}


//| ----------------------------------------------------------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BackToFirstViewController"])
    {
        // Check if we were presented with our custom transition delegate.
        // If we were, update the configuration of the
        // AAPLSwipeTransitionDelegate with the gesture recognizer and
        // targetEdge for this view controller.
        if ([self.transitioningDelegate isKindOfClass:AAPLSwipeTransitionDelegate.class])
        {
            AAPLSwipeTransitionDelegate *transitionDelegate = self.transitioningDelegate;
            
            // If this will be an interactive presentation, pass the gesture
            // recognizer along to our AAPLSwipeTransitionDelegate instance
            // so it can return the necessary
            // <UIViewControllerInteractiveTransitioning> for the presentation.
            if ([sender isKindOfClass:UIGestureRecognizer.class])
                transitionDelegate.gestureRecognizer = sender;
            else
                transitionDelegate.gestureRecognizer = nil;
            
            // Set the edge of the screen to dismiss this view controller
            // from.  This will match the edge we configured the
            // UIScreenEdgePanGestureRecognizer with previously.
            //
            // NOTE: We can not retrieve the value of our gesture recognizer's
            //       configured edges because prior to iOS 8.3
            //       UIScreenEdgePanGestureRecognizer would always return
            //       UIRectEdgeNone when querying its edges property.
            transitionDelegate.targetEdge = UIRectEdgeLeft;
        }
    }
}

@end
