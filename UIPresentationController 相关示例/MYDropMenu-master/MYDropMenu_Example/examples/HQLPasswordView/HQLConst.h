#import <UIKit/UIKit.h>

// 图片路径
#define HQLPasswordViewSrcName(file) [@"HQLPassword.bundle" stringByAppendingPathComponent:file]

#define COLOR_RGB(r, g, b)      [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
/** 字体 */
#define FONT(f)         [UIFont systemFontOfSize:(f)]
#define FONT_LABEL      [UIFont boldSystemFontOfSize:13]
#define FONT_THEME      [UIFont systemFontOfSize:18]

/** 弱引用&强引用 */
#define WeakSelf(weakSelf)      __weak __typeof(self)weakSelf = self;
#define StrongSelf(strongSelf)  __strong __typeof(weakSelf)strongSelf = weakSelf;

// 常量
/** 密码框的高度 */
UIKIT_EXTERN const CGFloat HQLPasswordInputViewHeight;
/** 密码框标题的高度 */
UIKIT_EXTERN const CGFloat HQLPasswordViewTitleHeight;
/** 密码框显示或隐藏时间 0.3*/
UIKIT_EXTERN const CGFloat HQLPasswordViewAnimationDuration;
/** 关闭按钮的宽高 20*/
UIKIT_EXTERN const CGFloat HQLPasswordViewCloseButtonWH;
/** 关闭按钮的左边距 10*/
UIKIT_EXTERN const CGFloat HQLPasswordViewCloseButtonMarginLeft;
/** 输入点的宽高 10*/
UIKIT_EXTERN const CGFloat HQLPasswordViewPointnWH;
/** TextField图片的宽 297*/
UIKIT_EXTERN const CGFloat HQLPasswordViewTextFieldWidth;
/** TextField图片的高 50*/
UIKIT_EXTERN const CGFloat HQLPasswordViewTextFieldHeight;
/** TextField图片向上间距 */
UIKIT_EXTERN const CGFloat HQLPasswordViewTextFieldMarginTop;
/** 忘记密码按钮向上间距 12*/
UIKIT_EXTERN const CGFloat HQLPasswordViewForgetPWDButtonMarginTop;

