//
//  Example2ViewController.m
//  GCDExample
//
//  Created by Qilin Hu on 2021/3/17.
//

#import "Example2ViewController.h"

@interface Example2ViewController ()
@property (nonatomic, copy) NSArray *items;
@end

@implementation Example2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开源框架示例";
    self.items = @[@"1",@"2"];
    
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
    switch (indexPath.row) {
        case 0: {
            UIViewController *vc = [[UIViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            UIViewController *vc = [[UIViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            
            break;
        }
        case 3: {
            
            break;
        }
        default:
            break;
    }
    
}


@end
