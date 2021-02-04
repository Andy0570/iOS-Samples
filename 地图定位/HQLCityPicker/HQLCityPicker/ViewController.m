//
//  ViewController.m
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/1/29.
//

#import "ViewController.h"

#import "HQLCityPickerController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择城市" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDidClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)rightBarButtonDidClicked:(UIBarButtonItem *)sender {
    HQLCityPickerController *cityPickerController = [[HQLCityPickerController alloc] initWithStyle:UITableViewStylePlain];
    cityPickerController.completionBlock = ^(NSString * _Nonnull cityCode, NSString * _Nonnull cityName) {
        self.label.text = cityName;
    };
    [self.navigationController pushViewController:cityPickerController animated:YES];
}


@end
