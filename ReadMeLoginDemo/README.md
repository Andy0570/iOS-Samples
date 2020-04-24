# ReadMeLoginDemo

iOS 方式实现 [readme](https://dash.readme.io/login) 登录动画。

![readme.io](http://upload-images.jianshu.io/upload_images/2648731-c9d2d5d59e4db4e7.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 前言

注册、登录功能是应用标识用户身份、记录并保存用户数据、提供个性化服务的重要方法，但是对于用户来说，看到复杂的登录、注册表单就已经让人厌恶至极了，还要去乱成一团的脑海中提取出相应的账号密码，最后还要正确无误地在键盘上一个一个地输入字母。。。是不是要生无可恋到没有脾气了，感觉人生已经走到崩溃悬崖的边缘了呢？ [readme](https://dash.readme.io/login) 在登录和注册中恰到好处地加入了动画，这种人性化的设计让人眼前一亮，如果尝试多点几下触发动画，感觉可以玩一整天啊。

输入 「Email 」时摊开双手，输入「Password」时遮住眼睛在无形中传达了：

1. 用遮眼、睁眼的动画巧妙地表达了：「Email」是明文输入，而「Password」是密文输入；
2. 密码输入的安全性，猫头鹰遮住眼睛好像在提示用户：输入密码时要注意防止他人偷窥以窃取你的账号和密码，如果此时有小伙伴在边上，看到这个动画，他也应该明白：这时候我需要回避一下。
3. 向使用者传达：服务提供方非常注重用户隐私，用户输入的密码服务提供方是不会随意偷看的；
4. 可爱、简洁而有趣的猫头鹰动画减轻并降低了用户输入账号密码时的反感和焦虑，也传达了服务提供方非常具有创意，对产品及其注重人性化体验。

![readme.io.gif](http://upload-images.jianshu.io/upload_images/2648731-7c35eaf3cb260cc3.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




## 动画分解

将猫头鹰动画录屏，并提取出关键帧图片，查看手指的变化：

![分解动画](http://upload-images.jianshu.io/upload_images/2648731-1d298d7ce8446f42.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

说明：

* 两手抓起的图片为【放下时的左右手】
* 遮住眼睛的图片为【抬起时的左右手】


观察分解的图片，从打开双手状态 -> 遮住眼睛状态：

* 【放下时的左右手】初始化时位置分别在猫头鹰头像图片左右两侧，正常大小。动画开始后，向右平移的同时逐渐缩小为0；
* 【抬起时的左右手】初始化时位置在【放下时的左右手】图片的中心点位置，但是大小为 0。动画开始后，向右平移的同时放大至正常大小并遮住眼睛；
* 注意到，双手遮住眼睛后，还有一张【眼睛图片】会覆盖住眼睛白色的部分，

  眼睛图片并不是简单的设置隐藏/显示：`self.owlEyeImgView.hidden = YES;` 来添加的。注意到第四张分解图片，猫头鹰的白色部分是有一点点灰色渐变的，在动画中可以通过设置 `alpha` 值来设置眼睛图片。

遮住眼睛状态->打开双手状态的动画则与上所述相反。



## 准备素材

从 [readme](https://dash.readme.io/login) 登录页面下载图片素材：

Safari 浏览器 - 开发 - 显示页面资源 - 打开图像并下载：

![](http://upload-images.jianshu.io/upload_images/2648731-fe32cca155d5b35d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)



## 核心方法

设置一个枚举类型表示猫头鹰当前的动画状态：

```objective-c
// 猫头鹰动画
typedef NS_ENUM(NSUInteger, RMIOLoginViewOwlAnimationState) {
    RMIOLoginViewOwlAnimationStateDefaule, // 默认初始状态
    RMIOLoginViewOwlAnimationStateDown,    // 睁眼状态（输入用户名时）
    RMIOLoginViewOwlAnimationStateUp,      // 遮眼状态（输入密码时）
};
```



我将抬手动画和打开双手的两个动画分别封装在两个方法中，方便复用：

### 抬起左右手遮眼动画方法

```objective-c
// 抬起左右手动画：打开双手状态 -> 遮住眼睛状态
- (void)armUpImageAnimation {
    
    [UIView animateWithDuration:KOwlAnimationDuration animations:^{
        
        // 眼睛图片 alpha 值从0变为1
        self.owlEyeImgView.alpha = 1;
        
        // 【放下时的左右手】向右平移并缩小到0
        CGRect armDownLeftRect = CGRectMake(_faceRect.origin.x +29, 148, 0, 0);
        self.armDownLeftImgView.frame = armDownLeftRect;
        CGRect armDownRightRect = CGRectMake(CGRectGetMaxX(_faceRect) - 29, 148, 0, 0);
        self.armDownRightImgView.frame = armDownRightRect;
        
        // 抬起时的左右手】向右平移并放大
        CGRect armUpLeftRect = CGRectMake(_faceRect.origin.x - 6, 108, 51, 42);
        self.armUpLeftImgView.frame = armUpLeftRect;
        CGRect armUpRightRect = CGRectMake(_faceRect.origin.x + 60, 107, 51, 43);
        self.armUpRightImgView.frame = armUpRightRect;
    }];
}
```

### 放下左右手睁眼动画方法

```objective-c
// 放下左右手动画：遮住眼睛状态->打开双手状态
- (void)armDownImageAnimation {
    [UIView animateWithDuration:KOwlAnimationDuration animations:^{
        
        // 眼睛图片 alpha 值从1变为0
        self.owlEyeImgView.alpha = 0;
        
        // 【放下时的左右手】向左平移还原
        CGRect armDownLeftRect = CGRectMake(_faceRect.origin.x - 36, 134, 43, 25);
        self.armDownLeftImgView.frame = armDownLeftRect;
        CGRect armDownRightRect = CGRectMake(CGRectGetMaxX(_faceRect), 134, 43, 26);
        self.armDownRightImgView.frame = armDownRightRect;
        
        // 抬起时的左右手】向左平移并缩小到0
        CGRect armUpLeftRect = CGRectMake(_faceRect.origin.x - 15, 150, 0, 0);
        self.armUpLeftImgView.frame = armUpLeftRect;
        CGRect armUpRightRect = CGRectMake(CGRectGetMaxX(_faceRect) + 15, 150, 0, 0);
        self.armUpRightImgView.frame = armUpRightRect;
    }];
}
```



需要实现 `UITextFieldDelegate` 部分协议以调用动画方法：

```objective-c
#pragma mark - UITextFieldDelegate

// 开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 1.开始输入用户名
    if (textField.tag == KUsernameTextFieldTag) {
        switch (self.owlAnimationState) {
            case RMIOLoginViewOwlAnimationStateDefaule: {
                self.owlAnimationState = RMIOLoginViewOwlAnimationStateDown;
                break;
            }
            case RMIOLoginViewOwlAnimationStateDown: {
                break;
            }
            case RMIOLoginViewOwlAnimationStateUp: {
                self.owlAnimationState = RMIOLoginViewOwlAnimationStateDown;
                [self armDownImageAnimation];
                break;
            }
        }
    }
    
    // 2.开始输入密码
    if (textField.tag == KPasswordTextFieldTag) {
        switch (self.owlAnimationState) {
            case RMIOLoginViewOwlAnimationStateDefaule:
            case RMIOLoginViewOwlAnimationStateDown: {
                self.owlAnimationState = RMIOLoginViewOwlAnimationStateUp;
                [self armUpImageAnimation];
                break;
            }
            case RMIOLoginViewOwlAnimationStateUp: {
                break;
            }
        }
    }
}

/*
 结束编辑
 每当密码输入结束编辑时，需要打开双手。
 遮住眼睛->打开双手：
 * 密码输入时，返回到账号输入，打开双手。
 * 密码输入时，点击空白部分或点击登录，打开双手。
 
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == KPasswordTextFieldTag) {
        if (self.owlAnimationState == RMIOLoginViewOwlAnimationStateUp) {
            self.owlAnimationState = RMIOLoginViewOwlAnimationStateDown;
            [self armDownImageAnimation];
        }
    }
}

// 用户点击键盘"Return"按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}
```
看看实现效果如何：

bingo！I Do It！🎉🎉🎉
![iOS 实现效果图.gif](http://upload-images.jianshu.io/upload_images/2648731-5c5d508dbd65c50e.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


放慢10倍速度看看：

![放慢动画.gif](http://upload-images.jianshu.io/upload_images/2648731-7dfa38b266131bbe.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


源码已上传 [GitHub](https://github.com/Andy0570/ReadMeLoginDemo)



### 参考

> 君子性非异也，善假于物也——荀子

 参考了各位大佬的Demo源码，还有各种资料：

* [JxbLovelyLogin](https://github.com/JxbSir/JxbLovelyLogin)
* [萌货猫头鹰登录界面动画iOS实现分析](https://www.jianshu.com/p/2e2426e861d6)
* [iOS形变之CGAffineTransform @蚊香酱](https://www.jianshu.com/p/ca7f9bc62429)
* [iOS 常用组件-高效切圆角方法总结](https://www.jianshu.com/p/f8a3400836b5)
* [WSLoginView](https://github.com/Zws-China/WSLoginView) ⭐️

  > 这个 Demo 可以研究研究，本文的动画逻辑也大都参考这个。但仔细观察你会发现因为它用的图片与视图层次结构冲突的原因，猫头鹰的鼻尖没有办法露出来（左右两边的小手本来也没有露出来），我想了许久，最后使用 Sketch 画了一个鼻子贴在上面。
  >
  > ![WSLoginView
> ](http://upload-images.jianshu.io/upload_images/2648731-a83e3aa24c83eeb1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
  > 画一个鼻子给你：
  > ![owl-mouth@2x.png](http://upload-images.jianshu.io/upload_images/2648731-46943cb151cda0ed.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 关于像素对齐

我在设置猫头鹰图片 Frame 时的方法：

```objective-c
self.faceRect = CGRectMake(CGFloatPixelRound((kScreenWidth - 116) / 2), 69, 116, 92); //第 203 行

// 【原因解析】
// 在 iPhone 7 （尺寸为 375*667）上的值为：(129.5,69,116,92)，因为 Scale = 2，所以实际像素值为（259，138，232，184），像素对齐
// 在 iPhone X (尺寸为 375*812)上的值为(129.666667,69.000000,116.000000,92.000000),因为 Scale = 3 ，所以实际像素值为 （389，207，348，276），像素对齐

//-------------------------
// 如果不使用像素对齐函数，那么
// 在 iPhone 7 上的值为(129.5,69,116,92)，实际像素值为：（259，138，232，184），像素对齐
// 在 iPhone X 上的值为(129.5,69,116,92)，实际像素值为：（388.5，207，348，276），像素没有对齐⚠️

// 【总结】
// 设置 CGRect 值的时候尽量小心，特别是如果你用到了除法（如 KScreenSize / 5），可能会导致最终取出来的值不是整数，
// 就会造成像素不对齐，就会增加 CPU/GPU 的消耗，会影响性能或者说页面不会以 60 FPS 进行渲染，造成页面卡顿。
```

其中有一个 `CGFloatPixelRound()` 函数可以设置像素对齐值（CGFloat），来自于 [YYKit](https://github.com/ibireme/YYKit) 框架的 **YYCGUtilities.h** 类中，里面还有其他像设置像素对齐点（CGPoint）、像素对齐大小（CGSize）、像素对齐矩形（CGRect）等方法：

```objective-c
// 像素对齐值
CGFloatPixelFloor(CGFloat value)
CGFloatPixelRound(CGFloat value)
CGFloatPixelCeil(CGFloat value)
CGFloatPixelHalf(CGFloat value)

// 像素对齐点
CGPointPixelFloor(CGPoint point)
CGPointPixelRound(CGPoint point)
CGPointPixelCeil(CGPoint point)
CGPointPixelHalf(CGPoint point)

// 像素对齐大小
CGSizePixelFloor(CGSize size)
CGSizePixelRound(CGSize size)
CGSizePixelCeil(CGSize size)
CGSizePixelHalf(CGSize size)

// 像素对齐矩形
CGRectPixelFloor(CGRect rect)
CGRectPixelRound(CGRect rect)
CGRectPixelCeil(CGRect rect)
CGRectPixelHalf(CGRect rect)

// 像素对齐边缘插入量
UIEdgeInsetPixelFloor(UIEdgeInsets insets)
UIEdgeInsetPixelCeil(UIEdgeInsets insets)
```

其中底层调用的 Floor()、Round()、Ceil() 分别是数学函数：

* floor()  取不大于传入值的最大整数
* round()  四舍五入
* ceil()   返回大于或者等于指定表达式的最小整数

示例:
>  scale = 2.000000  时：
>
>   "CGFloatPixelCeil(2.1)" = 5;
>   "CGFloatPixelCeil(2.25)" = 5;
>   "CGFloatPixelCeil(2.45)" = 5;
>   "CGFloatPixelFloor(2.1)" = 4;
>   "CGFloatPixelFloor(2.25)" = 4;
>   "CGFloatPixelFloor(2.45)" = 4;
>   "CGFloatPixelHalf(2.1)" = "4.5";
>   "CGFloatPixelHalf(2.25)" = "4.5";
>   "CGFloatPixelHalf(2.45)" = "4.5";
>   "CGFloatPixelRound(2.1)" = 4;
>   "CGFloatPixelRound(2.25)" = 5;
>   "CGFloatPixelRound(2.45)" = 5;



### 最后的话

> 兴趣是最好的老师，写代码可能是一件枯燥的事。看到这个动画的第一眼就是：哇！好酷！如果在 iOS 上实现这个动画应该会很好玩吧！
>
> 所以做这个Demo的时候可以一直盯着电脑研究捣鼓好久，就连吃饭、走路的时候也会想着初始化时各个图片应该放在哪里？如何正确获取及调整图片的位置呢？应该是什么状态的？动画的路径是如何进行的呢？触摸点击事件的逻辑是怎样的呢？所以实现起来一点也不费力，做完还会有满满的成就感。。。
>
> So，愿永远年轻，永远热泪盈眶。

