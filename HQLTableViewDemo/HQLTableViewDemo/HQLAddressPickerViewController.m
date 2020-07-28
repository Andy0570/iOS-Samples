//
//  HQLAddressPickerViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLAddressPickerViewController.h"
#import "AddressPickerView.h"

@interface HQLAddressPickerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *selectCityButton;

@end

@implementation HQLAddressPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)selectCityAction:(id)sender {
    
    AddressPickerView *pickView = [AddressPickerView shareInstance];
    
    __weak __typeof(self)weakSelf = self;
    pickView.block = ^(NSString *province, NSString *city, NSString *district) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSString *currentCity = [NSString stringWithFormat:@"%@%@%@",province, city, district];
        [strongSelf.selectCityButton setTitle:currentCity forState:UIControlStateNormal];
    };
    
    [pickView showAddressPickView];
}

@end
