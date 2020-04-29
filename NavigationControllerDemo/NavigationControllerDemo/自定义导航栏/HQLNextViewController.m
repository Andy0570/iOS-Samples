//
//  HQLNextViewController.m
//  NavigationControllerDemo
//
//  Created by Qilin Hu on 2020/4/27.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLNextViewController.h"

// Frameworks
#import <Chameleon.h>

@interface HQLNextViewController ()

@end

@implementation HQLNextViewController


#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self setThemeUsingPrimaryColor:HexColor(@"#47c0b5")
//                 withSecondaryColor:[UIColor whiteColor]
//                    andContentStyle:UIContentStyleContrast];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor flatMintColorDark];
    self.navigationItem.title = @"我是下一页";
    

    
//    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_light"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBackButtonDidClicked:)];
//    self.navigationItem.backBarButtonItem = backBarButtonItem;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - IBActions

- (void)navigationBackButtonDidClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
