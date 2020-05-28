//
//  HQLThirdTableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/26.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLThirdTableViewController.h"

// Controllers
#import "HQLPayResultViewController.h"

// Views
#import "HQLPaymentButtonTableViewCell.h"

// Models
#import "HQLPayResultModel.h"

@interface HQLThirdTableViewController ()

/** 支付类型标记*/
@property (nonatomic, strong) NSMutableArray *flagArray;

@end

@implementation HQLThirdTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏标题&字体颜色
    self.navigationItem.title = @"支付订单";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 注册重用 cell，确认支付按钮
    UINib *nib = [UINib nibWithNibName:@"HQLPaymentButtonTableViewCell"
                                bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"paymentButtonTableViewCell"];
}


#pragma mark - Custom Accessors;

- (NSMutableArray *)flagArray {
    if (!_flagArray) {
        // 初始化：0未选中，1选中
        _flagArray = [[NSMutableArray alloc] initWithObjects:@"0",@"0", nil];
    }
    return _flagArray;
}


#pragma mark - IBAction

// TableViewCell对象附件视图按钮
- (void)buttonPressAction:(UIButton *)button event:(UIEvent *)event {
    NSLog(@"%s",__func__);
    
    // 检查用户点击按钮时的位置，并转发事件到对应的accessory tapped事件
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath) {
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

// 确认支付按钮
- (void)paymentButtonPressAction:(UIButton *)button event:(UIEvent *)event {
    // 弹出警告框，输入密码！
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *passwordTextField = alert.textFields.firstObject;
        NSLog(@"password:%@",passwordTextField.text);
        
        // 模拟跳转到支付成功页面
        HQLPayResultModel *resultModel = [[HQLPayResultModel alloc] initWithPaymentType:HQLPaymentTypeAlipay paymentState:HQLPaymentStateSuccess payAmount:[NSNumber numberWithInt:100]];
        HQLPayResultViewController *vc = [[HQLPayResultViewController alloc] initWithPayResult:resultModel];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)textChange:(UITextField *)textField {
    NSString *password = textField.text;
    NSLog(@"%s, password:%@",__func__, password);
}

#pragma mark - Private

- (void)reloadPaymentTableViewSection:(NSIndexPath *)indexPath {
    // 支付类型被修改
    BOOL isUnSelected = [self.flagArray[indexPath.row] isEqualToString:@"0"];
    if (isUnSelected) {
        // button未被选中，修改为选中
        [self.flagArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        // 其他button也是选中状态，修改为未选中
        if (indexPath.row == 0) {
            [self.flagArray replaceObjectAtIndex:indexPath.row + 1 withObject:@"0"];
        }else {
            [self.flagArray replaceObjectAtIndex:indexPath.row - 1 withObject:@"0"];
        }
    }else {
        [self.flagArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    // 重新加载section
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - UITableViewDataSource

// 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

// 设置每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 2 ) {
        return 2;
    }else if (section == 2) {
        return 2;
    }else {
        return 1;
    }
}

// 设置每行详细显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 注册cell:模型1
    static NSString *tableViewCellStyleValue1 = @"UITableViewCellStyleValue1";
    UITableViewCell *cellStyleValue1 = [tableView dequeueReusableCellWithIdentifier:tableViewCellStyleValue1];
    if (!cellStyleValue1 ) {
        cellStyleValue1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableViewCellStyleValue1];
    }
    
    // 注册cell:模型2
    static NSString *tableViewCellStyleDefault = @"UITableViewCellStyleDefault";
    UITableViewCell *cellStyleDefault = [tableView dequeueReusableCellWithIdentifier:tableViewCellStyleDefault];
    if (!cellStyleDefault) {
        cellStyleDefault = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellStyleDefault];
    }
    
    
    if (indexPath.section == 0) {
        // 第一组：支付订单
        if (indexPath.row == 0) {
            // 第一行：订单详情
            cellStyleValue1.textLabel.text = @"订单详情：";
            cellStyleValue1.detailTextLabel.text = @"预约挂号";
        }else {
            // 第二行：订单金额
            cellStyleValue1.textLabel.text = @"订单金额：";
            cellStyleValue1.detailTextLabel.text = @"¥ 100.88 元";
            cellStyleValue1.detailTextLabel.textColor = [UIColor redColor];
        }
        // 设置 cell 选中样式
        cellStyleValue1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellStyleValue1;
    }else if (indexPath.section == 1) {
        // 第二组：支付金额
        if (indexPath.row == 0) {
            // 第一行：社保支付金额
            cellStyleValue1.textLabel.text = @"社保支付：";
            cellStyleValue1.detailTextLabel.text = @"¥ 50.58 元";
            cellStyleValue1.detailTextLabel.textColor = [UIColor redColor];
        }else {
            // 第二行：个人支付金额
            cellStyleValue1.textLabel.text = @"个人支付：";
            cellStyleValue1.detailTextLabel.text = @"¥ 50.30 元";
            cellStyleValue1.detailTextLabel.textColor = [UIColor redColor];
        }
        // 设置选中颜色：无色
        cellStyleValue1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellStyleValue1;
    }else if (indexPath.section == 2){
        // 第三组：支付方式
        if (indexPath.row == 0) {
            // 第一行：支付宝
            cellStyleDefault.imageView.image = [UIImage imageNamed:@"alipayLogo"];
            cellStyleDefault.textLabel.text = @"支付宝";
        }else {
            // 第二行：微信支付
            cellStyleDefault.imageView.image = [UIImage imageNamed:@"weChatLogo"];
            cellStyleDefault.textLabel.text = @"微信支付";
        }
        // 附件视图
        BOOL isUnSelected = [self.flagArray[indexPath.row] isEqualToString:@"0"];
        NSString *imageName = isUnSelected ? @"list_unselected" :@"list_selected";
        UIImage *image = [UIImage imageNamed:imageName];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        button.frame = frame;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonPressAction:event:) forControlEvents:UIControlEventTouchUpInside];
        cellStyleDefault.accessoryView = button;
        return cellStyleDefault;
    }else {
        HQLPaymentButtonTableViewCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:@"paymentButtonTableViewCell"];
        // 添加button事件
        [paymentCell.paymentButton addTarget:self action:@selector(paymentButtonPressAction:event:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"%lf",self.view.frame.size.height);
        return paymentCell;
    }
}

// 每组头部标题
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"支付订单";
    }else if (section == 1) {
        return @"支付金额";
    }else if (section == 2){
        return @"选择支付方式";
    }else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

// 设置头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 44;
    }else {
        return 22;
    }
}

// 设置底部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

// cell被选中时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 刷新section
    [self reloadPaymentTableViewSection:indexPath];
}

// 附件被触发时调用
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"附件被触发indexPath.row:%ld",indexPath.row);
    // 刷新section
    [self reloadPaymentTableViewSection:indexPath];
}

@end
