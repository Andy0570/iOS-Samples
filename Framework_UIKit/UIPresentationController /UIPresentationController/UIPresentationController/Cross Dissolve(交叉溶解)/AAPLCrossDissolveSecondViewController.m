//
//  AAPLCrossDissolveSecondViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AAPLCrossDissolveSecondViewController.h"

@interface AAPLCrossDissolveSecondViewController ()

@end

@implementation AAPLCrossDissolveSecondViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Actions

- (IBAction)dismissAction:(id)sender {
    /**
     为了举例说明，该示例完全用代码实现了了呈现动画和消失动画的代码逻辑
     你也可以在之后的示例中查看如何用 segues 的方式实现自定义转换
     */
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
