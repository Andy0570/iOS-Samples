//
//  VirtualViewViewController.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "VirtualViewViewController.h"

@interface VirtualViewViewController ()
@property (nonatomic, copy) NSArray *items;
@end

@implementation VirtualViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"LazyScroll";
    self.items = @[@"1",@"2",@"3",@"4"];
    
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
    
}



@end
