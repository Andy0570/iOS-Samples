#import <UIKit/UIKit.h>

// 常量宏定义类

// RGB颜色
#define HQLColor(r, g, b)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HQLColor_A(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// 字体大小
#define HQLLabelFont [UIFont boldSystemFontOfSize:13]
#define HQLFont(f)   [UIFont systemFontOfSize:(f)]
#define HQLFontB(f)  [UIFont boldSystemFontOfSize:(f)]

// 弱引用&强引用
#define WS(weakself)    __weak __typeof(&*self)weakself = self;
#define SS(strongself)  __strong __typeof(&*self)strongself = self;

// 图片路径
#define HQLPasswordViewSrcName(file) [@"HQLPassword.bundle" stringByAppendingPathComponent:file]

/** 屏幕的宽高 */
#define HQLScreen        [UIScreen mainScreen]
#define HQLScreenWidth   HQLScreen.bounds.size.width
#define HQLScreenHeight  HQLScreen.bounds.size.height

// 常量
/** 密码框的高度 */
UIKIT_EXTERN const CGFloat HQLPasswordInputViewHeight;
/** 密码框标题的高度 */
UIKIT_EXTERN const CGFloat HQLPasswordViewTitleHeight;
/** 密码框显示或隐藏时间 */
UIKIT_EXTERN const CGFloat HQLPasswordViewAnimationDuration;
/** 关闭按钮的宽高 */
UIKIT_EXTERN const CGFloat HQLPasswordViewCloseButtonWH;
/** 关闭按钮的左边距 */
UIKIT_EXTERN const CGFloat HQLPasswordViewCloseButtonMarginLeft;
/** 输入点的宽高 */
UIKIT_EXTERN const CGFloat HQLPasswordViewPointnWH;
/** TextField图片的宽 */
UIKIT_EXTERN const CGFloat HQLPasswordViewTextFieldWidth;
/** TextField图片的高 */
UIKIT_EXTERN const CGFloat HQLPasswordViewTextFieldHeight;
/** TextField图片向上间距 */
UIKIT_EXTERN const CGFloat HQLPasswordViewTextFieldMarginTop;
/** 忘记密码按钮向上间距 */
UIKIT_EXTERN const CGFloat HQLPasswordViewForgetPWDButtonMarginTop;

