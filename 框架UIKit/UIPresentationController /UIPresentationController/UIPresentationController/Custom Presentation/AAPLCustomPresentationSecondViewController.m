//
//  AAPLCustomPresentationSecondViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AAPLCustomPresentationSecondViewController.h"

@interface AAPLCustomPresentationSecondViewController ()
@property (nonatomic, weak) IBOutlet UISlider *slider;
@end

@implementation AAPLCustomPresentationSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    
    // NOTE: View controllers presented with custom presentation controllers
    //       do not assume control of the status bar appearance by default
    //       (their -preferredStatusBarStyle and -prefersStatusBarHidden
    //       methods are not called).  You can override this behavior by
    //       setting the value of the presented view controller's
    //       modalPresentationCapturesStatusBarAppearance property to YES.
    /* self.modalPresentationCapturesStatusBarAppearance = YES; */
}

//| ----------------------------------------------------------------------------
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    // When the current trait collection changes (e.g. the device rotates),
    // update the preferredContentSize.
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}


//| ----------------------------------------------------------------------------
//! Updates the receiver's preferredContentSize based on the verticalSizeClass
//! of the provided \a traitCollection.
//
- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection
{
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? 270 : 420);
    
    // To demonstrate how a presentation controller can dynamically respond
    // to changes to its presented view controller's preferredContentSize,
    // this view controller exposes a slider.  Dragging this slider updates
    // the preferredContentSize of this view controller in real time.
    //
    // Update the slider with appropriate min/max values and reset the
    // current value to reflect the changed preferredContentSize.
    self.slider.maximumValue = self.preferredContentSize.height;
    self.slider.minimumValue = 220.f;
    self.slider.value = self.slider.maximumValue;
}


- (IBAction)sliderValueChange:(UISlider*)sender
{
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, sender.value);
}

#pragma mark -
#pragma mark Unwind Actions

//| ----------------------------------------------------------------------------
//! Action for unwinding from the presented view controller (C).
// 从所呈现的视图控制器中解开的动作
- (IBAction)unwindToCustomPresentationSecondViewController:(UIStoryboardSegue *)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
