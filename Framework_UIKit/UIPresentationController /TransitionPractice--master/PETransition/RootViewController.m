//
//  RootViewController.m
//  PETransition
//
//  Created by Petry on 16/9/11.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController()
/** 数据 */
@property (nonatomic, copy)NSArray *data;
/** controller数组 */
@property (nonatomic, copy)NSArray *viewControllers;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = HA_HA;
//    self.navigationController.view.layer.cornerRadius = 10;
    self.navigationController.view.layer.masksToBounds = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
}

#pragma mark - ---lazyLoding---
- (NSArray *)data
{
    if (_data == nil) {
        _data = [@[@"神奇移动",@"弹性pop",@"翻页效果",@"小圆点扩散"] copy];
    }
    return _data;
}
- (NSArray *)viewControllers
{
    if (_viewControllers == nil) {
        _viewControllers = @[@"PEMagicMoveController",@"PEElasticController",@"PEPageTurningController",@"PECircleSpreadController"];
    }
    return _viewControllers;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[NSClassFromString(self.viewControllers[indexPath.row]) alloc] init] animated:YES];
}

@end
