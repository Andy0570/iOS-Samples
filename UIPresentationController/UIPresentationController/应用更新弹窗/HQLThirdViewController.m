//
//  HQLThirdViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLThirdViewController.h"

#import "HQLFullScreenPresentationController.h"
#import "ApplicationUpdateViewController.h"

@interface HQLThirdViewController ()

@end

@implementation HQLThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)presentAppUpdateViewController:(id)sender {
    ApplicationUpdateViewController *updateViewController = [[ApplicationUpdateViewController alloc] init];
    
    HQLFullScreenPresentationController *presentationController = [[HQLFullScreenPresentationController alloc] initWithPresentedViewController:updateViewController presentingViewController:self];
    
    updateViewController.transitioningDelegate = presentationController;
    
    [self presentViewController:updateViewController animated:YES completion:nil];
}

@end
