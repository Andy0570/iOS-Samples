//
//  PPNumberButtonViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/6/17.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "PPNumberButtonViewController.h"

// Frameworks
#import <PPNumberButton.h>

@interface PPNumberButtonViewController () <PPNumberButtonDelegate>

@end

@implementation PPNumberButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubViews];
}

- (void)addSubViews {
    CGRect rect = CGRectMake(100, 300, 104, 30);
    PPNumberButton *numberButton = [[PPNumberButton alloc] initWithFrame:rect];
    numberButton.backgroundColor = [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0];
    numberButton.borderColor = [UIColor whiteColor];
    numberButton.increaseTitle = @"＋";
    numberButton.decreaseTitle = @"－";
    numberButton.minValue = 1;
    numberButton.maxValue = 10;
    numberButton.currentNumber = 1;
    numberButton.editing = NO;
    numberButton.delegate = self;
    [self.view addSubview:numberButton];
}

#pragma mark - <PPNumberButtonDelegate>

- (void)pp_numberButton:(PPNumberButton *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus {
    NSLog(@"current value: %lu", number);
}

@end
