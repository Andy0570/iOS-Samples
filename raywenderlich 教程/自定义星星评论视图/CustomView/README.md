# CustomView

参考 [Ray Wenderlich 教程](https://www.raywenderlich.com/1768/uiview-tutorial-for-ios-how-to-make-a-custom-uiview-in-ios-5-a-5-star-rating-view) 实现的星级评分自定义视图。


已实现：

* 在Xcode 9 上实现，原教程只可以全星评价，不能半星评价，已完善。

待完善的小细节：

1. 需要设置合适的指定初始化方法；
2. 设置好合适的指定初始化方法后，可以将一些不必要暴露的属性放在 extension 中；
3. RateView.m 文件中 setter 系列方法的 refresh 方法调用太频繁，设置好合适的指定初始化方法后，可以优化；


## 实现原理

[iOS 星级评价的两种实现方式](https://www.jianshu.com/p/37fd7097e302)


## 参考
* [UIView Tutorial for iOS: How To Make a Custom UIView in iOS 5: A 5 Star Rating View](https://www.raywenderlich.com/1768/uiview-tutorial-for-ios-how-to-make-a-custom-uiview-in-ios-5-a-5-star-rating-view)
* [XHStarRateView](https://github.com/XHJCoder/XHStarRateView)
* [AXRatingView](https://github.com/akiroom/AXRatingView)

