//
//  CustomModalViewController.m
//  POPDemo
//
//  Created by Qilin Hu on 2020/5/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "CustomModalViewController.h"

@interface CustomModalViewController () 

@end

@implementation CustomModalViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - Actions

- (IBAction)didClickOnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
