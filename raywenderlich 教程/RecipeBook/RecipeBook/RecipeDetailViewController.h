//
//  RecipeDetailViewController.h
//  RecipeBook
//
//  Created by Qilin Hu on 2021/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecipeDetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *recipeLabel;
@property (nonatomic, strong) NSString *recipeName;

@end

NS_ASSUME_NONNULL_END

/**
 这就到了教程的核心部分，如何使用Segue在视图控制器之间传递数据。Segues管理视图控制器之间的过渡。
 在此基础上，segue对象用于为从一个视图控制器到另一个视图控制器的过渡做准备。当一个segue被触发时，
 在视觉过渡发生之前，storyboard 运行时会调用当前视图控制器（在我们的例子中，是RecipeBookViewController）的prepareForSegue:sender:方法。
 通过实现这个方法，我们可以将任何需要的数据传递给即将显示的视图控制器。

 然而，最好的做法是给Storyboards中的每个转折点一个唯一的标识符。这个标识符是一个字符串，您的应用程序使用它来区分一个转场和另一个转场。
 随着您的应用程序变得越来越复杂，您很可能会在视图控制器中拥有多个转场。

 要分配标识符，请选择segue并在身份检查器中设置它。让我们把这个分道符命名为 "showRecipeDetail"。
 */
