//
//  AAPLCustomPresentationFirstViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AAPLCustomPresentationFirstViewController.h"

#import "AAPLCustomPresentationController.h"
#import "AAPLCustomPresentationSecondViewController.h"

@interface AAPLCustomPresentationFirstViewController ()

@end

@implementation AAPLCustomPresentationFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)buttonAction:(id)sender {
    
    AAPLCustomPresentationSecondViewController *secondViewController = [[AAPLCustomPresentationSecondViewController alloc] init];
    
    // For presentations which will use a custom presentation controller,
    // it is possible for that presentation controller to also be the
    // transitioningDelegate.  This avoids introducing another object
    // or implementing <UIViewControllerTransitioningDelegate> in the
    // source view controller.
    //
    // transitioningDelegate does not hold a strong reference to its
    // destination object.  To prevent presentationController from being
    // released prior to calling -presentViewController:animated:completion:
    // the NS_VALID_UNTIL_END_OF_SCOPE attribute is appended to the declaration.
    AAPLCustomPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    
    presentationController = [[AAPLCustomPresentationController alloc] initWithPresentedViewController:secondViewController presentingViewController:self];
    
    secondViewController.transitioningDelegate = presentationController;
    
    [self presentViewController:secondViewController animated:YES completion:NULL];
}


@end
