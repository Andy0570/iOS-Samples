//
//  AAPLAdaptivePresentationFirstViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AAPLAdaptivePresentationFirstViewController.h"

@implementation AAPLAdaptivePresentationFirstViewController

#pragma mark -
#pragma mark Unwind Actions

//| ----------------------------------------------------------------------------
//! Action for unwinding from AAPLAdaptivePresentationSecondViewController.
// unwindToAdaptivePresentationFirstViewController
- (IBAction)unwindToAdaptivePresentationFirstViewController:(UIStoryboardSegue *)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
