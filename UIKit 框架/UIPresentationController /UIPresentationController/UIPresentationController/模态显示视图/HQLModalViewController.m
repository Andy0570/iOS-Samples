//
//  HQLModalViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLModalViewController.h"

@interface HQLModalViewController ()

@end

@implementation HQLModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)backButtonDidClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
