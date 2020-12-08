//
//  AppDelegate.h
//  GesturesDemo
//
//  Created by Qilin Hu on 2020/12/8.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@end

/**
 手势识别器使用示例
 
 参考：
 <https://www.appcoda.com/ios-gesture-recognizers/>
 <https://github.com/pro648/tips/wiki/%E6%89%8B%E5%8A%BF%E6%8E%A7%E5%88%B6%EF%BC%9A%E7%82%B9%E5%87%BB%E3%80%81%E6%BB%91%E5%8A%A8%E3%80%81%E5%B9%B3%E7%A7%BB%E3%80%81%E6%8D%8F%E5%90%88%E3%80%81%E6%97%8B%E8%BD%AC%E3%80%81%E9%95%BF%E6%8C%89%E3%80%81%E8%BD%BB%E6%89%AB>
 */


/**
 长按手势识别器 (UILongPressGestureRecognizer) 和屏幕边缘轻扫手势识别器 (UIScreenEdgePanGestureRecognizer) 只做简单介绍，不在使用代码详细说明。

 使用长按手势时用户必须使用一个或多个手指，按压视图一定时间才能触发响应。UILongPressGestureRecognizer 类包含以下四个属性：

 minimumPressDuration: 触发长按手势所需按压的最短时间，单位是秒，默认为 0.5 秒。
 numberOfTouchesRequired: 触发长按手势所需手指数，默认为 1。
 numberOfTapsRequired: 触发长按手势所需点击数，默认为 0。
 allowableMovement: 手指按压住视图后允许手指移动的最大距离，单位 point，默认 10 points。
 使用长按手势识别器时记得设置上面这些属性。另外，长按手势也是连续的。
 
 屏幕边缘轻扫手势识别器（UIScreenEdgePanGestureRecognizer）和滑动手势识别器很像，不同之处在于屏幕边缘轻扫手势必须从屏幕边缘开始。在 Safari 浏览器上，从屏幕左边缘滑动，可以回到上一页面，导航控制器默认支持这一功能。使用这一功能时，需要使用 edges 属性指定手势开始的边缘，你所指定的边缘应当对应于当前应用程序界面方向，这样才能确保手势始终从用户界面相同位置发生，而不受设备当前方向影响。
 
 
 你可能发现每一个手势的响应方法中都添加了 NSLog 方法，这样可以在动作方法执行时在控制台看到输出。
 你可以再运行一次 app，测试每一个手势，你会发现 UITapGestureRecognizer、UISwipeGestureRecognizer 和 UIPanGestureRecognizer 三个手势识别器一个手势执行一次动作方法，它们是离散（discrete）的。
 UIPinchGestureRecognizer 和 UIRotationGestureRecognizer 会多次调用动作方法，它们是连续（continuous）的。
 
 ???: 我怎么感觉 UIPanGestureRecognizer 平移手势识别器也是连续的
 */
