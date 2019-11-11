//
//  HPMailCompositeTableViewController.m
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/5.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "HPMailCompositeTableViewController.h"

// Views
#import "HPMailCompositeCell.h"

// Utils
#import "HPUtils.h"

static NSString * const cellReusreIdentifier = @"HPMailCompositeCell";

@interface HPMailCompositeTableViewController ()

@end

@implementation HPMailCompositeTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"复合视图（NIB方式）";
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

#pragma mark - Private

- (void)setupTableView {
    // 注册重用复合视图cell
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([HPMailCompositeCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellReusreIdentifier];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    uint64_t nanotime = 0;
    long row = (long)indexPath.row;
    u_int32_t rnd = arc4random();
    NSString *email = [NSString stringWithFormat:@"Email-%ld@domain.com", row];;
    NSString *subject = [NSString stringWithFormat:@"Subject- %ld", row];
    NSString *snippet = [NSString stringWithFormat:@"Content Snippet %ld%d", row, rnd];
    
    __block HPMailCompositeCell *cell = nil;
    nanotime = [HPUtils timeBlock:^{
        cell = (HPMailCompositeCell *)[tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier forIndexPath:indexPath];
        cell.emailLabel.text = email;
        cell.subjectLabel.text = subject;
        cell.snippetLabel.text = snippet;
    }];
    
    NSLog(@"[cell %ld]:Time=%llu ns", row, nanotime);
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

@end

