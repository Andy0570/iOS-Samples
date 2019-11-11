//
//  HPMailCompositeHandTableViewController.m
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/6.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "HPMailCompositeHandTableViewController.h"

// View
#import "HPMailCompositeHandCell.h"

// Model
#import "HPMailModel.h"

// Utils
#import "HPUtils.h"

static NSString * const cellReusreIdentifier = @"HPMailCompositeHandCell";

@interface HPMailCompositeHandTableViewController ()

@end

@implementation HPMailCompositeHandTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"复合视图（手写代码）";
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

#pragma mark - Private

- (void)setupTableView {
    [self.tableView registerClass:[HPMailCompositeHandCell class] forCellReuseIdentifier:cellReusreIdentifier];
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
    HPMailModel *model = [[HPMailModel alloc] initWithEmail:email subject:subject date:@"Yesterday" snippet:snippet emailStatus:HPMailModelStatusUnread hasAttachment:YES];
    
    __block HPMailCompositeHandCell *cell = nil;
    nanotime = [HPUtils timeBlock:^{
        cell = (HPMailCompositeHandCell *)[tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier forIndexPath:indexPath];
        cell.model = model;
    }];
    
    NSLog(@"[cell %ld]:Time=%llu ns", row, nanotime);
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

@end
