>  原文：[ReactiveCocoa Tutorial – The Definitive Introduction: Part 1/2](https://www.raywenderlich.com/2493-reactivecocoa-tutorial-the-definitive-introduction-part-1-2)

对一名 iOS 开发者来说，你几乎写的每一行代码都是对某些事件的响应；按钮的点击，接收到的网络消息，属性值的改变（*通过 Key Value Observing*）或者通过 CoreLocation 更新用户的位置都是这方面很好的例子。然而，这些事件都是以不同的方式处理的，如动作、委托、KVO、回调等等。[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) 为事件定义了一套标准的接口，因此可以使用一套基本的工具更容易地对它们进行链接、过滤和组合。

听起来令人困惑？神往？......心惊肉跳？那么请继续阅读 :]

ReactiveCocoa 结合了几种编程风格：

* [函数式编程](https://www.wikiwand.com/zh-hans/%E5%87%BD%E6%95%B0%E5%BC%8F%E7%BC%96%E7%A8%8B)（Functional Programming）其中使用了高阶函数，即以其他函数为参数的函数。
* [响应式编程](https://zh.wikipedia.org/zh-hans/%E5%93%8D%E5%BA%94%E5%BC%8F%E7%BC%96%E7%A8%8B)（Reactive Programming）它的重点是数据流和变化的传递。

出于这个原因，你可能会听到 ReactiveCocoa 被描述为一个函数响应式编程（Functional Reactive Programming，FRP）框架。

请放心，这就是本教程所有学术性的内容。编程范式是一门引人入胜的学科，但本 ReactiveCocoa 教程的剩余部分只关注实用价值，通过代码实例描述它的工作方式而不是理论学术知识。

## Reactive 游乐园

在整个 ReactiveCocoa 教程中，你将会把响应式编程添加到一个非常简单的示例应用程序中，即 ReactivePlayground。下载[初始化项目](https://koenig-media.raywenderlich.com/uploads/2014/01/ReactivePlayground-Starter.zip)，然后编译并运行以验证你是否正确设置了一切。

ReactivePlayground 是一款非常简单的应用，它向用户呈现了一个登录界面。输入正确的凭证，想象一下，用户名是 user，密码是 password，然后你会看到一张可爱的小猫咪的图片。

![](https://koenig-media.raywenderlich.com/uploads/2014/01/ReactivePlaygroundStarter.jpg)

啊! 真可爱！

现在，花点时间看看这个入门项目中的代码是个不错的起点。它很简单，所以应该不会花很长时间。

打开 **RWViewController.m** 文件，看看你能以多快的速度识别出 **Sign In** 按钮启用的条件？显示或者隐藏 `signInFailure` Label 的规则又是什么？在这个相对简单的例子中，回答这些问题可能只需要一两分钟。然而在更复杂的例子中，通过同样类型的分析查清楚这些规则可能需要更长的时间。

使用 ReactiveCocoa 之后，应用程序的底层意图就会变得更加清晰。是时候开始了!

## 添加 ReactiveCocoa 框架

> [!IMPORTANT]
>
> [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) 框架现在已经更新并划分为 [ReactiveObjc](https://github.com/ReactiveCocoa/ReactiveObjC) 和 [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
>
> * [ReactiveObjc](https://github.com/ReactiveCocoa/ReactiveObjC) 对应的是 RAC 的 Objective-C 语言版本，最新的是  3.1.1 版本。
> * [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) 对应的是 RAC 的 Swift 语言版本，最新的是 11.1.0 版本。
>
> 以下所提及的 ReactiveCocoa 在本文中指的其实就是 ReactiveObjc。
>
> 因为本教程基于 Objective-C 语言，所以我们应该使用 **ReactiveObjc** 框架。

将 ReactiveObjc 框架添加到项目中最简单的方法是使用 [CocoaPods](http://cocoapods.org/)。如果你从来没有使用过 CocoaPods，遵循本网站上的 [CocoaPod介绍](https://www.raywenderlich.com/?p=12139) 教程可能是有意义的，或者至少运行该教程的初始步骤，以便你可以安装本教程的先决条件。

> **注意**：如果出于某些原因你不想使用 CocoaPods，你仍然可以使用 ReactiveObjc，只要按照 GitHub 上文档中的 [导入ReactiveObjc](https://github.com/ReactiveCocoa/ReactiveObjC#importing-reactiveObjc) 的步骤即可。

如果你现在仍然在 Xcode 中打开着 **ReactivePlayground** 项目，那么现在就关闭它。CocoaPods 会创建一个 Xcode 工作空间，你会用它来代替原来的项目文件。

打开 **Terminal** 终端。将路径导航到你项目所在的文件夹，然后输入以下内容：

```bash
pod init
vim Podfile
```

这里会创建一个名为 **Podfile** 的初始化文件，并用 **vim** 打开它。将 `pod 'ReactiveObjC', '~> 3.1.1'` 添加到你的 `Podfile` 文件中：

```ruby
# 指明依赖库的来源地址，不使用默认 CDN
source 'https://github.com/CocoaPods/Specs.git'

# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'RWReactivePlayground' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for RWReactivePlayground
  pod 'ReactiveObjC', '~> 3.1.1'

  target 'RWReactivePlaygroundTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
```

这里将平台设置为 iOS，SDK 最低版本为 9.0，并将 ReactiveObjC 框架添加为依赖关系。

保存好这个文件后，回到 **Terminal** 窗口，输入以下命令：

```bash
pod install
```

你应该看到一个类似于下面的输出：

```bash
Analyzing dependencies
Downloading dependencies
Installing ReactiveObjC (3.1.1)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `RWReactivePlayground.xcworkspace` for this project from now on.
Pod installation complete! There is 1 dependency from the Podfile and 1 total pod installed.
```

这说明 ReactiveObjC 框架已经下载完毕，CocoaPods 已经创建了一个 Xcode workspace，并将框架集成到了你现有的应用中。

打开新生成的工作空间，**RWReactivePlayground.xcworkspace**，看看 CocoaPods 在项目导航栏里面创建的结构：

![](https://koenig-media.raywenderlich.com/uploads/2014/01/AddedCocoaPods.png)

你应该看到 CocoaPods 创建了一个新的工作空间，并添加了原始项目 RWReactivePlayground，以及一个包含 ReactiveObjc 的 Pods 项目。CocoaPods 确实让管理依赖关系变得轻而易举！

你会注意到这个项目的名字叫 ReactivePlayground，所以这一定意味着是时候玩了......。

## 是时候玩了

正如前言中所提到的，ReactiveCocoa 提供了一个标准的接口来处理应用程序中发生的不同事件流。在 ReactiveCocoa 术语中，这些事件被称为**信号（signal）**，并由 `RACSignal` 类来表示。

打开本应用的初始视图控制器 **RWViewController.m**，在文件顶部添加以下内容，导入 ReactiveObjc 头文件：

```objc
#import <ReactiveObjC/ReactiveObjC.h>
```

你还不打算替换任何现有代码，现在你只是要玩会儿。在 `viewDidLoad` 方法的末尾添加以下代码：

```objc
// self 订阅 usernameTextField 的 text 信号，接收 next 事件
[self.usernameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
    NSLog(@"%@", x);
}];
```

编译并运行应用程序，并在用户名输入框中输入一些文本。注意观察控制台，看看是否有类似下面的输出：

```bash
2020-12-25 10:42:36.037050+0800 RWReactivePlayground[24251:2953713] i
2020-12-25 10:42:36.715071+0800 RWReactivePlayground[24251:2953713] is
2020-12-25 10:42:38.627540+0800 RWReactivePlayground[24251:2953713] is
2020-12-25 10:42:39.327718+0800 RWReactivePlayground[24251:2953713] is t
2020-12-25 10:42:39.743444+0800 RWReactivePlayground[24251:2953713] is th
2020-12-25 10:42:40.213227+0800 RWReactivePlayground[24251:2953713] is thi
2020-12-25 10:42:40.382229+0800 RWReactivePlayground[24251:2953713] is this
2020-12-25 10:42:40.702870+0800 RWReactivePlayground[24251:2953713] is this
2020-12-25 10:42:41.430766+0800 RWReactivePlayground[24251:2953713] is this m
2020-12-25 10:42:41.573035+0800 RWReactivePlayground[24251:2953713] is this ma
2020-12-25 10:42:42.733458+0800 RWReactivePlayground[24251:2953713] is this mag
2020-12-25 10:42:42.886624+0800 RWReactivePlayground[24251:2953713] is this magi
2020-12-25 10:42:43.047428+0800 RWReactivePlayground[24251:2953713] is this magic
2020-12-25 10:42:44.066096+0800 RWReactivePlayground[24251:2953713] is this magic?
```

你可以看到，每当你在用户名输入框中更改文本时，Block 块中的代码就会执行。没有 target-action，没有 delegate 委托，只有信号和 Block 块。这太令人兴奋了！

ReactiveCocoa 信号（用 `RACSignal` 表示）向其订阅者发送事件流。有三种类型的事件需要知道：**next**、**error** 和 **completed**。一个信号在出错并终止或者完成之前，可以发送任意数量的 **next** 事件。在本教程中，将重点介绍 **next** 事件。如果要开始了解 **error** 和 **completed** 事件，请务必阅读本教程的第二部分。

`RACSignal` 有许多方法可以用来订阅不同的事件类型。每个方法都需要一个或多个 Block 块，当一个事件发生时，Block 块中的逻辑就会被执行。在本例中，你可以看到 `subscribeNext:` 方法提供了一个 Block 块，用来触发并执行每一次的 `next` 事件。

ReactiveCocoa 框架使用 categories 来为许多标准的 UIKit 控件添加信号，这样你就可以为它们的事件添加订阅，这就是 `UITextField` 上 `rac_textSignal` 属性的由来。

但理论上的东西已经够多了，是时候开始让 ReactiveCocoa 替你干活了。

ReactiveCocoa 有大量的操作符让你用来操作事件流。例如，假设你只对长度超过三个字符的用户名感兴趣。你可以通过使用 `filter` 操作符来实现。将之前在 `viewDidLoad` 中添加的代码更新为以下内容：

```objc
[[self.usernameTextField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
    return value.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
```

如果你编译并运行，然后在用户名输入框中输入一些文本，你应该会发现，只有当文本字段长度大于三个字符时，它才开始记录：

```bash
2020-12-25 11:01:58.183761+0800 RWReactivePlayground[24588:2970617] is t
2020-12-25 11:01:58.349105+0800 RWReactivePlayground[24588:2970617] is th
2020-12-25 11:01:58.597578+0800 RWReactivePlayground[24588:2970617] is thi
2020-12-25 11:01:58.665779+0800 RWReactivePlayground[24588:2970617] is this
2020-12-25 11:02:00.711772+0800 RWReactivePlayground[24588:2970617] is this
2020-12-25 11:02:01.071901+0800 RWReactivePlayground[24588:2970617] is this m
2020-12-25 11:02:01.182999+0800 RWReactivePlayground[24588:2970617] is this ma
2020-12-25 11:02:01.387688+0800 RWReactivePlayground[24588:2970617] is this mag
2020-12-25 11:02:02.913319+0800 RWReactivePlayground[24588:2970617] is this magi
2020-12-25 11:02:03.058652+0800 RWReactivePlayground[24588:2970617] is this magic
2020-12-25 11:02:03.651991+0800 RWReactivePlayground[24588:2970617] is this magic?
```

你在这里创建的是一个非常简单的**管道（pipeline）**。它是响应式编程的精髓，通过数据流来表达应用程序的功能。

我们可以用数据流图的方式来描述它：

![](https://koenig-media.raywenderlich.com/uploads/2014/01/FilterPipeline.png)

上图中，你可以看到 `rac_textSignal` 是事件的初始来源。数据流经一个 `filter` 过滤器，只有当事件包含一个长度大于 3 的字符串时，才允许事件通过。管道的最后一步是通过 `subscribeNext:` 方法中的 Block 块记录事件值。

值得注意的是，`filter` 过滤器操作的输出也是一个 `RACSignal`。你可以将代码安排如下，以显示离散的管道步骤：

```objc
RACSignal *usernameSourceSignal = self.usernameTextField.rac_textSignal;

RACSignal *filteredUsername = [usernameSourceSignal filter:^BOOL(id  _Nullable value) {
    NSString *text = value;
    return text.length > 3;
}];

[filteredUsername subscribeNext:^(id  _Nullable x) {
    NSLog(@"%@", x);
}];
```

因为对 `RACSignal` 的每一步操作都会返回一个 `RACSignal`，所以被称为 [Fluent interface](http://en.wikipedia.org/wiki/Fluent_interface)。这个特性允许你构建管道，而不需要使用局部变量来引用每个步骤。

> **注意**：ReactiveCocoa 大量使用了 Blocks。如果你是 block 编程的新手，你可能会想阅读 Apple 的 [Blocks 编程主题](https://developer.apple.com/library/ios/documentation/cocoa/Conceptual/Blocks/Articles/00_Introduction.html)。如果你和我一样，熟悉 Block，但发现语法有点混乱和难以记忆，你可能会发现标题有趣的 [f******gblocksyntax.com/](https://developer.apple.com/library/ios/documentation/cocoa/Conceptual/Blocks/Articles/00_Introduction.html) 相当有用！ (为了保护无辜者，我们删掉了这个词，但链接是完全可以使用的。)

## 一点点铸造

如果你更新了代码，把它分割成各种 `RACSignal` 组件，现在是时候把它恢复到流畅的语法了：

```objc
[[self.usernameTextField.rac_textSignal filter:^BOOL(id value) {
    NSString *text = value; // 隐式转换
    return text.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
```

上面代码中，从 `id` 到 `NSString` 的隐式转换并不优雅。幸运的是，由于传递到这个 Block 块的值总是 `NSString` 类型，因此你可以改变参数类型本身。更新你的代码如下：

```objc
[[self.usernameTextField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
    return value.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
```

编译并运行，确认这和之前一样工作。

## 什么是事件？

到目前为止，本教程已经描述了不同的事件类型，但还没有详细介绍这些事件的结构。有趣的是，一个事件绝对可以包含任何东西！

作为对这点的说明，你将在管道中添加另一个操作。更新你添加到 `viewDidLoad` 的代码如下：

```objc
[[[self.usernameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        // map 方法：通过 Block 块对事件中的数据进行转换
        // 此 Block 块中，接受 NSString 类型的输入并获取字符串的长度，返回一个 NSNumber 类型
        return @(value.length);
    }] filter:^BOOL(NSNumber *length) {
        return length.integerValue > 3;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
```

如果你编译并运行，你会发现应用程序现在记录的是文本的长度，而不是内容：

```bash
2020-12-25 11:53:22.507776+0800 RWReactivePlayground[25492:3015912] 4
2020-12-25 11:53:22.619187+0800 RWReactivePlayground[25492:3015912] 5
2020-12-25 11:53:22.849555+0800 RWReactivePlayground[25492:3015912] 6
2020-12-25 11:53:22.930413+0800 RWReactivePlayground[25492:3015912] 7
2020-12-25 11:53:23.410323+0800 RWReactivePlayground[25492:3015912] 8
2020-12-25 11:53:23.682407+0800 RWReactivePlayground[25492:3015912] 9
2020-12-25 11:53:23.759639+0800 RWReactivePlayground[25492:3015912] 10
2020-12-25 11:53:23.975977+0800 RWReactivePlayground[25492:3015912] 11
2020-12-25 11:53:25.152581+0800 RWReactivePlayground[25492:3015912] 12
```

新增加的 `map` 操作通过 Block 块对事件中的数据进行了转换。每接收到一个 `next` 事件，它都会运行给定的 Block 块，并将返回值作为 **next event** 发出。在上面的代码中，`map` 接收`NSString` 类型的输入并获取其长度值，并返回一个 `NSNumber` 类型。

如果想了解其令人惊叹的工作原理，请看这张图：

![](https://koenig-media.raywenderlich.com/uploads/2014/01/FilterAndMapPipeline.png)

正如你所看到的，所有在 `map` 操作之后的步骤现在都会接收到 `NSNumber` 实例。你可以使用 `map` 操作将接收到的数据转化为任何你喜欢的东西，只要它是一个**对象**。

> **注意**：在上面的示例中，`text.length` 属性返回一个 `NSUInteger` 类型，这是一个基础数据类型（基础数据类型不是对象）。为了将它作为事件的内容使用，它必须被装箱。幸运的是，Objective-C 的字面量语法提供了一个相当简洁的方式来实现这一点--`@(text.length)`。

玩够了! 现在是时候更新 **ReactivePlayground** 应用程序了，并使用到目前为止你所学到的概念。你可以删除你在本教程开始部分添加的所有代码。


## 创建验证状态的信号

首先，你需要做的是创建几个信号来验证用户名和密码输入框中输入的内容是否有效。在 **RWViewController.m** 中的 `viewDidLoad` 末尾添加以下内容：

```objc
RACSignal *validUsernameSignal = [self.usernameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
    return @([self isValidUsername:value]);
}];

RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
    return @([self isValidPassword:value]);
}];
```

正如你所看到的，上面的代码对每个文本输入框的  `rac_textSignal` 进行了 map 变换。输出的是一个通过  `NSNumber`  封装的布尔值。

下一步是转换这些信号，使它们为文本输入框提供一个漂亮的背景色。通常，你订阅这个信号，并使用结果来更新文本输入框的背景色。一个可行的方案如下：

```objc
[[validPasswordSignal map:^id _Nullable(NSNumber *passwordValid) {
        return passwordValid.boolValue ? UIColor.clearColor : UIColor.yellowColor;
    }] subscribeNext:^(UIColor *color) {
        self.passwordTextField.backgroundColor = color;
    }];
```

（*请不要添加这段代码，还有一个更优雅的解决方案。*）

从概念上讲，你把这个信号的输出分配给文本输入框的 `backgroundColor` 属性。然而，上面的代码是一个很差的表达方式，都是倒过来的。

幸运的是，ReactiveCocoa 有一个宏，可以让你优雅地表达这一点。在你添加到 `viewDidLoad` 的两个信号下面直接添加下面的代码：

```objc
RAC(self.usernameTextField, backgroundColor) = [validUsernameSignal map:^id _Nullable(NSNumber *usernameValid) {
    return usernameValid.boolValue ? UIColor.clearColor : UIColor.yellowColor;
}];

RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id _Nullable(NSNumber *passwordValid) {
    return passwordValid.boolValue ? UIColor.clearColor : UIColor.yellowColor;
}];
```

`RAC` 宏允许你将信号的输出分配给对象的属性。它需要两个参数，第一个是包含要设置属性的对象，第二个是对象的属性名。每次信号发出 next 事件时，传递的值都会被分配给给定的属性。

这是一个非常优雅的解决方案，你不觉得吗？

在编译和运行之前，还有最后一件事。找到 `updateUIState` 方法，删除前两行：

```objc
self.usernameTextField.backgroundColor = self.usernameIsValid ? [UIColor clearColor] : [UIColor yellowColor];
self.passwordTextField.backgroundColor = self.passwordIsValid ? [UIColor clearColor] : [UIColor yellowColor];
```

这里删除了非响应式（non-reactive）代码。

编译并运行应用程序。你应该发现，文本输入框字段在无效时看起来是高亮状态，有效时则清除高亮状态。

可视化很有用，所以这里有一种方法来可视化当前的逻辑。在这里你可以看到两个简单的管道，它们接收文本信号，将其映射到描述有效性的布尔值，然后跟着第二个映射到 `UIColor`，这是与文本字段的背景颜色绑定的部分。

![](https://koenig-media.raywenderlich.com/uploads/2014/01/TextFieldValidPipeline.png)

你是否想知道为什么要创建单独的 `validPasswordSignal` 和 `validUsernameSignal` 信号，而不是为每个文本字段创建一个单一的 *fluent* 管道？亲爱的读者，请耐心等待，这个疯狂背后的方法很快就会变得清晰起来!

## 组合信号

在当前应用程序中，只有当用户名和密码输入框字段都是有效输入时，登录按钮才会工作。现在是时候用响应式风格来实现了。

当前的代码中已经有信号发出布尔值来描述用户名和密码字段是否有效；即 `validUsernameSignal` 和 `validPasswordSignal`。你的任务是结合这两个信号来决定何时可以启用按钮。

在 `viewDidLoad` 的末尾添加以下内容：

```objc
RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
    return @(usernameValid.boolValue && passwordValid.boolValue);
}];
```

上面的代码使用 `combineLatest:reduce:` 方法将 `validUsernameSignal` 和 `validPasswordSignal` 发出的最新值合并成一个闪亮的新信号。每当两个源信号中的任何一个发出新的值时，`reduce` 块就会执行，它返回的值作为合并信号的 next 值发送。

> [!NOTE]
>
> `RACSignal` 的 `combine` 方法可以组合任意数量的信号，`reduce` 块的参数对应于每个源信号。ReactiveCocoa 有一个狡猾的小实用类 `RACBlockTrampoline`，它在内部处理 `reduce` 块的变量参数列表。事实上，ReactiveCocoa 的实现中隐藏着很多狡猾的技巧，所以很值得拉开盖子!

现在你有了一个合适的信号，在 `viewDidLoad` 的结尾添加以下内容。这将把它连接到按钮的 `enabled` 属性：

```objc
[signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
    self.signInButton.enabled = signupActive.boolValue;
}];
```

在运行这段代码之前，是时候移除旧的实现了。从文件顶部删除这两个属性：

```objc
@property (nonatomic) BOOL passwordIsValid;
@property (nonatomic) BOOL usernameIsValid;
```

在 `viewDidLoad` 的顶部，删除以下内容：

```objc
// 处理两个文本输入框的输入内容更新
[self.usernameTextField addTarget:self action:@selector(usernameTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
[self.passwordTextField addTarget:self action:@selector(passwordTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
```

同时删除 `updateUIState`、`usernameTextFieldChanged` 和 `passwordTextFieldChanged` 方法。呼！你刚刚处理掉了很多非响应式代码。你会感谢你所做的。

最后，确保从 `viewDidLoad` 中删除对 `updateUIState` 方法的调用。

如果你编译并运行，检查登录按钮。它应该被启用，因为用户名和密码文本字段是有效的，就像之前一样。

对应用逻辑图进行更新后，得到以下内容：

![](https://koenig-media.raywenderlich.com/uploads/2014/01/CombinePipeline.png)

```tex
 password                                                                             
┌───────────────┐ NSString ┌───────┐   BOOL ┌───────┐ UIColor ┌─────────────────┐     
│rac_textSignal ├─────────►│  map  ├─┬─────►│  map  ├────────►│ backgroundColor │     
└───────────────┘          └───────┘ │      └───────┘         └─────────────────┘     
                                     │                                                
                                     │  ┌────────────────────┐ BOOL  ┌───────────────┐
                                     ├─►│combineLatest:reduce├──────►│ subscribeNext │
                                     │  └────────────────────┘       └───────────────┘
 username                            │                                                
┌───────────────┐ NSString ┌───────┐ │ BOOL ┌───────┐ UIColor ┌─────────────────┐     
│rac_textSignal ├─────────►│  map  ├─┴─────►│  map  ├────────►├─backgroundColor │     
└───────────────┘          └───────┘        └───────┘         └─────────────────┘     
```

上面阐述了几个重要的概念，这些概念允许你用 ReactiveCocoa 执行一些非常强大的任务。

* **Splitting** 拆分——信号可以有多个订阅者，并作为多个后续管道步骤的输入源。在上图中，请注意表示密码和用户名有效性的布尔信号被拆分并用于几个不同的目的。
* **Combining** 合并——多个信号可以被合并以创建新的信号。在这种情况下，两个布尔信号被组合起来。然而，你可以组合发出任何值类型的信号。

这些变化的结果就是，应用程序不再具有描述两个文本输入框字段当前有效状态的私有属性。这是采用响应式风格时你会发现的关键区别之一——你不需要使用实例变量来跟踪瞬时状态。

## Reactive 登录

目前，该应用程序使用上面说明的响应式管道来管理文本输入框和按钮的状态。然而，按钮的点击处理仍然使用 action 动作，所以下一步是替换剩下的应用逻辑，以便使其全部成为响应式的！

登录按钮上的 **Touch Up Inside** 事件通过 storyboard 上的 action 连接到 **RWViewController.m** 中的 `signInButtonTouched` 方法上。你要用响应式等价物来代替它，所以你首先需要断开当前的 storyboard 动作。

打开 **Main.storyboard**，找到 **Sign In** 按钮，ctrl 点击调出 outlet/action 连接，点击 x 删除连接。如果你感到茫然，下图贴心地告诉你在哪里可以找到删除按钮：

![](https://koenig-media.raywenderlich.com/uploads/2014/01/DisconnectAction.jpg)

你已经看到了 ReactiveCocoa 框架是如何为标准的 UIKit 控件添加属性和方法的。到目前为止，你已经使用了`rac_textSignal`，它在文本输入框内容变化时发出事件。为了处理按钮点击事件，你需要使用 ReactiveCocoa 添加到 UIKit 上的另一个方法，`rac_signalForControlEvents`。

返回 `RWViewController.m`，在 `viewDidLoad` 的末尾添加以下内容：

```objc
[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
    NSLog(@"button clicked");
}];
```

上面的代码从按钮的 `UIControlEventTouchUpInside` 事件中创建了一个信号，并添加了一个订阅，以便在每次这个事件发生时执行一次日志记录。

编译并运行以确认该消息确实记录下来。请记住，只有当用户名和密码有效时，按钮才会启用，所以在点击按钮之前，一定要在这两个字段中输入一些文本！

你应该在 Xcode 控制台中看到类似以下的消息：

```bash
2020-12-25 14:17:08.643189+0800 RWReactivePlayground[27851:3123372] button clicked
2020-12-25 14:17:09.235768+0800 RWReactivePlayground[27851:3123372] button clicked
2020-12-25 14:17:10.550770+0800 RWReactivePlayground[27851:3123372] button clicked
2020-12-25 14:17:10.909417+0800 RWReactivePlayground[27851:3123372] button clicked
2020-12-25 14:17:11.312301+0800 RWReactivePlayground[27851:3123372] button clicked
```

现在按钮已经有了一个触摸事件的信号，下一步就是把这个与登录过程本身连接起来。出现了一个问题--不过这很好，你不介意出现问题吧？打开 `RWDummySignInService.h`，看一下界面。

```objc
#import <Foundation/Foundation.h>

typedef void (^RWSignInResponse)(BOOL);

@interface RWDummySignInService : NSObject

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock;

@end
```

该服务将用户名、密码和完成 Block 块作为参数。当登录成功或失败时，给定的 Block 块将被执行。你可以直接在当前记录按钮触摸事件的 `subscribeNext:` 块中使用这个接口，但你为什么要这样做呢？这就是 ReactiveCocoa 当早餐吃的那种异步的、基于事件的行为!

> **注意**：本教程中为了简单起见，使用了一个虚拟服务，这样你就不会对外部 API 产生任何依赖。然而，你现在遇到了一个很现实的问题，如何使用不是用信号表达的 API？

## 创建信号

幸运的是，将现有的异步 API 改为信号表示相当容易。首先，从 `RWViewController.m` 中删除当前的 `signInButtonTouched:` 方法，你不需要这个逻辑，因为它将被一个响应式的等价物取代。

留在 `RWViewController.m` 中，添加以下方法：

```objc
- (RACSignal *)signInSingal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self.signInService signInWithUsername:self.usernameTextField.text password:self.passwordTextField.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}
```

上述方法创建了一个用当前用户名和密码登录的信号。现在来分析一下它的组件部分。

上面的代码使用 `RACSignal` 上的 `createSignal:` 方法来创建信号。描述这个信号并传递给这个方法的 Block 块是一个单一的参数。当这个信号有一个订阅者时，Block 块内的代码就会执行。

该 Block 块被传递给一个单一的 `subscriber` 订阅者实例，该实例遵守 `RACSubscriber` 协议，它的方法是你为了发出事件而调用的；你也可以发送任意数量的 **next** 事件，以 **error** 或 **complete** 事件结束。在这种情况下，它发送一个单一的 **next** 事件来指示登录是否成功，然后是一个 **complete** 事件。

这个 Block 块的返回类型是一个 `RACDisposable` 对象，它允许你在取消或销毁订阅时执行任何可能需要的清理工作。这个信号没有任何清理要求，因此返回 `nil`。

正如你所看到的，将一个异步 API 包裹在一个信号中是非常简单的！

现在来使用这个新信号。更新你在上一节中添加到 `viewDidLoad` 结尾的代码，如下所示：

```objc
// 外层是一个按钮触摸事件的信号
[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id _Nullable(__kindof UIControl * _Nullable value) {
        // 内层创建并返回了一个登录事件信号
        return [self signInSingal];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"Sign in result: %@", x);
    }];
```

上面的代码使用前面的 `map` 方法将按钮触摸信号转化为登录信号。用户只需将结果记录下来即可。

如果你编译并运行应用，然后点击登录按钮，再看看 Xcode 控制台，你会看到上面代码的结果......。

...... 结果并不像你想象的那样!

```bash
2020-12-25 14:39:37.575620+0800 RWReactivePlayground[28255:3143972] Sign in result: <RACDynamicSignal: 0x600001286e20> name:
```

没错， `subscribeNext:` 块已经被传递了一个信号，但并不是登录信号返回的结果!

是时候说明这个管道了，这样你就可以看到发生了什么：

![](https://koenig-media.raywenderlich.com/uploads/2014/01/SignalOfSignals.png)



当你点击按钮时，`rac_signalForControlEvents` 会发出 **next** 事件（以 `UIButton` 作为其事件数据源，也就是说，这是一个按钮点击信号的事件）。`map` 步骤创建并返回登录信号，这意味着下面的管道步骤现在收到了一个 `RACSignal`。这就是你在 `subscribeNext:` 步骤中观察到的情况。

> 注释：按钮点击信号的 next 事件返回了登录信号本身，而不是返回登录信号包含的事件内容。

上面的情况有时被称为*信号的信号*，换句话说，一个外在的信号，包含一个内在的信号。如果你真的想这样做，你可以在外部信号的 *subscribeNext:* 块中订阅内部信号。然而这将导致一个嵌套的混乱! 幸运的是，这是一个常见的问题，ReactiveCocoa 已经为这种情况做好了准备。

## 信号的信号

这个问题的解决方法很简单，只要将 `map` 步骤改为 `flattenMap` 步骤，如下所示：

```objc
// 通过 flattenMap 方法将按钮点击信号的事件转换为登录信号的事件
[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^id _Nullable(__kindof UIControl * _Nullable value) {
        return [self signInSingal];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"Sign in result: %@", x);
    }];
```

这样就可以像以前一样，把按钮点击信号的事件 `map` 到登录信号上，但同时也将事件从内侧信号发送到外侧信号上，使之扁平化。

编译并运行，并关注控制台。现在它应该会记录登录是否成功：

```objc
2020-12-25 14:52:41.374075+0800 RWReactivePlayground[28486:3156910] Sign in result: 1
2020-12-25 14:52:45.881490+0800 RWReactivePlayground[28486:3156910] Sign in result: 1
```

令人激动！

现在，管道正在做你想要的事情，最后一步是为 `subscribeNext` 步骤添加逻辑，以便在成功登录后执行所需的导航。将管道替换为以下内容：

```objc
[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^id _Nullable(__kindof UIControl * _Nullable value) {
        // 内层创建并返回了一个登录事件信号
        return [self signInSingal];
    }] subscribeNext:^(NSNumber *signIn) {
        // 登录成功，执行页面跳转逻辑
        BOOL success = signIn.boolValue;
        self.signInFailureText.hidden = success;
        if (success) {
            [self performSegueWithIdentifier:@"signInSuccess" sender:self];
        }
    }];
```

`subscribeNext:` 块从登录信号中获取结果，相应地更新 `signInFailureText` 文本字段的可见性，并在需要时执行导航切换。

编译并运行，再去享受一次小猫的乐趣吧! 喵!

![](https://koenig-media.raywenderlich.com/uploads/2014/01/ReactivePlaygroundStarter.jpg)

你是否注意到当前应用有一个小小的用户体验问题？当登录服务正在验证提供的凭证时，应该禁用登录按钮。这可以防止用户重复进行相同的登录。此外，如果发生了一次失败的登录尝试，当用户再次尝试登录时，应该隐藏错误信息。

但是应该如何将这个逻辑添加到当前的管道中呢？改变按钮的启用状态并不是一个转换、过滤器或任何其他你迄今为止遇到的概念。相反，它是所谓的 *side-effect*;；或者你想在 `next` 事件发生时在管道内执行的逻辑，但它实际上并没有改变事件本身的性质。

## 添加 side-effect

将目前的管道改为：

```objc
[[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
   doNext:^(__kindof UIControl *_Nullable x) { // 执行副作用（可用 RACCommand 来实现）
       self.signInButton.enabled = NO;
       self.signInFailureText.hidden = YES;
   }] flattenMap:^id _Nullable (__kindof UIControl *_Nullable value) {
       return [self signInSingal];
   }] subscribeNext:^(NSNumber *signIn) {
       self.signInButton.enabled = YES;
       BOOL success = signIn.boolValue;
       self.signInFailureText.hidden = success;
       if (success) {
           [self performSegueWithIdentifier:@"signInSuccess" sender:self];
       }
   }];
```

你可以看到上面是如何在按钮触摸事件创建后立即向管道中添加 `doNext:` 步骤的。请注意，`doNext:` 块并没有返回一个值，因为它是一个副作用；它让事件本身保持不变。

上面的 `doNext:` 块将按钮的启用属性设置为 `NO`，并隐藏了失败文本。而 `subscribeNext:` 块则重新启用按钮，并根据登录结果显示或隐藏失败文本。

现在是时候更新管道流图以包含这个副作用了。沐浴在它的光辉之中吧：

![](https://koenig-media.raywenderlich.com/uploads/2014/01/SideEffects.png)

编译并运行应用程序，以确认登录按钮按照预期的方式启用和禁用。

这样，你的工作就完成了--应用程序现在已经完全实现了响应式编程。Woot!

如果你在中途迷路了，你可以下载[最终项目](https://koenig-media.raywenderlich.com/uploads/2014/01/ReactivePlayground-Final.zip)（包括完整的依赖关系），或者你可以从 [GitHub](https://github.com/ColinEberhardt/RWReactivePlayground) 上获取代码，在 GitHub上的 commit 提交历史中，可以匹配本教程中的每个构建和运行步骤。

> **注意**：在一些异步活动进行时禁用按钮是一个常见的问题，ReactiveCocoa 再次对这个小问题进行了处理。RACCommand 封装了这个概念，并且有一个启用信号，允许你将按钮的启用属性连接到信号上。你可能想试试这个类。

## 总结

希望本教程能给你打下一个良好的基础，当你开始在自己的应用程序中使用 ReactiveCocoa 时，会对你有所帮助。习惯这些概念可能需要一点练习，但就像任何语言或程序一样，一旦你掌握了它的窍门，它就会变得非常简单。ReactiveCocoa 的核心是信号，它只不过是事件流。还有什么比这更简单的呢？

在 ReactiveCocoa 中，我发现了一个有趣的事情，那就是有很多方法可以解决同一个问题。你可能会想尝试这个应用程序，并调整信号和管道来改变它们的分割和组合方式。

值得考虑的是，ReactiveCocoa 的主要目标是让你的代码更干净，更容易理解。就我个人而言，我发现如果一个应用程序的逻辑被表示为清晰的管道，使用流畅的语法，那么就更容易理解它的工作方式。

在本系列教程的[第二部分](https://www.raywenderlich.com/?p=62796)，你将学习更高级的主题，如错误处理以及如何管理在不同线程上执行的代码。在此之前，祝你实验愉快!
