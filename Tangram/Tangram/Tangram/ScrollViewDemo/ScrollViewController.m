//
//  ScrollViewController.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "ScrollViewController.h"
#import "ReuseViewController.h"
#import "OuterViewController.h"
#import "MoreViewController.h"
#import "AsyncViewController.h"

@interface ScrollViewController ()
@property (nonatomic, copy) NSArray *items;
@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"LazyScroll";
    self.items = @[@"Reuse",@"OuterScrollView",@"LoadMore",@"Async"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // when selected row of indexPath
    
    switch (indexPath.row) {
        case 0: {
            ReuseViewController *vc = [[ReuseViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            OuterViewController *vc = [[OuterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            MoreViewController *vc = [[MoreViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3: {
            AsyncViewController *vc = [[AsyncViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
    
}

@end
