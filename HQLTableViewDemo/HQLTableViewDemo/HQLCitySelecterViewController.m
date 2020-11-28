//
//  HQLCitySelecterViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCitySelecterViewController.h"
#import <YMCitySelect.h>
#import <Toast.h>

@interface HQLCitySelecterViewController () <YMCitySelectDelegate>
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation HQLCitySelecterViewController

#pragma mark - Actions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Actions

- (IBAction)selectCityButtonTapped:(id)sender {
    YMCitySelect *citySelect = [[YMCitySelect alloc] initWithDelegate:self];
    [self presentViewController:citySelect animated:YES completion:nil];
}

#pragma mark - YMCitySelectDelegate

- (void)ym_ymCitySelectCityName:(NSString *)cityName {
    [self.navigationController.view makeToast:cityName];
}

@end
