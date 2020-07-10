* **GitHub:** [MYDropMenu](https://github.com/coderMyy/MYDropMenu)
* **Star:** 31 



    /*
     
     使用说明 : 
     
     1. 原理 : 菜单的原理是模态视图 , 一个正常的模态效果 , 是将被模态的view放置在一个模态的容器中 , 并通过manager实现动画 . 咱们通过自定义被模态的view的大小和手动使用manager实现自己想要的动画.
     
     2. 如何使用 : 创建一个 UIViewController 子类对象继承于 MYPresentedController ,MYPresentedController即为被模态视图 , MYPresentedController 有 presented , clearBack , callback 3个属性 ，且都为public属性，所以你创建的子类控制器，会拥有这三个属性。
        
        presented : 动画页面是否展开. 你可以随时获取当前的动画是否展开 ， 并可以利用该属性做其他的一些逻辑操作
        clearBack : 透明背景 。 某些情景下，菜单获取会需要黑色半透明的蒙板 ， 而有的情况不需要 ， 你可以通过设置是否需要透明背景，来控制蒙板颜色
        callback  : 当你在菜单中进行一些操作时 ， 你会需要将菜单中的操作回调到当前控制器中 ， 并进行一些逻辑处理，所以你只需要实现callback block ， 即可回调出相应的操作 。 该block有一个参数 ， 且为 id 类型，适用于各种情况。
     
     3 . 如何可以让菜单消失 ： （1）点击蒙板，自动消失  （2）在继承于 MYPresentedController 的菜单控制器中调用 [self dismiss..]方法，也可以手动收回菜单
     
     具体使用请参照  examples 中的具体 demo
     
     最后 ： 因为在不同的项目中 ， 菜单的样式繁多 ， 且大小不一 ，所以没办法写出一个万能且通用的菜单 ， 不过此菜单已经实现了一个整体的模板 ， 你只需根据不同情况，做不同的布局即可。
     
     注意 ： 通常来讲 ， 下拉菜单的导航栏不应被蒙板颜色覆盖，但点击导航栏部分，菜单依旧应该消失，此效果已经实现。
                      而上拉菜单，导航栏部分应该被蒙板颜色所覆盖，此效果也已经实现 。 
     
     如果有更好的建议 ， 欢迎指出 ， 如果觉得有用，请star一下 ，好人一生平安
     */




# MYDropMenu

上下拉菜单，可随意自定义，随意修改大小，位置，2行代码集成

## 1. 上拉下拉菜单 ，位移动画

**创建NormalDropMenu菜单，继承于MYPresentedController ,并自己实现该展示的UI样式**

* **MYPresentedViewShowStyleFromBottomDropStyle  创建从下往上，上拉菜单**

```objective-c
NormalDropMenu *menu = [[NormalDropMenu alloc] initWithShowFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 320, [UIScreen mainScreen].bounds.size.width, 320) ShowStyle:MYPresentedViewShowStyleFromBottomDropStyle callback:^(id callback) {

NSLog(@"-----------------------操作了--%@",callback);
}];
[self presentViewController:menu animated:YES completion:nil];
```


* **MYPresentedViewShowStyleFromTopDropStyle 创建从上往下 ， 下拉菜单**

```objective-c
NormalDropMenu *menu = [[NormalDropMenu alloc] initWithShowFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 320) ShowStyle:MYPresentedViewShowStyleFromTopDropStyle callback:^(id callback) {

NSLog(@"---------------操作了-----%@",callback);
}];
[self presentViewController:menu animated:YES completion:nil];
```
![](https://ws1.sinaimg.cn/large/006tNc79gy1fh5hdzepkdg308e0f3t9m.gif)





## 2. 上拉下拉菜单 ， 展开动画

**创建SpreadDropMenu菜单，继承于MYPresentedController ,并自己实现该展示的UI样式**

* **MYPresentedViewShowStyleFromBottomSpreadStyle 创建从下往上， 上拉菜单**

```objective-c
SpreadDropMenu *menu = [[SpreadDropMenu alloc] initWithShowFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleFromBottomSpreadStyle callback:^(id callback) {

//在此处获取菜单对应的操作 ， 而做出一些处理
NSLog(@"-----------------%@",callback);
}];

//菜单展示
[self presentViewController:menu animated:YES completion:nil];
```


* **MYPresentedViewShowStyleFromTopSpreadStyle 创建从上往下，下拉菜单**

```objective-c
SpreadDropMenu *menu = [[SpreadDropMenu alloc] initWithShowFrame:CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleFromTopSpreadStyle callback:^(id callback) {

//在此处获取菜单对应的操作 ， 而做出一些处理
NSLog(@"-----------------%@",callback);
}];

//菜单展示
[self presentViewController:menu animated:YES completion:nil];
```
![](https://ws3.sinaimg.cn/large/006tNc79gy1fh5hhnfbt4g308e0f3myd.gif)





## 3. 上拉下拉中间展示菜单 ， 弹簧动画

 **创建SpringDropMenu菜单，继承于MYPresentedController ,并自己实现该展示的UI样式**


* **MYPresentedViewShowStyleFromTopSpringStyle 从上往下，下拉弹簧菜单**

```objective-c
SpringDropMenu *menu = [[SpringDropMenu alloc] initWithShowFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleFromTopSpringStyle callback:nil];
[self presentViewController:menu animated:YES completion:nil];
```



* **MYPresentedViewShowStyleFromBottomSpringStyle 从下往上，上拉弹簧菜单**

```objective-c
SpringDropMenu *menu = [[SpringDropMenu alloc] initWithShowFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleFromBottomSpringStyle callback:nil];
[self presentViewController:menu animated:YES completion:nil];
```



* **MYPresentedViewShowStyleFromTopSpringStyle 从上往下，展示在中间菜单（只需要设定最终的frame即可）**

```objective-c
SpringDropMenu *menu = [[SpringDropMenu alloc] initWithShowFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300)*0.5, ([UIScreen mainScreen].bounds.size.height - 300)*0.5, 300, 300) ShowStyle:MYPresentedViewShowStyleFromTopSpringStyle callback:nil];
[self presentViewController:menu animated:YES completion:nil];
```



* **MYPresentedViewShowStyleFromBottomSpringStyle 从下往上，展示在中间菜单（只需要设定最终的frame即可）**

```objective-c
SpringDropMenu *menu = [[SpringDropMenu alloc] initWithShowFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300)*0.5, ([UIScreen mainScreen].bounds.size.height - 300)*0.5, 300, 300) ShowStyle:MYPresentedViewShowStyleFromBottomSpringStyle callback:nil];
[self presentViewController:menu animated:YES completion:nil];
```

![](https://ws2.sinaimg.cn/large/006tNc79gy1fh5hkchpn6g308e0f3n1h.gif)



## 4. 直接展示，小菜单效果

**创建SuddenDropMenu菜单，继承于MYPresentedController ,并自己实现该展示的UI样式**



* **MYPresentedViewShowStyleSuddenStyle 直接展示效果（小菜单，只需修改需要展示的frame即可）**

```objective-c
SuddenDropMenu *menu = [[SuddenDropMenu alloc] initWithShowFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleSuddenStyle callback:nil];
[self presentViewController:menu animated:YES completion:nil];
```

![](https://ws2.sinaimg.cn/large/006tNc79gy1fh5hlau0ikg308e0f33zm.gif)



## 5. 收缩小菜单效果

 **创建SuddenDropMenu菜单，继承于MYPresentedController ,并自己实现该展示的UI样式**
**MYPresentedViewShowStyleShrinkTopLeftStyle/MYPresentedViewShowStyleShrinkTopRightStyle/MYPresentedViewShowStyleShrinkBottomLeftStyle/MYPresentedViewShowStyleShrinkBottomRightStyle 收缩小菜单效果（小菜单，只需设置需要展示的frame即可）**

```objective-c
SuddenDropMenu *menu = [[SuddenDropMenu alloc] initWithShowFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleShrinkTopLeftStyle callback:nil];
[self presentViewController:menu animated:YES completion:nil];
```

![](https://ws2.sinaimg.cn/large/006tNc79gy1fh5hm00ocwg308j0g80ui.gif)








