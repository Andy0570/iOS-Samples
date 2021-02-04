//
//  HQLContentModeViewController.h
//  UIImageTips
//
//  Created by Qilin Hu on 2020/5/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 UIViewContentMode 图片显示模式使用示例
 
  * 凡是带有 Scale 单词的属性，图片都会被拉伸。
  * 凡是带有 Ascept 单词属性，图片会保持原来的宽高比，即图片不会变形。
 
 参考
  * [iOS 编程：UIImage 使用 Tips](https://www.jianshu.com/p/9d858f073863)
  * [UIViewContentMode 图片显示模式](https:www.jianshu.com/p/7a286c84198b)
 */
@interface HQLContentModeViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/**
 
 UIImageView 对象会根据其 contentMode 属性显示一张指定的图片。
 
 contentMode 属性的作用是确定图片在 frame 内的显示位置和缩放模式。contentMode 的默认值是 UIViewContentModeScaleToFill。
 
 当 contentMode 的值是 UIViewContentModeScaleToFill 时，UIImageView 对象会在显示图片时缩放图片的大小，使其能够填满整个视图空间，但是可能会改变图片的宽高比。
 如果使用其默认值，UIImageView 对象为了能在正方形的区域中显示由相机拍摄的大尺寸照片，就要改变照片的宽高比。
 
 为了获得最佳显示效果，要修改 UIImageView 对象的 contentMode，要求其根据宽高比缩小照片。
 在 Aspect Fit 模式下，UIImageView 对象会在显示图片时按宽高比缩放图片，使其能够填满整个视图。
 
 
 // 但凡在设置图片模式的枚举中包含 Scale 这个单词的值,都会对原有的图片进行缩放
 typedef NS_ENUM(NSInteger, UIViewContentMode) {
 
     // 默认属性，按照 "UIImageView" 的宽高比缩放图片至图片填充整个 UIImageView。
     UIViewContentModeScaleToFill,
 
     // 按照"图片的宽高"比例缩放图片至图片的宽度或者高度和 UIImageView 一样,
     // 并且让整个图片都在 UIImageView 中,然后居中显示
     UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
 
     // 按照"图片的宽高"比例缩放图片至图片的宽度和高度填充整个UIImageView,然后居中显示
     // 会对图片进行放大、裁剪超过部分
     UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
     
     // 调用 setNeedsDisplay 方法时,就会重新渲染图片
     UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
     UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
     UIViewContentModeTop,
     UIViewContentModeBottom,
     UIViewContentModeLeft,
     UIViewContentModeRight,
     UIViewContentModeTopLeft,
     UIViewContentModeTopRight,
     UIViewContentModeBottomLeft,
     UIViewContentModeBottomRight,
 };
 
 
 */
