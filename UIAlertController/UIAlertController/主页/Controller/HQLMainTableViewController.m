//
//  HQLMainTableViewController.m
//  UIAlertViewController
//
//  Created by Qilin Hu on 2020/4/21.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMainTableViewController.h"

// Frameworks
#import <AudioToolbox/AudioToolbox.h>
#import <YYKit/NSObject+YYModel.h>
#import "JXTAlertController.h"
#import <UIAlertController+Blocks.h>

// Models
#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

static NSString * const cellReuserIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMainTableViewController ()

@property (nonatomic, strong) NSArray *groupedModelsArray;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;

@end

@implementation HQLMainTableViewController


- (void)dealloc {
    // 1⃣️ 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"UIAlertController";
    [self setupTableView];
    
    // 1⃣️ APP 进入后台后隐藏 Alert 弹窗
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}


#pragma mark - Custom Accessors

// 从 mainTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray *)groupedModelsArray {
    if (!_groupedModelsArray) {
        // mainTableViewTitleModel.plist 文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mainTableViewTitleModel" ofType:@"plist"];
        // 读取 mainTableViewTitleModel.plist 文件，并存放进 jsonArray 数组
        NSArray *jsonArray = [NSArray arrayWithContentsOfFile:path];
        // 将 jsonArray 数组中的 JSON 数据转换成 HQLTableViewCellGroupedModel 模型
        _groupedModelsArray = [NSArray modelArrayWithClass:[HQLTableViewCellGroupedModel class]
                                                      json:jsonArray];
    }
    return _groupedModelsArray;
}


#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLGroupedArrayDataSource alloc] initWithGroupsArray:self.groupedModelsArray cellReuserIdentifier:cellReuserIdentifier configureBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuserIdentifier];
    
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    // 一个按钮的 Alert 样式
                    [self createAlertViewControllerWithOneButton];
                    break;
                }
                case 1: {
                    // 标准的 Alert 样式
                    [self createAlertViewController];
                    break;
                }
                case 2: {
                    // 带有多个按钮的 Alert 样式
                    [self createAlertViewControllerWithThreeButtonAction];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case  1: {
            switch (indexPath.row) {
                case 0: {
                    // 标准的 Action Sheet 样式
                    [self creatAlertSheetController];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    // 带输入框样式
                    [self createAlertControllerWithTextField];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        // UIAlertController+Blocks 框架示例
        case 3: {
            switch (indexPath.row) {
                case 0: {
                    // 一个按钮的 Alert 样式
                    [self createBlockStyleAlertViewWithOneButton];
                    break;
                }
                case 1: {
                    // 多个按钮的 Alert 样式
                    [self createBlockStyleAlertViewWithMoreButton];
                    break;
                }
                case 2: {
                    // Action sheet 样式
                    [self createBlockStyleActionSheet];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        // JXAlertViewController
        case 4: {
            switch (indexPath.row) {
                case 0: {
                    [self createJXAlertViewControllerWithOneButton];
                    break;
                }
                case 1: {
                    // 一个按钮的 Alert 样式，便捷语法
                    [self createJXAlertViewControllerWithTitleAndMessage];
                    break;
                }
                case 2: {
                    [self createJXAlertViewController];
                    break;
                }
                case 3: {
                    [self createAlertViewControllerWithThreeButtonAction];
                    break;
                }
                case 4: {
                    [self creatJXAlertSheetController];
                    break;
                }
                case 5: {
                    [self createJXAlertControllerWithTextField];
                    break;
                }
                case 6: {
                    [self createJXAlertControllerWithToastStyle];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 5: {
            switch (indexPath.row) {
                case 0: {
                    // 播放系统声音
                    AudioServicesPlaySystemSound(1005);
                    break;
                }
                case 1: {
                    // 播放提醒声音
                    AudioServicesPlayAlertSound(1006);
                    break;
                }
                case 2: {
                    // 执行震动
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark - UIAlertController 原生代码示例

#pragma mark 1个按钮的 Alert 样式
- (void) createAlertViewControllerWithOneButton {
    // 1.实例化alert
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"标题"
                                message:@"消息"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    // 2.实例化按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * _Nonnull action) {
                                 // 点击按钮，调用此block
                                 NSLog(@"Button Click");
                             }];
    [alert addAction:action];
    
    // 3.显示alertController
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
                                message:@"有1个或者2个操作按钮的时候，按钮会水平排布。更多按钮时，就会像action sheet那样垂直展示："
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


#pragma mark - UIAlertController+Blocks 框架示例

/**
 UIAlertController+Blocks 对 UIAlertViewController 进行了封装，
 支持用 Blocks 方式封装的便捷扩展类，调用更简单
 */

#pragma mark 一个按钮的 Alert
- (void)createBlockStyleAlertViewWithOneButton {
    [UIAlertController showAlertInViewController:self
                 withTitle:@"无法访问位置信息"
                   message:@"请去设置-隐私-定位服务中开启该功能"
         cancelButtonTitle:@"知道了"
    destructiveButtonTitle:nil
         otherButtonTitles:nil
                  tapBlock:nil];
}

#pragma mark 多个按钮的 Alert
- (void)createBlockStyleAlertViewWithMoreButton {
    // 通过 Block 的方式封装按钮点击的回调
    UIAlertControllerCompletionBlock tapBlock = ^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                if (buttonIndex == controller.destructiveButtonIndex) {
                    NSLog(@"Delete");
                } else if (buttonIndex == controller.cancelButtonIndex) {
                    NSLog(@"Cancel");
                } else if (buttonIndex >= controller.firstOtherButtonIndex) {
                    NSLog(@"Other %ld", (long)buttonIndex - controller.firstOtherButtonIndex + 1);
                }
            };

    // Alert 样式
    [UIAlertController showAlertInViewController:self
                                           withTitle:@"Test Alert"
                                             message:@"Test Message"
                                   cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:@"Delete"
                                   otherButtonTitles:@[@"First Other", @"Second Other"]
                                            tapBlock:tapBlock];
}

#pragma mark Action Sheet 样式
- (void)createBlockStyleActionSheet {
    // 通过 Block 的方式封装按钮点击的回调
    UIAlertControllerCompletionBlock tapBlock = ^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                if (buttonIndex == controller.destructiveButtonIndex) {
                    NSLog(@"Delete");
                } else if (buttonIndex == controller.cancelButtonIndex) {
                    NSLog(@"Cancel");
                } else if (buttonIndex >= controller.firstOtherButtonIndex) {
                    NSLog(@"Other %ld", (long)buttonIndex - controller.firstOtherButtonIndex + 1);
                }
            };
    
    [UIAlertController showActionSheetInViewController:self
                                             withTitle:@"Test Action Sheet"
                                               message:@"Test Message"
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:@"Destructive"
                                     otherButtonTitles:@[@"First Other", @"Second Other"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        popover.sourceView = self.view;
        // FIXME: 以下支持 iPad 的属性设置待修复，
        popover.sourceRect = self.view.frame;
    } tapBlock:tapBlock];
}


#pragma mark - JXAlertViewController 框架示例

#pragma mark 一个按钮的 Alert 样式
- (void)createJXAlertViewControllerWithOneButton {
        
    [self jxt_showAlertWithTitle:@"Title" message:@"message" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionDefaultTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        NSLog(@"button clicked!");
    }];
}

#pragma mark 一个按钮的 Alert 样式，便捷语法
/**
 为方便日常创建一个按钮的弹窗，我对以上方法再次进行了封装
 
 - (void) hql_showAlertWithTitle:(nullable NSString *)title
message:(nullable NSString *)message
 {
     [self jxt_showAlertWithTitle:title message:message appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
         alertMaker.addActionDefaultTitle(@"确定");
     } actionsBlock:NULL];
 }
 
 */
- (void)createJXAlertViewControllerWithTitleAndMessage {
    // 封装完成后，一条代码即可创建一个按钮的 Alert 样式！
    [self hql_showAlertWithTitle:@"自定义标题" message:@"自定义消息"];
}

#pragma mark 标准的 Alert 样式
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

#pragma mark 多个按钮的 Alert 样式
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

#pragma mark 标准的 Action Sheet 样式
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

#pragma mark 输入框样式
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

#pragma mark 自动消失样式
- (void)createJXAlertControllerWithToastStyle {
    [self jxt_showActionSheetWithTitle:@"ToastStyle" message:@"default 1s" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.toastStyleDuration = 2.0;
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
    }];
}

@end
