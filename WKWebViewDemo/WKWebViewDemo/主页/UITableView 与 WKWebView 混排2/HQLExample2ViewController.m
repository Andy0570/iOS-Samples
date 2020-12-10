//
//  HQLExample2ViewController.m
//  WKWebViewDemo
//
//  Created by Qilin Hu on 2020/6/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLExample2ViewController.h"
#import <Masonry.h>
#import "HQLWebViewCell.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";
static NSString * const webViewCellReuseIdentifier = @"HQLWebViewCell";

@interface HQLExample2ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat webViewHeight;
@end

@implementation HQLExample2ViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
}

- (void)addSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Test Color
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:247/255.0 alpha:1.0];
}


#pragma mark - Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
        [_tableView registerClass:[HQLWebViewCell class] forCellReuseIdentifier:webViewCellReuseIdentifier];
    }
    return _tableView;
}

#pragma mark - <UITableViewDataSource>


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 4: {
            // Web Cell
            HQLWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:webViewCellReuseIdentifier forIndexPath:indexPath];
            
            // 读取本地 goods.html 文件
            NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
            NSURL *url = [bundleURL URLByAppendingPathComponent:@"goods.html"];
            NSString *template = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            NSString *formattedString = [template stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            cell.HTMLString = formattedString;
            
            __weak __typeof(self)weakSelf = self;
            cell.webViewCellHeightUpdateBlock = ^(CGFloat webViewHeight) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.webViewHeight = webViewHeight;
                
                // 调用以下方法会调用 cellForRowAtIndexPath: 方法重新加载并刷新 cell，
                // 不断死循环调用造成 cell 抖动
//                [strongSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:4 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                
                // 使用下面一组方法可以在不重新加载单元格的情况下，对行高的变化进行动画处理。
                [strongSelf.tableView beginUpdates];
                [strongSelf.tableView endUpdates];
            };
            return cell;
            break;
        }
        default: {
            // Default Cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"默认 cell，%lu",indexPath.row];
            return cell;
            break;
        }
    }
}


#pragma mark - <UITableViewDelegate>

// 自定义 cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 4:
            return _webViewHeight;
            break;
        default:
            return 50;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // when selected row of indexPath
    
}

@end
