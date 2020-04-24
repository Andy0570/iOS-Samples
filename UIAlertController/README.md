> UIAlertController 同时替代了 UIAlertView 和 UIActionSheet，从系统层级上统一了 alert 的概念 —— 即以 modal 方式或 popover 方式展示。

>UIAlertController 是 UIViewController 的子类，而非其先前的方式。因此新的 alert 可以由 view controller 展示相关的配置中获益很多。

>UIAlertController 不管是要用 alert 还是 action sheet 方式展示，都要以 title 和 message 参数来初始化。Alert 会在当前显示的 view controller 中心以模态形式出现，action sheet 则会在底部滑出。Alert 可以同时有按钮和输入框，action sheet 仅支持按钮。

>新的方式并没有把所有的 alert 按钮配置都放在初始化函数中，而是引入了一个新类 UIAlertAction 的对象，在初始化之后可以进行配置。这种形式的 API 重构让对按钮数量、类型、顺序方便有了更大的控制。同时也弃用了 UIAlertView 和 UIActionSheet 使用的delegate 这种方式，而是采用更简便的完成时回调。
>—— [摘自Mattt Thompson](http://nshipster.cn/uialertcontroller/)

## UIAlertControllerStyle ——Alert 样式

```objectivec
typedef enum UIAlertControllerStyle : NSInteger {
    UIAlertControllerStyleActionSheet = 0, // 从底部向上推出的操作列表
    UIAlertControllerStyleAlert            // 模态显示的警告框
} UIAlertControllerStyle;
```

## UIAlertActionStyle —— 按钮样式
```objectivec
typedef enum UIAlertActionStyle : NSInteger {
    UIAlertActionStyleDefault = 0,
    UIAlertActionStyleCancel,
    UIAlertActionStyleDestructive
} UIAlertActionStyle;
```
1. **UIAlertActionStyleDefault** 
	默认风格样式的动作按钮;
2. **UIAlertActionStyleCancel**
	取消操作并且保持视图内容不变的动作按钮;
3. **UIAlertActionStyleDestructive**
	可能更改或删除数据样式的动作按钮,警示性样式，默认按钮字体为红色，提示用户这样做可能会删除或者改变某些数据.



# UIAlertController 原生代码示例

## 1.1 一个按钮的 Alert 样式

![一个按钮的Alert样式](http://upload-images.jianshu.io/upload_images/2648731-9365af9b8539a424.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 创建方法
```objectivec
// 1.实例化alertController
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标题"
                                                               message:@"消息"
                                                        preferredStyle:UIAlertControllerStyleAlert];

// 2.实例化按钮
UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
                                                   // 点击按钮，调用此block
                                                   NSLog(@"Button Click");
                                               }];
[alert addAction:action];

//  3.显示alertController
[self presentViewController:alert animated:YES completion:nil];
```
## 1.2 标准的 Alert 样式
![](http://upload-images.jianshu.io/upload_images/2648731-37369a5a1c4637a4.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
### 创建方法
```objectivec
//  1.实例化UIAlertController对象
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标准的Alert 样式"
                                                               message:@"UIAlertControllerStyleAlert"
                                                        preferredStyle:UIAlertControllerStyleAlert];

//  2.1实例化UIAlertAction按钮:取消按钮
UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // 点击取消按钮，调用此block
                                                         NSLog(@"取消按钮被按下！");
                                                     }];
[alert addAction:cancelAction];

//  2.2实例化UIAlertAction按钮:确定按钮
UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          // 点击按钮，调用此block
                                                          NSLog(@"确定按钮被按下");
                                                      }];
[alert addAction:defaultAction];

//  3.显示alertController
[self presentViewController:alert animated:YES completion:nil];
```
## 1.3 带有多个按钮的 Alert 样式
![](http://upload-images.jianshu.io/upload_images/2648731-11a63e2058244842.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
### 创建方法
```objectivec
//  1.实例化UIAlertController对象
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"多个按钮的Alert 样式"
                                                               message:@"有1个或者2个操作按钮的时候，按钮会水平排布。更多按钮的情况，就会像action sheet那样展示："
                                                        preferredStyle:UIAlertControllerStyleAlert];

//  2.1实例化UIAlertAction按钮:确定按钮
UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          // 点击按钮，调用此block
                                                          NSLog(@"确定按钮被按下");
                                                      }];
[alert addAction:defaultAction];

//  2.2实例化UIAlertAction按钮:更多按钮
UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"更多"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       // 点击按钮，调用此block
                                                       NSLog(@"更多按钮被按下");
                                                   }];
[alert addAction:moreAction];

//  2.3实例化UIAlertAction按钮:取消按钮
UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // 点击取消按钮，调用此block
                                                         NSLog(@"取消按钮被按下！");
                                                     }];
[alert addAction:cancelAction];

//  3.显示alertController
[self presentViewController:alert animated:YES completion:nil];
```

## 2. 标准的 Alert Sheet 样式
![](http://upload-images.jianshu.io/upload_images/2648731-f39b4609119063b8.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
### 创建方法
```objectivec
// 1.实例化UIAlertController对象
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标准的Action Sheet样式"
                                                               message:@"UIAlertControllerStyleActionSheet"
                                                        preferredStyle:UIAlertControllerStyleActionSheet];

// 2.1实例化UIAlertAction按钮:取消按钮
UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         NSLog(@"取消按钮被按下！");
                                                     }];
[alert addAction:cancelAction];

// 2.2实例化UIAlertAction按钮:更多按钮
UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"更多"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       NSLog(@"更多按钮被按下！");
                                                   }];
[alert addAction:moreAction];

// 2.3实例化UIAlertAction按钮:确定按钮
UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          NSLog(@"确定按钮被按下");
                                                      }];
[alert addAction:confirmAction];

//  3.显示alertController
[self presentViewController:alert animated:YES completion:nil];
```

## 3.带输入框样式
![](http://upload-images.jianshu.io/upload_images/2648731-43c00a697f332898.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
### 创建方法
```objectivec
// 1.实例化UIAlertController对象
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标题"
                                                               message:@"信息"
                                                        preferredStyle:UIAlertControllerStyleAlert];

// 2.1添加输入文本框
[alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.placeholder = @"支付密码";
    textField.secureTextEntry = YES;
}];

// 2.2实例化UIAlertAction按钮:确定按钮
UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          NSLog(@"确定按钮被按下");
                                                          UITextField *passwordTextField = alert.textFields.firstObject;
                                                          NSLog(@"读取输入密码：%@",passwordTextField.text);
                                }];
[alert addAction:confirmAction];

//  3.显示alertController
[self presentViewController:alert animated:YES completion:nil];
```



# 第三方框架示例：

## [ryanmaxwell/**UIAlertController-Blocks**](https://github.com/ryanmaxwell/UIAlertController-Blocks)
 **UIAlertController+Blocks** 对 **UIAlertViewController** 进行了封装，支持用 Blocks 方式封装的便捷扩展类，调用更简单。

```objectivec
// 通用创建方法
+ (nonnull instancetype)showInViewController:(nonnull UIViewController *)viewController
                                   withTitle:(nullable NSString *)title
                                     message:(nullable NSString *)message
                              preferredStyle:(UIAlertControllerStyle)preferredStyle
                           cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                      destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                           otherButtonTitles:(nullable NSArray *)otherButtonTitles
#if TARGET_OS_iOS
          popoverPresentationControllerBlock:(nullable UIAlertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
#endif
                                    tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;

// 指明创建 UIAlertControllerStyleAlert 样式的弹窗：
+ (nonnull instancetype)showAlertInViewController:(nonnull UIViewController *)viewController
                                        withTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                         tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;

// 指明创建 UIAlertControllerStyleActionSheet 样式的弹窗：
+ (nonnull instancetype)showActionSheetInViewController:(nonnull UIViewController *)viewController
                                              withTitle:(nullable NSString *)title
                                                message:(nullable NSString *)message
                                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                      otherButtonTitles:(nullable NSArray *)otherButtonTitles
#if TARGET_OS_iOS
                     popoverPresentationControllerBlock:(nullable UIAlertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
#endif
                                               tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;
```
### 1. 一个按钮的 Alert
```objectivec
[UIAlertController showAlertInViewController:self
                                           withTitle:@"无法访问位置信息"
                                             message:@"请去设置-隐私-定位服务中开启该功能"
                                   cancelButtonTitle:@"知道了"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:nil
                                            tapBlock:nil];
```
### 2. 多个按钮的 Alert
```objectivec
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
```

### 3. Action Sheet 样式

```objectivec
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
```

💡💡💡 Tips：如果不需要某个按钮，就给按钮的Title 传 `nil`。



ButtonIndex 按钮索引的判断：

```objectivec
static NSInteger const UIAlertControllerBlocksCancelButtonIndex = 0; // 取消、返回按钮
static NSInteger const UIAlertControllerBlocksDestructiveButtonIndex = 1; // 更改、删除按钮
static NSInteger const UIAlertControllerBlocksFirstOtherButtonIndex = 2; // 第一个默认按钮
```
![button Index](http://upload-images.jianshu.io/upload_images/2648731-e5c12f04932099b2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/150)




## [kukumaluCN/JXTAlertManager](https://github.com/kukumaluCN/JXTAlertManager)
这个框架支持链式语法：
使用示例：
### 1. Alert
```objectivec
[self jxt_showAlertWithTitle:@"title"
                     message:@"message"
           appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
    alertMaker.
    addActionCancelTitle(@"cancel").
    addActionDestructiveTitle(@"按钮1");
} actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
    if (buttonIndex == 0) {
        NSLog(@"cancel");
    }
    else if (buttonIndex == 1) {
        NSLog(@"按钮1");
    }
}];
```
### 2.AlertSheet
```objectivec
[self jxt_showAlertWithTitle:@"title"
                     message:@"message"
           appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
    alertMaker.
    addActionDestructiveTitle(@"获取输入框1").
    addActionDestructiveTitle(@"获取输入框2");
    
    [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入框1-请输入";
    }];
    [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入框2-请输入";
    }];
} actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
    if (buttonIndex == 0) {
        UITextField *textField = alertSelf.textFields.firstObject;
        [self logMsg:textField.text];//不用担心循环引用
    }
    else if (buttonIndex == 1) {
        UITextField *textField = alertSelf.textFields.lastObject;
        [self logMsg:textField.text];
    }
}];
```



# 播放系统声音、提醒声音和振动设备

```objectivec
// 导入框架
#import <AudioToolbox/AudioToolbox.h>
```
## 播放系统声音
```objectivec
AudioServicesPlaySystemSound(1005);
```

## 播放提醒声音	
```objectivec
AudioServicesPlayAlertSound(1006);
```

## 执行震动
```objectivec
AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
```



# 其它开源框架

* [dogo/SCLAlertView](https://github.com/dogo/SCLAlertView) ⭐️3000
* [GitHub:adad184/MMPopupView](https://github.com/adad184/MMPopupView) ⭐️1800
* [GitHub:mtonio91/AMSmoothAlert](https://github.com/mtonio91/AMSmoothAlert) ⭐️1300
* [GitHub:12207480/TYAlertController](https://github.com/12207480/TYAlertController) ⭐️1000



# 参考

* [UIAlertController @Mattt Thompson撰写、 Croath Liu翻译](http://nshipster.cn/uialertcontroller/)-**Swift**
* [iOS开发笔记：提示框（UIAlertController）学习](http://www.jianshu.com/p/c4018f4fef0b)
* [ iOS 8 新特性初学：UIAlertController @关东糖](http://blog.csdn.net/bht890811/article/details/40952439)
* [iOS 更加优雅便捷的UIAlertView/UIAlertController封装使用 @霖溦](http://www.jianshu.com/p/ae336594daf0)
* [模仿支付宝支付密码输入对话框](http://www.jianshu.com/p/d11453dbd980)