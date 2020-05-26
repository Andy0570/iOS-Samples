//
//  HQLColorViewController.m
//  Colorboard
//
//  Created by ToninTech on 16/9/13.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLColorViewController.h"

@interface HQLColorViewController ()

@end

@implementation HQLColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction) dismiss:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
