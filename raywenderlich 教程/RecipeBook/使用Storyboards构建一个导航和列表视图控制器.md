> 原文：
>
> [Use Storyboards to Build Navigation Controller and Table View](https://www.appcoda.com/use-storyboards-to-build-navigation-controller-and-table-view/)
>
> [Storyboards Segue Tutorial: Pass Data Between View Controllers](https://www.appcoda.com/storyboards-ios-tutorial-pass-data-between-view-controller-with-segue/)
>
> [iOS Programming Tutorial: Create a Simple Table View App](https://www.appcoda.com/ios-programming-tutorial-create-a-simple-table-view-app/)
>
> [Improve the Recipe App With a Better Detail View Controller](https://www.appcoda.com/improve-detail-view-controller-storyboard-segue/)



到目前为止，如果你已经关注了我们的教程，你应该对 `UITableView` 以及如何构建一个简单的应用程序有了基本的了解。本周，我们将讨论一些新的东西——Storyboards。这是 Xcode 4. 2 和 iOS 5 SDK 中引入的最令人兴奋的功能之一。作为一名 iOS 开发者，它让你的生活变得更简单，让你可以轻松设计 iOS 应用的用户界面。

在本教程中，我们将向您展示如何使用 Storyboards 来构建导航界面并将其与 `UITableView` 集成。我们尽量让事情简单化，专注于解释概念。所以没有花哨的界面或漂亮的图形。我们将把美工留给以后的教程。

好了，我们开始吧。



## 什么是导航控制器？

在编码之前，我们照例先来简单介绍一下导航控制器和故事板。

与列表视图一样，导航控制器是另一个你在 iOS 应用中常见的 UI 元素。它为分层的内容提供了一个向下钻取的界面。看看内置的照片应用、YouTube 和联系人。它们都是使用导航控制器来显示分层内容的。通常对于大多数应用来说，表格视图和导航控制器都是携手合作的。不过，这并不意味着你必须同时使用两者。

![An example of Navigation Controller – Photos App](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1wxe7n21j30go082wey.jpg)



## Storyboards 概述

如前所述，Storyboard 是 Xcode 4.2 发布后的一个新功能。它为 iOS 开发者提供了一种全新的方式来创建和设计用户界面。在引入 Storyboard 之前，对于初学者来说，创建导航（和标签）界面特别困难。每个界面都存储在一个单独的 nib 文件中。除此之外，你还必须编写代码将所有界面连接在一起，并描述导航的工作原理。

使用 Storyboards 之后，所有的页面都存储在一个文件中。这为您提供了应用程序视觉表现的概念性概述，并向您展示了屏幕是如何连接的。Xcode 提供了一个内置的编辑器来布局 Storyboards。您可以简单地使用 point 和 click 来定义不同屏幕之间的 transition（过渡，称为 segues）。这并不意味着您不需要为用户界面编写代码。但 Storyboards 大大减少了你需要编写的代码量。下面是一个示例截图，向您展示 Storyboards 在 Xcode 中的样子。

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1x8ol3w5j30go0azq3a.jpg)



## Scene and Segues 场景&分割

在使用故事板时，场景和分割是您经常遇到的两个术语。在故事板中，场景指的是单个视图控制器及其视图。每个场景都有一个 dock，它主要用于在视图控制器和它的视图之间建立动作和输出连接。

Segue 位于两个场景之间，管理两个场景之间的过渡。Push 和 Modal 是两种常见的过渡类型。





## 在故事板中创建导航控制器

现在让我们动手创建我们自己的 Storyboards。在本教程中，我们将构建一个简单的应用程序，它同时使用 `UITableView`和 `UINavigationController`。我们使用列表视图来显示食谱。当用户选择任何一个菜谱时，应用程序会导航到下一个显示详细信息的页面。这就很简单了。

首先，启动Xcode（确保你使用的是4.2以上版本），使用 "Single View application" 模板创建一个新项目：

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1xk6ku7bj30go0b9aah.jpg)

点击 "Next "继续。参照下图，填写 Xcode 项目所需的所有值。确保启用 "Use Storyboards " 选项：

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1xkyplo3j30go0b5q39.jpg)



点击 "Next" 继续。然后 Xcode 会询问你保存 "RecipeBook" 项目的位置。选择任何文件夹（如桌面）来保存你的项目。

你可能会注意到 Xcode 项目与你在之前的教程中遇到的那些项目相比，有一个小小的区别。.xib文件（界面构建器）被MainStoryboard.storyboard 文件所取代。

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1xn5gpruj30go08j74e.jpg)



默认情况下，Xcode 会创建一个标准的视图控制器。由于我们将使用导航控制器来控制屏幕导航，我们首先将视图控制器改为导航控制器。选择时只需在菜单中选择 "Editor"，然后选择 "Embed in"，再选择 "Navigation Controller"。

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1xoyzekkj30gm09swex.jpg)



Xcode 会自动将 RecipeBook View Controller 嵌入 Navigation Controller 中。你的屏幕应该是这样的：

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1ygpa5edj30go09l3yq.jpg)

在继续之前，让我们运行应用程序，看看它的外观。点击 "运行 "按钮，你应该会得到一个空白视图但添加了导航栏的应用程序。这表明你已经成功地将RecipeBook View控制器嵌入到导航控制器中。

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1yha1pgij30a80jwdfv.jpg)



## 为你的数据添加列表视图

接下来，我们将添加一个用于显示食谱的表格视图。在 "对象库 "中选择 "Table View"，并将其拖入 "Recipe Book View Controller"。

请注意，当编辑器被放大时，你不能拖动东西。如果你不能将表视图拖入视图控制器，请放大后再试。

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1yj1ggvvj30go095aaa.jpg)



接下来我们要做的就是编写代码来填充表格数据（即菜谱）。在Project Navigator中，选择 "RecipeBookViewController.h"。在 "UIViewController "后面添加""。你的代码应该像下面一样。

```objective-c
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@end
```

如果你看过我们的 Simple Table 教程，应该对代码非常熟悉。我就不详细解释代码了。如果你觉得难以理解，可以看看我们之前的教程。

接下来，选择 "RecipeBookViewController.m"，定义一个实例变量（即菜谱数组），用于存放表格数据。

```objc
@implementation ViewController {
    NSArray *recipes;
}
```

在 `viewDidLoad ` 方法中，添加以下代码来初始化 "recipes" 数组。

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    recipes = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
}
```

最后，我们要实现两个数据源方法来填充表格数据。`tableView:numberOfRowsInSection` 和 `tableView:cellForRowAtIndexPath`。记得这两个方法是 `UITableViewDataSource` 协议的一部分，在配置`UITableView` 时，必须实现这两个方法。第一个方法用于告知表视图该部分有多少行，而第二个方法用于填充单元格数据。所以我们来添加下面的代码：

```objc
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RecipeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [recipes objectAtIndex:indexPath.row];
    return cell;
}
```

这是 "RecipeBookViewController.m "的完整源代码，供大家参考。

```objc
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
//
//  RecipeBookViewController.m
//  RecipeBook
//
//  Created by Simon Ng on 14/6/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//
 
#import "RecipeBookViewController.h"
 
@interface RecipeBookViewController ()
 
@end
 
@implementation RecipeBookViewController {
    NSArray *recipes;
}
 
- (void)viewDidLoad
{
    [super viewDidLoad];
 // Initialize table data
    recipes = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
}
 
 
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recipes count];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [recipes objectAtIndex:indexPath.row];
    return cell;
}
 
@end
```

最后，我们要建立 "表视图 "和我们刚才创建的两个方法之间的联系。回到故事板。按住键盘上的Control键，选择 "Table View "并拖动到View Controller图标。你的屏幕应该是这样的。

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1ysnra80j30go0c0dg6.jpg)



松开这两个按钮，弹出的窗口同时显示 "dataSource"&"delegate"。选择 "dataSource"，使表视图与其数据源之间建立连接。重复上述步骤，与委托人建立连接。

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1ytq3j9nj30bb04imx5.jpg)

在测试应用之前，我们要做的最后一件事是为导航栏添加一个标题。只需选择 "菜谱视图控制器 "的导航栏，在 "属性检查器 "下填写 "标题 "即可。记得在键入标题后按下ENTER键即可实现更改。

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1yurronkj30or0f6dgw.jpg)

现在，是时候执行你的代码了。点击 "运行 "按钮，测试你的应用程序。如果你的代码是正确的，你应该最终得到一个显示食谱列表的应用程序。该应用程序应该与你之前构建的简单表格应用程序非常相似。这里，主要的区别是它嵌入了一个导航控制器。

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1yv9n7sxj30a80jw3yx.jpg)

你还记得我们是如何自定义列表单元格的吗？几周前，我们向您展示了如何使用Interface Builder设计自己的自定义列表单元格。简而言之，你需要为单元格创建一个单独的 nib 文件，并在列表中以编程方式加载它。随着Storyboard中Prototype Cell的引入，创建自定义单元格就简单多了。原型单元格允许您在Storyboard编辑器中轻松设计表格单元格的布局。

在本教程中，我们将不会深入探讨自定义的细节，而只是简单地在单元格中添加 "Disclosure Indicator"。

要添加一个原型单元格，请选择 "表视图"。在 "属性检查器 "下，将 "原型单元格 "的值从 "0 "改为 "1"。只要你改变该值，Xcode就会自动向你显示一个原型单元格。为了向你展示另一种表格样式，我们也将 "样式 "选项从 "Plain "改为 "Group"。



![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1yybiaj2j30go0cumxv.jpg)





接下来，选择 "Prototype Cell"。您应该可以自定义单元格的选项。要显示每个单元格的Disclosure Indicator，请将 "Accessory "改为 "Disclosure Indicator"。定义 "重用标识符 "很重要。您可以将此标识符视为单元格的 ID。我们可以用它来指代特定的原型单元格。在这里，我们将标识符定义为与我们的代码相匹配的 "RecipeCell"。

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gp1z3jua76j30go0dc751.jpg)



现在，再次运行应用程序。它看起来有点不同，我们正在取得进展。我们已经将表格样式改为 "分组 "样式，并添加了披露指标。



## 添加详细视图控制器

。。。