//
//  ShrinkDropController.m
//  MYDropMenu_Example
//
//  Created by 孟遥 on 2017/3/31.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "ShrinkDropController.h"
#import "ShrinkDropMenu.h"

@interface ShrinkDropController ()

@end

@implementation ShrinkDropController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)leftTop:(id)sender {
    
    ShrinkDropMenu *menu = [[ShrinkDropMenu alloc]initWithShowFrame:CGRectMake(15, 64, 80, 120) ShowStyle:MYPresentedViewShowStyleShrinkTopLeftStyle callback:^(id callback) {
        NSLog(@"-----------点击了-------%@",callback);
    }];
    [self presentViewController:menu animated:YES completion:nil];
    
}


- (IBAction)rightTop:(id)sender {
    ShrinkDropMenu *menu = [[ShrinkDropMenu alloc]initWithShowFrame:CGRectMake(self.view.bounds.size.width - 15 - 80, 64, 80, 120) ShowStyle:MYPresentedViewShowStyleShrinkTopRightStyle callback:^(id callback) {
        NSLog(@"-----------点击了-------%@",callback);
    }];
    [self presentViewController:menu animated:YES completion:nil];
}


- (IBAction)leftBottom:(id)sender {
    ShrinkDropMenu *menu = [[ShrinkDropMenu alloc]initWithShowFrame:CGRectMake(15, self.view.bounds.size.height - 120, 80, 120) ShowStyle:MYPresentedViewShowStyleShrinkBottomLeftStyle callback:^(id callback) {
        NSLog(@"-----------点击了-------%@",callback);
    }];
    [self presentViewController:menu animated:YES completion:nil];
}

- (IBAction)rightBottom:(id)sender {
    ShrinkDropMenu *menu = [[ShrinkDropMenu alloc]initWithShowFrame:CGRectMake(self.view.bounds.size.width - 15 - 80, self.view.bounds.size.height - 100, 80, 120) ShowStyle:MYPresentedViewShowStyleShrinkBottomRightStyle callback:^(id callback) {
        NSLog(@"-----------点击了-------%@",callback);
    }];
    [self presentViewController:menu animated:YES completion:nil];
}



@end
