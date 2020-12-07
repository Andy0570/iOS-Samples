//
//  HQLMainTableViewController.m
//  UIScrollView
//
//  Created by Qilin Hu on 2020/12/7.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMainTableViewController.h"
#import "Example1ViewController.h"
#import "Example2ViewController.h"
#import "Example3ViewController.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMainTableViewController ()
@property (nonatomic, copy) NSArray *items;
@end

@implementation HQLMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    self.tableView.tableFooterView = UIView.new;
    
    self.items = @[@"示例1",@"缩放和捏合手势",@"分页"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            Example1ViewController *vc = [[Example1ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            Example2ViewController *vc = [[Example2ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            Example3ViewController *vc = [[Example3ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
            break;
        }
        default:
            break;
    }
}


@end
