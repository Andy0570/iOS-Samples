//
//  TLPublishViewController.m
//  TLTabBarControllerDemo
//
//  Created by 李伯坤 on 2017/11/6.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "TLPublishViewController.h"

@interface TLPublishViewController ()

@end

@implementation TLPublishViewController

- (void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationItem setTitle:@"发布"];
    
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonClick)];
    [self.navigationItem setLeftBarButtonItem:closeBarButton];
}

- (void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
