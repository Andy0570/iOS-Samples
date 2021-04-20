//
//  HQLEmptyDataSetExample2.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/1.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLEmptyDataSetExample2.h"

// Framework
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Chameleon.h>
#import <YYKit.h>

// 分享面板
#import "HQLSharePannelController.h"
#import "HQLVerticalPresentationController.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLEmptyDataSetExample2 () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation HQLEmptyDataSetExample2

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

#pragma mark - Private

- (void)setupTableView {
    
    // DZNEmptyDataSet
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // 注册重用 cell（class 类型）
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    
    // 隐藏列表空白区域的分隔线
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

#pragma mark - <DZNEmptyDataSetSource>

// MARK: 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"placeholder_unlogin"];
}

// MARK: 空白页显示标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"您当前未登录";
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],
        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#25282b"]
    };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

// MARK: 空白页添加按钮，设置按钮文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    // 设置按钮标题
    NSString *buttonTitle = @"点击登录";
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f],
        NSForegroundColorAttributeName: [UIColor flatSkyBlueColor]
    };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

#pragma mark - <DZNEmptyDataSetDelegate>

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // 处理空白页面按钮点击事件
    
    // 1.初始化 HQLPresentationViewController 或其子类实例
    CGRect frame = CGRectMake(0, 0, kScreenWidth, HQLSharePannelControllerHeight);
    HQLSharePannelController *controller = [[HQLSharePannelController alloc] initWithFrame:frame];
    controller.view.backgroundColor = HexColor(@"#F5F5F9");
    
    // 2.初始化 HQLPresentationController 实例
    HQLVerticalPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    
    // 3.设置 UIViewControllerTransitioningDelegate
    presentationController = [[HQLVerticalPresentationController alloc] initWithPresentedViewController:controller presentingViewController:self];
    
    // 4.模态呈现
    controller.transitioningDelegate = presentationController;
    [self presentViewController:controller animated:YES completion:NULL];
}

@end
