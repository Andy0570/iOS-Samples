//
//  HQLContainerViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/5/20.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLContainerViewController.h"

// Controllers
#import "HQLChildTableViewController.h"

@interface HQLContainerViewController ()

@end

@implementation HQLContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HQLChildTableViewController *vc = [[HQLChildTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    vc.view.frame = self.view.bounds;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
