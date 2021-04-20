//
//  HQLVerticalPresentedViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLVerticalPresentedViewController.h"
//#import <YYKit/YYCGUtilities.h>
#import "HQLVerticalPresentationController.h"

@interface HQLVerticalPresentedViewController ()
@property (nonatomic, assign, readwrite) CGRect frame;
@end

@implementation HQLVerticalPresentedViewController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _frame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = _frame.size;
}

@end
