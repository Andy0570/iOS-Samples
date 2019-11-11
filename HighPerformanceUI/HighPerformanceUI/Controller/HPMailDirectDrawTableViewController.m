//
//  HPMailDirectDrawTableViewController.m
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/5.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "HPMailDirectDrawTableViewController.h"

// Views
#import "HPMailDirectDrawCell.h"

// Utils
#import "HPUtils.h"

static NSString * const cellReusreIdentifier = @"HPMailDirectDrawCell";

@implementation HPMailDirectDrawTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"直接绘制";
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

#pragma mark - Private

- (void)setupTableView {
    // 注册重用cell
    [self.tableView registerClass:[HPMailDirectDrawCell class] forCellReuseIdentifier:cellReusreIdentifier];
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
    
    __block HPMailDirectDrawCell *cell = nil;
    nanotime = [HPUtils timeBlock:^{
        cell = (HPMailDirectDrawCell *)[tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier forIndexPath:indexPath];
        cell.email = email;
        cell.subject = subject;
        cell.snippet = snippet;
        cell.date = @"Yesterday";
        cell.hasAttachment = (rnd % 2) == 0;
        cell.mailStatus = (HPMailDirectDrawCellStatus)(indexPath.row % 3);
    }];
    
    NSLog(@"[cell %ld]:Time=%llu ns", row, nanotime);
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

@end
