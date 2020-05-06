//
//  HQLDrawViewController.m
//  TouchTracker
//
//  Created by ToninTech on 2016/10/20.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLDrawViewController.h"
#import "HQLDrawView.h"

@interface HQLDrawViewController ()

@end

@implementation HQLDrawViewController


#pragma mark - View life cycle

- (void)loadView {
    self.view = [[HQLDrawView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
