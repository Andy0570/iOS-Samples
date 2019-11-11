//
//  ViewController.m
//  ReadMeLoginDemo
//
//  Created by Qilin Hu on 2018/1/18.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "ViewController.h"
#import "RMIOLoginView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RMIOLoginView *loginView = [[RMIOLoginView alloc] initWithLoginButtonClickedHandle:^(NSString *username, NSString *password) {
        NSLog(@"username = %@,password = %@",username,password);
    }];
    loginView.frame = self.view.bounds;
    [self.view addSubview:loginView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
