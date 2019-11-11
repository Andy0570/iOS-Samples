# HQLPasswordViewDemo

之前一篇文章：[密码输入框：CYPasswordView_Block 源码解析](http://www.jianshu.com/p/833a38476c63) 粗略的分析了 **CYPasswordView** 的源码，因为要用到，但是总觉得实现的方式不够优雅，于是我又照着重写了一遍，在大致实现方式基本不变的情况下，优化了些许地方：



### 一、框架结构
---
框架结构基本不变：

![](https://ws1.sinaimg.cn/large/006tNc79gy1fgruj0h0f8j308z0a1abh.jpg)



### 二、HQLPasswordBackgroundView

---

背景视图：

![](https://ws4.sinaimg.cn/large/006tNc79gy1fgrul567oej309q0hbq4v.jpg)

修改或者优化的地方：

* 标题改用 label 标签的形式显示；
* `drawRect:` 方法中只画了背景视图和输入框；
* 重构了重置小圆点的实现方式；



#### 1️⃣ 标题改用 label 标签的形式显示

```objective-c
#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

/** 添加子控件 */
- (void)setupSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.forgetPwdButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置【标题】的坐标
    self.titleLabel.centerX = HQLScreenWidth * 0.5;
    self.titleLabel.centerY = HQLPasswordViewTitleHeight * 0.5;
    
    // 设置【关闭按钮】的坐标
    self.closeButton.width  = HQLPasswordViewCloseButtonWH;
    self.closeButton.height = HQLPasswordViewCloseButtonWH;
    self.closeButton.x = HQLPasswordViewCloseButtonMarginLeft;
    self.closeButton.centerY = HQLPasswordViewTitleHeight * 0.5;
    
    // 设置【忘记密码】按钮的坐标
    self.forgetPwdButton.x = HQLScreenWidth - (HQLScreenWidth - HQLPasswordViewTextFieldWidth) * 0.5 - self.forgetPwdButton.width;
    self.forgetPwdButton.y = HQLPasswordViewTitleHeight + HQLPasswordViewTextFieldMarginTop + HQLPasswordViewTextFieldHeight + HQLPasswordViewForgetPWDButtonMarginTop;
}

```



#### 2️⃣ `drawRect:` 方法中只画了背景视图和输入框；

```objective-c
- (void)drawRect:(CGRect)rect {
    // 画背景视图
    UIImage *backgroundImage =
        [UIImage imageNamed:HQLPasswordViewSrcName(@"password_background")];
    [backgroundImage drawInRect:rect];
    
    // 画输入框
    UIImage *imgTextField =
        [UIImage imageNamed:HQLPasswordViewSrcName(@"password_textfield")];
    [imgTextField drawInRect:[self textFieldRect]];
}
```



#### 3️⃣ 重构了重置小圆点的实现方式；

1. 首先数组中存放的是6个 `dotsImageView` 对象，对应6个不同位置的 ●

```objective-c
- (NSMutableArray *)dotsImgArray {
    if (!_dotsImgArray) {
        _dotsImgArray = [NSMutableArray arrayWithCapacity:KPasswordNumber];
        for (int i = 0; i < KPasswordNumber; i++) {
            
            // textField 的 Rect
            CGFloat textFieldW = HQLPasswordViewTextFieldWidth;
            CGFloat textFieldH = HQLPasswordViewTextFieldHeight;
            CGFloat textFieldX = (HQLScreenWidth - textFieldW) * 0.5;
            CGFloat textFieldY = HQLPasswordViewTitleHeight + HQLPasswordViewTextFieldMarginTop;
           
            // 圆点 的 Rect
            CGFloat pointW = HQLPasswordViewPointnWH;
            CGFloat pointH = HQLPasswordViewPointnWH;
            CGFloat pointY = textFieldY + (textFieldH - pointH) * 0.5;
            // 一个格子的宽度
            CGFloat cellW = textFieldW / KPasswordNumber;
            CGFloat padding = (cellW - pointW) * 0.5;
            // 圆点的 X
            CGFloat pointX = textFieldX + (2 * i + 1) * padding + i * pointW;
            // 添加圆形图片
            UIImage *dotsImage =
                [UIImage imageNamed:HQLPasswordViewSrcName(@"password_point")];
            UIImageView *dotsImageView =
                [[UIImageView alloc] initWithImage:dotsImage];
            dotsImageView.contentMode = UIViewContentModeScaleAspectFit;
            dotsImageView.frame = CGRectMake(pointX, pointY, pointW, pointH);
            // 先全部隐藏
            dotsImageView.hidden = YES;
            
            [self addSubview:dotsImageView];
            [_dotsImgArray addObject:dotsImageView];
        }
    }
    return _dotsImgArray;
}
```

2. 通过传入当前密码的长度 `length`  重置小圆点，比 `length`值大的 `dotsImgArray` 视图设置为显示，比 `length`值小的 `dotsImgArray` 视图设置为隐藏。

```objective-c
// 重置圆点
- (void)resetDotsWithLength:(NSUInteger)length {
    for (int i = 0; i < self.dotsImgArray.count; i++) {
        if (length == 0 || i >= length) {
            ((UIImageView *)[self.dotsImgArray objectAtIndex:i]).hidden = YES;
        }else {
            ((UIImageView *)[self.dotsImgArray objectAtIndex:i]).hidden = NO;
        }
    }
}
```





### HQLPasswordView

密码输入视图：

![](https://ws1.sinaimg.cn/large/006tNc79gy1fgrv0swh5zj309q0hb76b.jpg)



修改或者优化的地方：

* 密码输入框 `pwdTextField` 和画上去的输入框图片一样大，可以响应用户触摸并弹出键盘，而不是 `CGRectMake(0, 0, 1, 1)`  ；
* 之前多出来的单击手势也不浪费，组织又有新任务了：用户如果触摸上方灰色的蒙版视图也是可以关闭密码输入框的。
* 因为修改了小圆点的实现方式，所以 `UITextFieldDelegate` 委托协议实现方式也有改动。



#### 1️⃣ 密码输入框 `pwdTextField` 可以响应用户触摸并弹出键盘

只要把它所有的颜色设置为透明就可以了。

```objective-c
- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.frame = [self.backgroundView textFieldRect];
        _pwdTextField.backgroundColor = [UIColor clearColor];
        _pwdTextField.textColor = [UIColor clearColor];
        _pwdTextField.tintColor = [UIColor clearColor];
        _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        _pwdTextField.delegate = self;
    }
    return _pwdTextField;
}
```



#### 2️⃣ 用户如果触摸上方灰色的蒙版视图可以关闭密码输入框。

```objective-c
/** 
 用户点击事件,触摸灰色蒙版区域，实现关闭操作
 */
- (void)tap:(UITapGestureRecognizer *)recognizer {
    // 获取点击的坐标位置
    CGPoint point = [recognizer locationInView:self];
    // 输入框上方的蒙版区域
    CGRect frame = CGRectMake(0,
                              0,
                              HQLScreenWidth,
                              HQLScreenHeight - HQLPasswordInputViewHeight);
    // 判断点击区域是否包含在蒙版矩形中
    if (CGRectContainsPoint(frame, point)) {
        [self removePasswordView];
    }
}

/** 移除密码输入视图 */
- (void)removePasswordView {
    [self.pwdTextField resignFirstResponder];
    [self removeFromSuperview];
}
```



3️⃣  `UITextFieldDelegate` 委托协议实现方式也有改动:

用协议的方式自动重置密码输入框，而不是手动烧脑判断

每次弹出键盘就重置密码框

1.第一次跟随密码输入视图弹出会调用；

2.提示密码输入错误，再次输入密码会调用；

```objective-c
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    // 每次 TextField 开始编辑，都要重置密码框
    [self clearUpPassword];
}

// 清除密码
- (void)clearUpPassword {
    // 1.清空输入文本框密码
    self.pwdTextField.text = @"";
    // 2.清空黑色圆点
    [self.backgroundView resetDotsWithLength:0];
    // 3.隐藏加载图片和文字
    self.rotationImageView.hidden = YES;
    self.loadingTextLabel.hidden  = YES;
}

// 每当用户操作导致其文本更改时，文本字段将调用此方法。 使用此方法来验证用户键入的文本。 例如，您可以使用此方法来防止用户输入任何数字，但不能输入数值。
// 每当一个字符被键入时，都会首先调用此方法，询问是否应该将输入的字符添加进 TextField 中。
// 因此调用该方法时，正被输入的字符实际上还没有被添加进 TextField 中
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {    
    // 输入进 TextField 的数字个数
    NSUInteger numberLength = textField.text.length + string.length;
    
    if([string isEqualToString:@""]) {
        // 1.判断是不是删除键？
        [self.backgroundView resetDotsWithLength:numberLength - 1];
        return YES;
    } else if(numberLength >= KPasswordNumber) {
        // 2.判断此次输入数字的是不是第6个数字？
        [self.backgroundView resetDotsWithLength:numberLength];
        // 2.1 收起键盘
        [self.pwdTextField resignFirstResponder];
        // 2.2 发起请求 Block
        if (self.finishBlock) {
            [self startLoading];
            NSString *password = [textField.text stringByAppendingString:string];
            self.finishBlock(password);
        }
        return NO;
    } else {
        // 3.每次键入一个值，都要重设黑点
        [self.backgroundView resetDotsWithLength:numberLength];
        return YES;
    }
}
```



4️⃣ 其它的没什么变化，少了几个移除视图的一些重置方法



#### UIView 动画

```objective-c
+ (void)animateWithDuration:(NSTimeInterval)duration 
                      delay:(NSTimeInterval)delay 
                    options:(UIViewAnimationOptions)options 
                  animations:(void (^)(void))animations 
                  completion:(void (^ __nullable)(BOOL finished))completion ;

[UIView animateWithDuration:(NSTimeInterval)          // 动画的持续时间
                      delay:(NSTimeInterval)          // 动画执行的延迟时间
                    options:(UIViewAnimationOptions)  // 执行的动画选项，
                 animations:^{

        // 要执行的动画代码
 } completion:^(BOOL finished) {
        // 动画执行完毕后的调用
}];
```

通过指定动画持续时间、动画延迟、执行动画选项和动画完成后回调的 Block 对象 更改一个或多个视图的动画。



使用示例：

```objective-c
- (IBAction)paymentButtonDidClicked:(id)sender {

    self.passwordView = [[HQLPasswordView alloc] init];
    [self.passwordView showInView:self.view.window];
    self.passwordView.title = @"我是标题";
    self.passwordView.loadingText = @"正在支付中...";
    self.passwordView.closeBlock = ^{
        NSLog(@"取消支付回调...");
    };
    self.passwordView.forgetPasswordBlock = ^{
        NSLog(@"忘记密码回调...");
    };
    WS(weakself);
    self.passwordView.finishBlock = ^(NSString *password) {
        NSLog(@"完成支付回调...");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kRequestTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            flag = !flag;
            if (flag) {
                // 购买成功，跳转到成功页
                [weakself.passwordView requestComplete:YES message:@"购买成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( KDelay* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 从父视图移除密码输入视图
                    [weakself.passwordView removePasswordView];
                });
            } else {
                // 购买失败，跳转到失败页
                [weakself.passwordView requestComplete:NO];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 购买失败的处理，也可以继续支付
                    
                });
            }
        });
    };
}
```



最后，附上
[GitHub地址：HQLPasswordViewDemo](https://github.com/Andy0570/HQLPasswordViewDemo)



### 参考
* [GitHub:chernyog/CYPasswordView](https://github.com/chernyog/CYPasswordView)
* [GitHub:chernyog/CYPasswordView_Block](https://github.com/chernyog/CYPasswordView_Block)
* [iOS开发：仿微信、支付宝6位密码输入框](http://www.jianshu.com/p/7059c017ad0a)
* [手把手教你自动取消textField第一响应的设置](http://www.jianshu.com/p/2aed522aa258)