//
//  ExamplesListViewController.m
//  POPDemo
//
//  Created by Simon Ng on 19/12/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "ExamplesListViewController.h"

// Controllers
#import "FacebookButtonAnimationViewController.h"
#import "WrongPasswordViewController.h"

// Views
#import "ExampleCell.h"

static NSString * const cellReuseIdentifier = @"ExampleCell";

@interface ExamplesListViewController ()
@property (nonatomic, strong) NSArray *examples;
@end

@implementation ExamplesListViewController


#pragma mark - Controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据源
    self.examples = @[@"Facebook Like & Send", @"Wrong Password", @"Custom VC Transition"];
    [self setupTableView];
}

- (void)setupTableView {
    [self.tableView registerClass:ExampleCell.class
           forCellReuseIdentifier:cellReuseIdentifier];
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.examples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text = self.examples[indexPath.row];
    
    return cell;
}



#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    switch (indexPath.row) {
//        case 0: {
//            FacebookButtonAnimationViewController *vc = [[FacebookButtonAnimationViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 1: {
//            WrongPasswordViewController *vc = [[WrongPasswordViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            break;
//        }
//        case 2: {
//            // openCustomTransition 需要在 Storyboard Segue identifier 中设置
//            [self performSegueWithIdentifier:@"openCustomTransition" sender:self];
//            break;
//        }
//        default:
//            break;
//    }
    
}

@end
