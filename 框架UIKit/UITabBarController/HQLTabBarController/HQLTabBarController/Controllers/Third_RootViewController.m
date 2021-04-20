//
//  Third_RootViewController.m
//  HQLTabBarController
//
//  Created by Qilin Hu on 2021/3/19.
//

#import "Third_RootViewController.h"

@interface Third_RootViewController ()

@end

@implementation Third_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"third";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Third - %ld",indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *controller = [[UIViewController alloc] init];
    controller.view.backgroundColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
