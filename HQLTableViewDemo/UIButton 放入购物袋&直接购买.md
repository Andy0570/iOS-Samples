### 显示效果

商品详情页底部，显示两个按钮，放入购物袋、直接购买。其中：

* 放入购物袋按钮显示黄色渐变色背景；
* 直接购买按钮显示红色背景；

两个按钮需要并列展示，并切除圆角。

![](https://tva1.sinaimg.cn/large/008i3skNgy1gveuwn3tgij60v9090jrg02.jpg)



### 实现原理

整个 UI 视图共有三层视图嵌套：

![](https://tva1.sinaimg.cn/large/008i3skNgy1gvev1de8c2j60e8052t9002.jpg)

* 放入购物袋按钮、直接购买按钮是两个仅显示白色文字的 `UIButton`，且这两个按钮的背景颜色为透明色。
* 放入购物袋按钮的父视图是一个黄色渐变背景的矩形 `UIView` 视图。
* 直接购买按钮的父视图是一个红色背景的矩形 `UIView` 视图。
* 两个`UIView` 视图的共同父视图是一个四周切圆角的 `UIView` 视图。

### 实现代码

```objective-c
// 四周切圆角的父容器视图
UIView *backgroundView = [[UIView alloc] init];
backgroundView.layer.cornerRadius = 20;
backgroundView.layer.masksToBounds = YES;
[self addSubview:backgroundView];

[backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self).with.offset(5);
    make.right.mas_equalTo(self.mas_right).with.offset(-8);
    make.size.mas_equalTo(CGSizeMake(214, 40));
}];

// 直接购买背景视图
UIView *buyBackgroundView = [[UIView alloc] init];
buyBackgroundView.backgroundColor = COLOR_CHECKBOX_TINT;
[backgroundView addSubview:buyBackgroundView];
[buyBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.top.and.bottom.equalTo(backgroundView);
    make.width.mas_equalTo(107);
}];

// 放入购物袋背景视图
UIView *cartBackgroundView = [[UIView alloc] init];
// 设置渐变色
NSArray *colors = @[UIColorHex(#FFCF18), UIColorHex(#FF881B)];
UIColor *gradientColor = [UIColor jk_colorWithGradientStyle:UIGradientColorStyleLeftToRight
                                                  withFrame:CGRectMake(0, 0, 107, 40)
                                                  andColors:colors];
cartBackgroundView.backgroundColor = gradientColor;
[backgroundView addSubview:cartBackgroundView];
[cartBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.and.bottom.equalTo(backgroundView);
    make.width.mas_equalTo(107);
}];

// 直接购买按钮
[buyBackgroundView addSubview:self.buyButton];
[self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(buyBackgroundView);
}];

// 放入购物袋按钮
[cartBackgroundView addSubview:self.cartButton];
[self.cartButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(cartBackgroundView);
}];
```

