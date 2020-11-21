//
//  CustomDatePickerViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "CustomDatePickerViewController.h"

@interface CustomDatePickerViewController ()

@end

@implementation CustomDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)closeButtonDidClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
