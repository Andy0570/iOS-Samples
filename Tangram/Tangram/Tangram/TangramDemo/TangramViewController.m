//
//  TangramViewController.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "TangramViewController.h"
#import "ColorViewController.h"
#import "MockViewController.h"

@interface TangramViewController ()
@property (nonatomic, copy) NSArray *items;
@end

@implementation TangramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"LazyScroll";
    self.items = @[@"自定义布局-色块(不使用Helper)",@"JSON数据Demo(使用Helper)"];
    
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
            ColorViewController *vc = [[ColorViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            MockViewController *vc = [[MockViewController alloc] init];
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
