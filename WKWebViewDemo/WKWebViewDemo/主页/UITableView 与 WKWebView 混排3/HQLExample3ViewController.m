//
//  HQLExample3ViewController.m
//  WKWebViewDemo
//
//  Created by Qilin Hu on 2020/6/14.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLExample3ViewController.h"
#import <YYKit.h>
#import "HQLWebFooterView.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLExample3ViewController ()
@property (nonatomic, strong) HQLWebFooterView *webFooterView;
@end

@implementation HQLExample3ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    self.tableView.tableFooterView = self.webFooterView;
    
    // 注册重用 cell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
}

#pragma mark - Custom Accessors

- (HQLWebFooterView *)webFooterView {
    if (!_webFooterView) {
        _webFooterView = [[HQLWebFooterView alloc] init];
        
        // 读取本地 goods.html 文件
        NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        NSURL *url = [bundleURL URLByAppendingPathComponent:@"1.html"];
        NSString *template = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        _webFooterView.HTMLString = template;
        
        // MARK: 通过 Block 的方式更新 footer view 的高度
        __weak __typeof(self)weakSelf = self;
        _webFooterView.heightUpdateBlock = ^(CGFloat webViewHeight) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;

            // !!!: 给 footer View 的 height 属性赋值使用了 YYKit 框架。
            [strongSelf.tableView beginUpdates];
            strongSelf.tableView.tableFooterView.height = webViewHeight;
            [strongSelf.tableView endUpdates];
        };
    }
    return _webFooterView;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"默认 cell，%lu",indexPath.row];
    return cell;
}




 

@end
