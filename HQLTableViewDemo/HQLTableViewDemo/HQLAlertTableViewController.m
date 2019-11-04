//
//  HQLAlertTableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2017/1/11.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLAlertTableViewController.h"
#import "JXTAlertController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HQLAlertTableViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation HQLAlertTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Custom Accessors

#pragma mark 1个按钮的 Alert 样式
- (void) createAlertViewControllerWithOneButton {
    //  1.实例化alert
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"标题"
                                message:@"消息"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    //  2.实例化按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * _Nonnull action) {
                                 // 点击按钮，调用此block
                                 NSLog(@"Button Click");
                             }];
    [alert addAction:action];
    
    //  3.显示alertController
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 标准的 Alert 样式
- (void) createAlertViewController {
    //  1.实例化UIAlertController对象
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"标准的Alert 样式"
                                message:@"UIAlertControllerStyleAlert"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    //  2.1实例化UIAlertAction按钮:取消按钮
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       // 点击取消按钮，调用此block
                                       NSLog(@"取消按钮被按下！");
                                   }];
    [alert addAction:cancelAction];
    
    //  2.2实例化UIAlertAction按钮:确定按钮
    UIAlertAction *defaultAction = [UIAlertAction
                             actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * _Nonnull action) {
                                 // 点击按钮，调用此block
                                 NSLog(@"确定按钮被按下");
                             }];
    [alert addAction:defaultAction];
    
    //  3.显示alertController
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 带有多个按钮的 Alert 样式
- (void) createAlertViewControllerWithThreeButtonAction {
    //  1.实例化UIAlertController对象
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"多个按钮的Alert 样式"
                                message:@"有1个或者2个操作按钮的时候，按钮会水平排布。更多按钮的情况，就会像action sheet那样展示："
                                preferredStyle:UIAlertControllerStyleAlert];
    
    //  2.1实例化UIAlertAction按钮:确定按钮
    UIAlertAction *defaultAction = [UIAlertAction
                                    actionWithTitle:@"确定"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * _Nonnull action) {
                                        // 点击按钮，调用此block
                                        NSLog(@"确定按钮被按下");
                                    }];
    [alert addAction:defaultAction];
    
    //  2.2实例化UIAlertAction按钮:更多按钮
    UIAlertAction *moreAction = [UIAlertAction
                                 actionWithTitle:@"更多"
                                 style:UIAlertActionStyleDestructive
                                 handler:^(UIAlertAction * _Nonnull action) {
                                     // 点击按钮，调用此block
                                     NSLog(@"更多按钮被按下");
                                 }];
    [alert addAction:moreAction];
    
    //  2.3实例化UIAlertAction按钮:取消按钮
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       // 点击取消按钮，调用此block
                                       NSLog(@"取消按钮被按下！");
                                   }];
    [alert addAction:cancelAction];
    
    //  3.显示alertController
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 标准的 Action Sheet 样式
- (void)creatAlertSheetController {
    // 1.实例化UIAlertController对象
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"标准的Action Sheet样式"
                                message:@"UIAlertControllerStyleActionSheet"
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 2.1实例化UIAlertAction按钮:取消按钮
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       NSLog(@"取消按钮被按下！");
                                   }];
    [alert addAction:cancelAction];
    
    // 2.2实例化UIAlertAction按钮:更多按钮
    UIAlertAction *moreAction = [UIAlertAction
                                 actionWithTitle:@"更多"
                                 style:UIAlertActionStyleDestructive
                                 handler:^(UIAlertAction * _Nonnull action) {
                                     NSLog(@"更多按钮被按下！");
                                }];
    [alert addAction:moreAction];
    
    // 2.3实例化UIAlertAction按钮:确定按钮
    UIAlertAction *confirmAction = [UIAlertAction
                                    actionWithTitle:@"确定"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * _Nonnull action) {
                                        NSLog(@"确定按钮被按下");
                                    }];
    [alert addAction:confirmAction];
    
    //  3.显示alertController
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 带输入框样式
- (void)createAlertControllerWithTextField {
    // 1.实例化UIAlertController对象
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标题" message:@"信息" preferredStyle:UIAlertControllerStyleAlert];
    
    // 2.1添加输入文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"支付密码";
        textField.secureTextEntry = YES;
    }];
    
    // 2.2实例化UIAlertAction按钮:确定按钮
    UIAlertAction *confirmAction = [UIAlertAction
                                    actionWithTitle:@"确定"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * _Nonnull action) {
                                        NSLog(@"确定按钮被按下");
                                        UITextField *passwordTextField = alert.textFields.firstObject;
                                        NSLog(@"读取输入密码：%@",passwordTextField.text);
                                    }];
    [alert addAction:confirmAction];
    
    //  3.显示alertController
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - JXAlertViewController

// 一个按钮的Alert样式
- (void)createJXAlertViewControllerWithOneButton {
    
//    [self hql_showAlertWithTitle:@"Title" message:@"Message"];
//    - (void) hql_showAlertWithTitle:(nullable NSString *)title
//message:(nullable NSString *)message
//    {
//        [self jxt_showAlertWithTitle:title message:message appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
//            alertMaker.addActionDefaultTitle(@"确定");
//        } actionsBlock:NULL];
//    }
    
    [self jxt_showAlertWithTitle:@"Title" message:@"message" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionDefaultTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        NSLog(@"button clicked!");
    }];
    
}

// 标准的Alert样式
- (void) createJXAlertViewController {
    
    [self jxt_showAlertWithTitle:@"Title" message:@"message" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionDefaultTitle(@"确定").
        addActionCancelTitle(@"取消");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 0) {
            NSLog(@"buttonIndex = 0");
        }else {
            NSLog(@"buttonIndex = 0");
        }
    }];
    
}

// 多个按钮的Alert样式
- (void) createJXAlertViewControllerWithThreeButtonAction {
    
    [self jxt_showAlertWithTitle:@"Title" message:@"message" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionDefaultTitle(@"确定").
        addActionCancelTitle(@"取消").
        addActionDestructiveTitle(@"更多");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 0) {
            NSLog(@"buttonIndex = 0");
        }else if (buttonIndex == 1) {
            NSLog(@"buttonIndex = 1");
        }else {
            NSLog(@"buttonIndex = 0");
        }
    }];
    
}

// 标准的 Action Sheet 样式
- (void)creatJXAlertSheetController {
    
    [self jxt_showActionSheetWithTitle:@"Title" message:@"message" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionDefaultTitle(@"defaultTitle").
        addActionCancelTitle(@"cancelTitle").
        addActionDestructiveTitle(@"destructiveTitle");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 0) {
            NSLog(@"buttonIndex = 0");
        }else if (buttonIndex == 1) {
            NSLog(@"buttonIndex = 1");
        }else {
            NSLog(@"buttonIndex = 0");
        }
    }];
    
}

// 输入框样式
- (void)createJXAlertControllerWithTextField {
    
    [self jxt_showAlertWithTitle:@"Title" message:@"message" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionDefaultTitle(@"OK").
        addActionCancelTitle(@"cancel");
        [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入密码";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 0) {
            UITextField *textField = alertSelf.textFields.lastObject;
            NSLog(@"password:%@",textField.text);
        }
    }];
    
}

// 自动消失样式
- (void)createJXAlertControllerWithToastStyle {
    [self jxt_showActionSheetWithTitle:@"ToastStyle" message:@"default 1s" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.toastStyleDuration = 2.0;
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Alert 样式";
    }else if (section == 1) {
        return @"Alert Sheet 样式";
    }else if (section == 2) {
        return @"输入框样式";
    }else if (section == 3) {
        return @"JXAlertController";
    }else {
        return @"播放系统声音、提醒声音和振动设备";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 1;
    }else if (section == 3) {
        return 6;
    }else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableViewCellStyleDefault = @"UITableViewCellStyleDefault";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellStyleDefault];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellStyleDefault];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"1个按钮的 Alert 样式";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"标准的 Alert 样式";
        }else {
            cell.textLabel.text = @"带有多个按钮的 Alert 样式";
        }
    }else if (indexPath.section == 1) {
            cell.textLabel.text = @"标准的 Action Sheet 样式";
    }else if (indexPath.section == 2) {
            cell.textLabel.text = @"输入框样式";
    }else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"1个按钮的 Alert 样式";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"标准的 Alert 样式";
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"带有多个按钮的 Alert 样式";
        }else if (indexPath.row == 3) {
            cell.textLabel.text = @"标准的 Action Sheet 样式";
        }else if (indexPath.row == 4) {
            cell.textLabel.text = @"输入框样式";
        }else {
            cell.textLabel.text = @"自动消失样式";
        }
        
    }else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"播放系统声音";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"播放提醒声音";
        }else {
            cell.textLabel.text = @"执行震动";
        }
    }
    return cell;
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 一个按钮的 Alert 样式
            [self createAlertViewControllerWithOneButton];
        }else if (indexPath.row == 1) {
            // 标准的 Alert 样式
            [self createAlertViewController];
        }else {
            // 带有多个按钮的 Alert 样式
            [self createAlertViewControllerWithThreeButtonAction];
        }
    }else if (indexPath.section == 1) {
            // 标准的 Action Sheet 样式
            [self creatAlertSheetController];
    }else if (indexPath.section == 2) {
            // 带输入框样式
            [self createAlertControllerWithTextField];
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [self createJXAlertViewControllerWithOneButton];
        }else if (indexPath.row == 1) {
            [self createJXAlertViewController];
        }else if (indexPath.row == 2) {
            [self createAlertViewControllerWithThreeButtonAction];
        }else if (indexPath.row == 3) {
            [self creatJXAlertSheetController];
        }else if (indexPath.row == 4) {
            [self createJXAlertControllerWithTextField];
        }else {
            [self createJXAlertControllerWithToastStyle];
        }
    }else {
        if (indexPath.row == 0) {
            // 播放系统声音
            AudioServicesPlaySystemSound(1005);
        }else if (indexPath.row == 1) {
            // 播放提醒声音
            AudioServicesPlayAlertSound(1006);
        }else {
            // 执行震动
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}
@end
