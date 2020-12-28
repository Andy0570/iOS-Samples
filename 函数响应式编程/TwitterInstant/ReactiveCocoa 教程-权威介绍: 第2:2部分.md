> 原文：[ReactiveCocoa Tutorial – The Definitive Introduction: Part 2/2](https://www.raywenderlich.com/2490-reactivecocoa-tutorial-the-definitive-introduction-part-2-2)

[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) 是一个允许你在 iOS 应用中使用函数响应式编程（FRP）技术的框架。通过 ReactiveCocoa 系列教程的[第一部分](https://www.raywenderlich.com/?p=62699)，你学会了如何用发出事件流的信号来替换标准的 action 动作和事件处理逻辑。你还学习了如何转换、分割和组合这些信号。

在这个系列的第二部分中，你将学习 ReactiveCocoa 更高级的功能。包括：

* 另外两个事件类型：**error** 和 **completed**
* Throttling（节流？）
* Threading（多线程）
* Continuations（延续？）
* ... 还有更多

是时候深入挖掘了！

## Twitter 实例

在整个教程中，你要开发的应用程序叫做 Twitter Instant（仿照 [Google Instant](http://www.google.co.uk/instant/) 的概念），这是一个 Twitter 搜索应用程序，可以在你输入时实时更新搜索结果。

这个应用程序的[初始化项目](https://koenig-media.raywenderlich.com/uploads/2014/01/TwitterInstant-Starter2.zip)包括基本的用户界面和一些你需要开始使用的普通代码。与第1部分一样，你需要使用 CocoaPods 来获取ReactiveCocoa 框架并将其集成到您的项目中。启动项目已经包含了必要的 Podfile，所以打开终端窗口并执行以下命令：

```bash
pod install
```

如果执行正确，你应该看到类似于下面的输出。

```bash
Analyzing dependencies
Downloading dependencies
Using ReactiveCocoa (2.1.8)
Generating Pods project
Integrating client project
```

这应该已经生成了一个 Xcode 工作空间，**TwitterInstant.xcworkspace**。在 Xcode 中打开它，确认它包含两个项目。

* **TwitterInstant**：这是你的应用程序逻辑所在的地方。
* **Pods**: 这是外部依赖的地方。目前它只包含 ReactiveCocoa。

编译并运行。下面的界面会迎接你：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm05jq4hblj30m80gojt7.jpg)

花点时间熟悉一下应用程序的代码。这是一个非常简单的基于 split view controller 的应用。左侧面板是 **RWSearchFormViewController**，它通过故事板添加了一些 UI 控件，搜索文本输入框连接到一个插座。右侧面板是 **RWSearchResultsViewController**，它目前只是一个 **UITableViewController** 子类。

如果你打开 **RWSearchFormViewController.m**，你可以看到 `viewDidLoad` 方法中获取了结果视图控制器，并将其赋值给私有属性 `resultsViewController` 。你的大部分应用逻辑将体现在 **RWSearchFormViewController** 中，这个属性将向 **RWSearchResultsViewController** 提供搜索结果。

## 验证搜索文本

你要做的第一件事是验证搜索文本，以确保它的长度大于两个字符。如果你完成了本系列的[第一部分](https://www.raywenderlich.com/?p=62699)，这应该是一个愉快的复习：

```objc
- (BOOL)isValidSearchText:(NSString *)text {
    return text.length > 2;
}
```

这只是确保输入的搜索字符串长度大于两个字符。有了这样简单的逻辑，你可能会问 "*为什么要在项目文件中单独设置一个方法？*"

目前的逻辑很简单。但如果将来需要更复杂的逻辑呢？通过上面的封装，你只会在一个地方进行修改。此外，上面的实现可以让你的代码更有表现力，它表明了你为什么要检查字符串的长度。我们都要遵循良好的编码实践，对吗？

在同一个文件的顶部，导入 ReactiveObjC：

```objc
#import <ReactiveObjC/ReactiveObjC.h>
```

在同一个文件中，在 `viewDidLoad` 的末尾添加以下内容：

```objc
[[self.searchText.rac_textSignal
  map:^id _Nullable (NSString *_Nullable value) {
      return [self isValidSearchText:value] ? UIColor.whiteColor : UIColor.yellowColor;
  }] subscribeNext:^(UIColor *color) {
      self.searchText.backgroundColor = color;
  }];
```

上面的代码具体的内容：

* 获取搜索文本输入框字段的文本信号。
* 将其转换为背景色，表示输入内容是否有效。
* 然后在 `subscribeNext:` 块中将信号传递过来的 UIColor 属性应用于输入框的 `backgroundColor` 属性。

编译并运行，观察当搜索输入框输入的字符串太短时，输入框是如何用黄色背景来表示输入内容无效的。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm073zplpaj30bq06cglw.jpg)

用流程图来说明，这个简单的响应式管道看起来有点像这样：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm08f0lq4jj30h303dglq.jpg)

每次输入内容发生变化时，`rac_textSignal` 信号都会触发包含当前文本字段文本的 `next` 事件。`map` 步骤将文本值转化为颜色，而 `subscribeNext:` 步骤则将这个值获取并应用到文本字段的背景上。

当然，你还记得第一篇文章中的内容吧？如果不记得的话，你可能要在这里停下来，至少读一遍以练习。

在添加 Twitter 搜索逻辑之前，还有几个有趣的话题要讲。

## 管道格式化

当你深入研究 ReactiveCocoa 代码的格式化时，普遍接受的惯例是让每个操作都在新的行上，并将所有的步骤垂直对齐。

在下一张图中，你可以看到一个更复杂的例子的对齐方式，这个例子取自于之前的教程：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm08net0jpj30fa06nab5.jpg)

这可以让你非常容易地看到组成管道的操作。另外，尽量减少每个 Block 块中的代码量；任何超过几行的代码都应该被分解成一个私有方法。

不幸的是，Xcode 并不喜欢这种格式化的风格，所以你可能会发现你自己在和它的自动缩进逻辑作斗争!

## 内存管理

考虑你添加到 TwitterInstant 应用中的代码，你是否想知道你刚刚创建的管道是如何保留的？当然，由于它没有被分配到变量或属性中，所以它的引用计数不会递增，注定要被销毁？

ReactiveCocoa 的设计目标之一就是允许这种编程风格，管道可以匿名形成。在你到目前为止所写的所有响应式代码中，这看起来应该是很直观的。

为了支持这种模式，ReactiveCocoa 维护并保留了自己的全局信号集。如果它有一个或多个订阅者，那么这个信号是活跃的。如果所有的订阅者都被移除，那么信号就会被取消分配。关于 ReactiveCocoa 如何管理这个过程的更多信息，请参见[内存管理](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/MemoryManagement.md)文档。

最后一个问题： 如何取消订阅一个信号？在 `completed` 或 `error` 事件后，订阅会自动移除（您将很快了解更多信息）。你也可以通过 `RACDisposable` 来实现手动删除信号。

`RACSignal` 上的订阅方法都会返回一个 `RACDisposable` 的实例，允许你通过 `dispose` 方法手动删除订阅。下面是一个使用当前管道的快速示例：

```objc
// 返回包含 UIColor 实例的信号
RACSignal *backgroundColorSignal = [self.searchText.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
    return [self isValidSearchText:value] ? UIColor.whiteColor : UIColor.yellowColor;
}];

// RACSignal 的订阅方法会返回一个 RACDisposable 的实例
RACDisposable *subscription = [backgroundColorSignal subscribeNext:^(UIColor *color) {
    self.searchText.backgroundColor = color;
}];

// 在未来的某个时刻，手动删除信号的订阅
[subscription dispose];
```

你会发现自己不可能经常这样做，但值得知道这种可能性的存在。

> **注意**：作为一个必然的结果，如果你创建了一个管道（信号）但没有订阅它，管道永远不会执行，也包括任何 `side-effects` 方法，如 `doNext:` 块。

## 避免引循环

虽然 ReactiveCocoa 在幕后做了很多聪明的事情——这意味着你不用太担心信号的内存管理，但有一个重要的与内存相关问题你确实需要考虑。

如果你查看你刚刚添加的响应式代码：

```objc
[[self.searchText.rac_textSignal
  map:^id _Nullable (NSString *_Nullable value) {
      return [self isValidSearchText:value] ? UIColor.whiteColor : UIColor.yellowColor;
  }] subscribeNext:^(UIColor *color) {
      self.searchText.backgroundColor = color;
  }];
```

subscribeNext: 块使用 `self` 来获取对文本输入框的引用。Block 会捕获并保留闭包中的值，因此，如果 `self` 和这个信号之间存在强引用，将导致引用循环问题。这是否重要取决于 `self` 对象的生命周期。如果它的生命周期是应用程序的持续时间，就像这里的情况一样，这并不重要。但在更复杂的应用中，这种情况很少。

为了避免这种潜在的引用循环问题，Apple 的 [Working With Blocks](https://developer.apple.com/library/ios/documentation/cocoa/conceptual/ProgrammingWithObjectiveC/WorkingwithBlocks/WorkingwithBlocks.html#//apple_ref/doc/uid/TP40011210-CH8-SW16) 文档建议捕获一个弱引用到 `self`。在当前的代码中，你可以通过以下方式实现：

```objc
__weak RWSearchFormViewController *weakSelf = self; // 捕获弱引用

[[self.searchText.rac_textSignal
  map:^id _Nullable (NSString *_Nullable value) {
      return [self isValidSearchText:value] ? UIColor.whiteColor : UIColor.yellowColor;
  }] subscribeNext:^(UIColor *color) {
      weakSelf.searchText.backgroundColor = color;
  }];
```

以上代码中，`weakSelf` 是对 `self` 的引用，为了使它成为一个弱引用，它被标记为 `__weak`。请注意，`subscribeNext:` 块现在使用了 `weakSelf` 变量。这看起来不是很优雅!

ReactiveCocoa 框架中包含了一个小技巧，你可以用它来代替上面的代码。在文件的顶部添加以下导入：

```objc
#import "RACEXTScope.h"
```

然后用下面的代码代替上面的代码：

```objc
@weakify(self)
[[self.searchText.rac_textSignal
  map:^id _Nullable (NSString *_Nullable value) {
      return [self isValidSearchText:value] ? UIColor.whiteColor : UIColor.yellowColor;
  }] subscribeNext:^(UIColor *color) {
      @strongify(self)
      self.searchText.backgroundColor = color;
  }];
```

上面的 `@weakify` 和 `@strongify` 语句是在 [Extended Objective-C](https://github.com/jspahrsummers/libextobjc) 库中定义的宏，它们也包含在 ReactiveCocoa 中。`@weakify` 宏允许你创建影子变量（*shadow* variables），也就是弱引用（如果你需要多个弱引用，可以传递多个变量），`@strongify` 宏允许你对之前传递给 `@weakify` 的变量创建强引用。

> **注意**：如果你有兴趣了解 `@weakify` 和 `@strongify` 的实际作用，在 Xcode 中选择 **Product** -> **Perform Action** -> **Preprocess** "**RWSearchForViewController**"。这将对视图控制器进行预处理，展开所有的宏，并允许你看到最终的输出。

最后需要注意的是，在 Block 块中使用实例变量时要小心。这些也会导致 Block 块捕捉到对 `self` 的强引用。如果是你的代码导致这个问题，你可以打开编译器警告来提醒你。在项目的构建设置中搜索 *retain*，可以找到下面的选项：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm0acu1jfhj30j408b757.jpg)

好了，你从理论知识中幸存下来了，恭喜你！现在你聪明多了，准备好进入有趣的部分：为你的应用程序添加一些真正的功能。

> **注**：关注过上一篇教程的敏锐读者无疑会注意到，通过利用 `RAC` 宏，你可以在当前管道中取消对 `subscribeNext:` 块的调用。如果你发现了这一点，请做出这样的改变，并为自己颁发一颗闪亮的金星!

```objc
// 通过 RAC 宏实现：将信号的输出分配给 self.searchText 对象的 backgroundColor 属性
RAC(self.searchText, backgroundColor) = [self.searchText.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
    return [self isValidSearchText:value] ? UIColor.whiteColor : UIColor.yellowColor;
}];
```

## 请求访问 Twitter

你将使用 **Social Framework** 来允许 TwitterInstant 应用程序搜索 Tweets，并使用 **Accounts Framework** 来授予对 Twitter 的访问权。要想更详细地了解 **Social Framework**，请查看 [iOS 6 教程](https://www.raywenderlich.com/?page_id=19968) 中专门为这个框架编写的章节。

在添加代码之前，你需要将你的 Twitter 凭证输入到模拟器或你正在运行这款应用的 iPad 上。打开 **Settings** 应用，选择 **Twitter** 菜单选项，然后在屏幕右侧添加你的凭证：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm13fgfs1uj30m80gomyj.jpg)

初始化项目已经添加了所需的框架，所以你只需要导入头文件。在 **RWSearchFormViewController.m** 文件中，在文件的顶部添加以下代码：

```objc
#import <Accounts/Accounts.h>
#import <Social/Social.h>
```

在 `import` 语句的下面添加以下枚举和常量：

```swift
typedef NS_ENUM(NSUInteger, RWTwitterInstantError) {
    RWTwitterInstantErrorAccessDenied,
    RWTwitterInstantErrorNoTwitterAccounts,
    RWTwitterInstantErrorInvalidResponse,
};

static NSString *const RWTwitterInstantDomain = @"TwitterInstant";
```

你将很快使用它们来识别错误。在同一个文件的下面，在现有属性声明的下面，添加以下内容:

```objc
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *twitterAccountType;
```

`ACAccountsStore` 类提供了通过设备连接到各种社交媒体账户的访问，而 `ACAccountType` 类则代表了一种特定的账户类型。

在同一个文件中再往下，在 `viewDidLoad` 的末尾添加以下内容：

```objc
self.accountStore = [[ACAccountStore alloc] init];
// Deprecated，该功能似乎已经失效！头文件中建议使用 Twitter SDK 实现
self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
```

这将创建账户管理器（account store）和 Twitter 账户标识符。

当一个应用程序请求访问一个社交媒体账户时，用户会看到一个弹出窗口。这是一个异步操作，因此它是一个很好的信号包装的候选者，以便响应式地使用它。

在同一个文件中，再往下添加以下方法：

```objc
- (RACSignal *)requestAccessToTwitterSignal {
    // 1. 定义一个错误
    NSError *accessError = [NSError errorWithDomain:RWTwitterInstantDomain code:RWTwitterInstantErrorAccessDenied userInfo:nil];
    
    // 2. 创建一个信号
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        // 3. 请求访问 Twitter
        @strongify(self)
        [self.accountStore requestAccessToAccountsWithType:self.twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
            
            // 4. 处理请求响应
            if (!granted) {
                [subscriber sendError:accessError];
            } else {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}
```

这个方法的作用如下：

1. 定义了一个错误，如果用户拒绝访问，就会发送错误。
2. 参考教程一，类方法 `createSignal` 返回了一个 `RACSignal` 的实例。
3. 通过账户管理器请求访问 Twitter。此时，用户会看到一个提示，要求他们授予这个应用对其 Twitter 账户的访问权。
4. 在用户授予或拒绝访问后，就会发出信号事件。如果用户授予访问权，则会发出 **next** 事件，然后是 **completed** 事件。如果用户拒绝访问，则会发出 **error** 事件。

如果你还记得我们的第一篇教程，一个信号可以发出三种不同的事件类型：

* Next
* Completed
* Error

在一个信号的生命周期中，它可能不发出任何事件，一个或多个 **next** 事件，然后紧接着是一个 **completed** 事件或一个 **error** 事件。

最后，为了利用这个信号，在 `viewDidLoad` 方法的结尾添加以下内容：

```objc
[self requestAccessToTwitterSignal] subscribeNext:^(id  _Nullable x) {
    NSLog(@"Access granted");
} error:^(NSError * _Nullable error) {
    NSLog(@"An error occurred: %@", error);
};
```

如果你编译并运行应用，应该会有以下提示：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm17s8m3akj30m80go40h.jpg)

如果你点击 **OK**，则应在控制台中出现 `subscribeNext:` 块中的日志信息，而如果你点击 **Don't Allow**，则会执行 error Block 块并记录相应的信息。

账户框架会记住你所做的决定。因此，如果要测试这两种不同的选择，你需要通过 iOS 模拟器->重置内容和设置......菜单选项来重置模拟器。这个过程有点痛苦，因为你还必须重新输入你的 Twitter 账户凭证!

## 链接信号

一旦用户同意了（希望如此）应用对其 Twitter 账户的访问权限，应用程序就需要持续监控搜索文本字段的变化，以便查询 twitter。

应用程序需要等待请求访问用户 Twitter 的信号发出 **completed** 事件，然后订阅文本字段的信号。不同信号的顺序链是一个常见的问题，但 ReactiveCocoa 处理得非常优雅。

在 `viewDidLoad` 的结尾处用以下内容替换你当前的管道：

```objc
[[[self requestAccessToTwitterSignal]
  then:^RACSignal * _Nonnull{
    @strongify(self)
    return self.searchText.rac_textSignal;
}] subscribeNext:^(id  _Nullable x) {
    NSLog(@"Access granted");
} error:^(NSError * _Nullable error) {
    NSLog(@"An error occurred: %@", error);
}];
```

`then` 方法等到一个 **completed** 事件发出后，再订阅其 Block 块参数重返回的信号。这就有效地将控制权从一个信号传递到下一个信号。

> **注意**：你已经在为位于这个管道上方的管道中弱化了 `self`，所以没有必要在这个管道之前使用 `@weakify(self)`。

`then` 方法也会将 **error** 事件传递过去。因此，最后的 `subscribeNext:error:` 块仍然会接收初始访问请求步骤发出的错误。

当你编译并运行应用，然后授予访问权时，你应该看到你输入到搜索字段的文本记录在控制台中：

```bash
2014-01-04 08:16:11.444 TwitterInstant[39118:a0b] m
2014-01-04 08:16:12.276 TwitterInstant[39118:a0b] ma
2014-01-04 08:16:12.413 TwitterInstant[39118:a0b] mag
2014-01-04 08:16:12.548 TwitterInstant[39118:a0b] magi
2014-01-04 08:16:12.628 TwitterInstant[39118:a0b] magic
2014-01-04 08:16:13.172 TwitterInstant[39118:a0b] magic!
```

接下来，在管道中添加一个 `filter` 过滤操作，以删除任何无效的搜索字符串。在本例中，它们是由少于三个字符组成的字符串：

```objc
[[[[self requestAccessToTwitterSignal]
  then:^RACSignal * _Nonnull{
    @strongify(self)
    return self.searchText.rac_textSignal;
}] filter:^BOOL(id  _Nullable value) {
    @strongify(self)
    return [self isValidSearchText:value];
}] subscribeNext:^(id  _Nullable x) {
    NSLog(@"Access granted");
} error:^(NSError * _Nullable error) {
    NSLog(@"An error occurred: %@", error);
}];
```

编译并再次运行，观察过滤的运行情况：

```objc
2014-01-04 08:16:12.548 TwitterInstant[39118:a0b] magi
2014-01-04 08:16:12.628 TwitterInstant[39118:a0b] magic
2014-01-04 08:16:13.172 TwitterInstant[39118:a0b] magic!
```

用图形化的方式来说明当前的应用管道，它是这样的：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm18b2re3kj30j704iaai.jpg)

应用流水线从 `requestAccessToTwitterSignal` 开始，然后切换到 `rac_textSignal`。同时，**next** 事件通过过滤器，最后进入订阅Block 块。你还可以看到第一步发出的任何错误事件都会被同一个 `subscribeNext:error:` 块所消耗。

现在，你已经有了一个发出搜索文本的信号，是时候用它来搜索 Twitter了! 你玩得开心吗？你应该是的，因为现在你真的有收获了。

## 搜索 Twitter

**Social Framework** 是访问 Twitter 搜索 API 的一个选项。然而，正如你所预料的那样，**Social Framewor**k 并不是响应式的! 下一步是将所需的 API 方法调用包裹在一个信号中。你现在应该已经掌握了这个过程的窍门了!

在 **RWSearchFormViewController.m** 中，添加以下方法：

```objc
- (SLRequest *)requestforTwitterSearchWithText:(NSString *)text {
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary *params = @{@"q":text};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
    return request;
}
```

这将创建一个通过 [v1.1 REST API](https://dev.twitter.com/docs/api/1.1) 搜索 Twitter 的请求。上面的代码使用 `q` 搜索参数来搜索包含给定搜索字符串的推文。你可以在 [T witter API](https://dev.twitter.com/docs/api/1.1/get/search/tweets) 文档中阅读更多关于这个搜索API，以及其他你可以传递的参数。

下一步是根据这个请求创建一个信号。在同一个文件中，添加以下方法：

```objc
- (RACSignal *)signalForSearchWithText:(NSString *)text {
    // 1. 定义错误
    NSError *noAccountsError = [NSError errorWithDomain:RWTwitterInstantDomain code:RWTwitterInstantErrorNoTwitterAccounts userInfo:nil];
    NSError *invalidResponseError = [NSError errorWithDomain:RWTwitterInstantDomain code:RWTwitterInstantErrorInvalidResponse userInfo:nil];
    
    // 2. 创建信号 block
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        
        // 3.创建请求
        SLRequest *request = [self requestforTwitterSearchWithText:text];
        
        // 4.请求 twitter 账户
        NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:self.twitterAccountType];
        if (twitterAccounts.count == 0) {
            [subscriber sendError:noAccountsError];
        } else {
            [request setAccount:twitterAccounts.lastObject];
            
            // 5. 执行请求
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (urlResponse.statusCode == 200) {
                    
                    // 6. 一旦请求成功，解析响应
                    NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    [subscriber sendNext:timelineData];
                    [subscriber sendCompleted];
                } else {
                    // 7. 发送请求失败的错误信号
                    [subscriber sendError:invalidResponseError];
                }
            }];
        }
        
        return nil;
    }];
}
```

依次进行每一步：

1. 起初，你需要定义几个不同的错误，一个表示用户没有在他们的设备上添加任何 Twitter 账户， 另一个表示在执行查询时出错。
2. 和之前一样，创建一个信号。
3. 使用你在上一步添加的方法为给定的搜索字符串创建一个请求。
4. 查询账户商店，找到第一个可用的 Twitter 账户。如果没有给定账户，则会发出一个错误。
5. 执行该请求。
6. 在响应成功的情况下（*HTTP 响应状态码 200*），返回的 JSON 数据将被解析并作为 **next** 事件一起发出，随后是一个 **completed** 事件。
7. 如果是不成功的响应，则会发出一个 **error** 事件。

现在要把这个新信号用起来了!

在本教程的第一部分，你学习了如何使用 `flattenMap` 将每个 **next** 事件 map 转移到一个新的信号上，然后再订阅。现在是时候再次使用这个信号了。在 `viewDidLoad` 的结尾处，通过在结尾处添加一个 `flattenMap` 步骤来更新你的应用管道：

```objc
[[[[[self requestAccessToTwitterSignal]
  then:^RACSignal * _Nonnull{
    @strongify(self)
    return self.searchText.rac_textSignal;
}] filter:^BOOL(id  _Nullable value) {
    @strongify(self)
    return [self isValidSearchText:value];
}] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
    @strongify(self)
    return [self signalForSearchWithText:value];
}] subscribeNext:^(id  _Nullable x) {
    NSLog(@"Access granted");
} error:^(NSError * _Nullable error) {
    NSLog(@"An error occurred: %@", error);
}];
```

编译并运行，然后在搜索文本字段中输入一些文本。一旦文本至少有三个字符或更多的长度，你应该在控制台窗口中看到 Twitter 搜索的结果。 

下面显示的只是你将看到的数据种类的一个片段：

```bash
2014-01-05 07:42:27.697 TwitterInstant[40308:5403] {
    "search_metadata" =     {
        "completed_in" = "0.019";
        count = 15;
        "max_id" = 419735546840117248;
        "max_id_str" = 419735546840117248;
        "next_results" = "?max_id=419734921599787007&q=asd&include_entities=1";
        query = asd;
        "refresh_url" = "?since_id=419735546840117248&q=asd&include_entities=1";
        "since_id" = 0;
        "since_id_str" = 0;
    };
    statuses =     (
                {
            contributors = "<null>";
            coordinates = "<null>";
            "created_at" = "Sun Jan 05 07:42:07 +0000 2014";
            entities =             {
                hashtags = ...
```

`signalForSearchText:` 方法也会发出错误事件，`subscribeNext:error:` 块会消耗这些错误事件。你可以相信我的话，但你可能想测试一下!

在模拟器内打开 **Settings** 应用，选择你的 Twitter 账户，然后点击 **Delete Account** 按钮删除它。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm197gebarj30m80goq5m.jpg)

如果你重新运行应用程序，它仍然被允许访问用户的 Twitter 账户，但没有账户可用。因此，`signalForSearchText` 方法会发出一个错误，并被记录下来：

```bash
2014-01-05 07:52:11.705 TwitterInstant[41374:1403] An error occurred: Error 
  Domain=TwitterInstant Code=1 "The operation couldn’t be completed. (TwitterInstant error 1.)"
```

`Code=1` 表示这是 `RWTwitterInstantErrorNoTwitterAccounts` 错误。在生产应用中，你会希望打开错误代码，做一些更有意义的事情，而不仅仅是记录结果。

这说明了关于 **error** 事件的一个重要观点，只要一个信号发出错误，它就会直接跳到错误处理 Block 块。这是一个特殊的流程。

> **注**：当 Twitter 请求返回错误时，可以去行使另一个特殊流程。这里有一个快速提示，尝试将请求参数改为无效的东西!

## 线程

我相信你一定心痒难耐，想把 Twitter 搜索返回的 JSON 数据输出并显示到 UI 中，但在这之前，你还需要做最后一件事。要知道这是什么，你需要做一些探索!

在下面指定的位置为 `subscribeNext:error:` 步骤添加一个断点：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm19cmqo3wj30e30810ua.jpg)

重新运行应用程序，如果需要的话，再次重新输入你的 Twitter 证书，然后在搜索栏中输入一些文本。当断点到达时，你应该看到类似下图的东西：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm19ddbjrvj30i909yn0c.jpg)

请注意，调试器打出中断的代码并没有在主线程上执行，主线程在上面的截图中显示为 **Thread 1**。请记住，最重要的是你只从主线程更新 UI，因此如果你想在 UI 中显示推文列表，你就必须切换线程。

这说明了关于 ReactiveCocoa 框架的一个重要观点。上图所示的操作会在信号最初发出事件的线程上执行。试着在其他管道步骤处添加断点，你可能会惊讶地发现它们在多个不同的线程上执行!

那么你如何去更新 UI 呢？典型的方法是使用操作队列(详见本站其他地方的教程[如何使用 NSOperations 和 NSOperationQueues](https://www.raywenderlich.com/?p=19788))，然而 ReactiveCocoa 有一个更简单的解决方案来解决这个问题。

更新你的管道，在 `flattenMap:` 之后添加一个 `deliveryOn:` 操作，如下所示：

```objc
[[[[[[self requestAccessToTwitterSignal]
  then:^RACSignal * _Nonnull{
    @strongify(self)
    return self.searchText.rac_textSignal;
}] filter:^BOOL(id  _Nullable value) {
    @strongify(self)
    return [self isValidSearchText:value];
}] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
    @strongify(self)
    return [self signalForSearchWithText:value];
}] deliverOn:[RACScheduler mainThreadScheduler]]
 subscribeNext:^(id  _Nullable x) {
    NSLog(@"Access granted");
} error:^(NSError * _Nullable error) {
    NSLog(@"An error occurred: %@", error);
}];
```

现在重新运行应用程序，并输入一些文本，使您的应用程序击中断点。你应该看到你的 `subscribeNext:error:` 块中的日志语句现在正在主线程上执行：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm19k4h3cyj30ii07ajts.jpg)

啥玩意儿？只需一个简单的操作，就能把事件的流向汇集到不同的线程上？这有多厉害！？

你可以放心地继续更新你的 UI 了!

> **注意**：如果你看一下 `RACScheduler` 类，你会发现有相当多的选项可以在不同优先级的线程上交付，或者在管道中添加延迟。

是时候看看那些推特了！

## 更新 UI

如果你打开 `RWSearchResultsViewController.h`，你会发现它已经有一个 `displayTweets:` 方法，它将使右侧视图控制器渲染提供的推文数组。实现非常简单，它只是一个标准的 `UITableView` 数据源。`displayTweets:` 方法的单一参数期望一个包含 `RWTweet` 实例的 `NSArray`。你还会发现 `RWTweet` 模型对象是作为启动项目的一部分提供的。

目前到达 `subscibeNext:error:` 步骤的数据是一个 `NSDictionary`，它是通过在 `signalForSearchWithText:` 方法中解析 JSON 响应而构建的。那么如何确定这个字典的内容呢？

如果你看一下 [Twitter API 文档](https://dev.twitter.com/docs/api/1.1/get/search/tweets)，你可以看到一个样本响应。`NSDictionary` 镜像了这个结构，所以你应该会发现它有一个名为 `status` 的键，它是一个 `NSArray` 的 `tweets`，也是 `NSDictionary` 实例。

如果你看一下 `RWTweet`，它已经有一个类方法 `tweetWithStatus:` 它接收一个给定格式的 `NSDictionary`，并提取所需数据。所以，你需要做的就是写一个 `for` 循环，然后在数组中迭代，为每一条 `tweet` 创建一个 `RWTweet` 实例。

然而，你不会这么做的! 哦，不，还有更好的东西在等着你呢!

本文介绍的是 ReactiveCocoa 和函数式编程。当你使用函数式 API 时，将数据从一种格式转换为另一种格式会更加优雅。你将使用[LinqToObjectiveC](https://github.com/ColinEberhardt/LinqToObjectiveC) 来执行这个任务。

关闭 TwitterInstant 工作区，然后在 TextEdit 中打开在第一个教程中创建的 Podfile。更新文件以添加新的依赖关系：

```ruby
# 指明依赖库的来源地址，不使用默认 CDN
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'

target 'TwitterInstant' do
  pod 'ReactiveObjC', '~> 3.1.1'
  pod 'LinqToObjectiveC', '~> 2.1.0'
end
```

在同一文件夹中打开终端窗口，并发出以下命令：

```bash
pod update
```

您将看到类似于以下内容的输出：

```bash
Analyzing dependencies
Downloading dependencies
Installing LinqToObjectiveC (2.1.0)
Generating Pods project
Integrating client project
Pod installation complete! There are 2 dependencies from the Podfile and 2 total pods installed.
```

重新打开 Xcode workspace，验证新的 pod 是否显示，如下图所示：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm19xy3taoj307d098gmg.jpg)

打开 `RWSearchFormViewController.m`，并在文件顶部添加以下 import 代码：

```objc
#import "RWTweet.h"
#import <NSArray+LinqExtensions.h>
```

`NSArray+LinqExtensions.h` 头文件来自 `LinqToObjectiveC`，它为 `NSArray` 添加了许多方法，允许你使用流畅的 API 对其数据进行转换、排序、分组和过滤。

现在要把这个 API 用起来......在 `viewDidLoad` 结尾处更新当前管道，如下所示：

```objc
[[[[[[self requestAccessToTwitterSignal]
  then:^RACSignal * _Nonnull{
    @strongify(self)
    return self.searchText.rac_textSignal;
}] filter:^BOOL(id  _Nullable value) {
    @strongify(self)
    return [self isValidSearchText:value];
}] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
    @strongify(self)
    return [self signalForSearchWithText:value];
}] deliverOn:[RACScheduler mainThreadScheduler]]
 subscribeNext:^(NSDictionary *jsonSearchResult) {
    NSArray *statuses = jsonSearchResult[@"statuses"];
    NSArray *tweets = [statuses linq_select:^id(id tweet) {
        return [RWTweet tweetWithStatus:tweet];
    }];
    [self.resultsViewController displayTweets:tweets];
} error:^(NSError * _Nullable error) {
    NSLog(@"An error occurred: %@", error);
}];
```

如上所示，`subscribeNext:` 块首先获取推文的 `NSArray`。`linq_select` 方法通过在每个数组元素上执行所提供的 Block 块来转换`NSDictionary` 实例数组，从而得到一个 `RWTweet` 实例数组。

一旦转换完毕，推文就会被发送到结果视图控制器。

构建并运行，最终可以看到推文出现在 UI 中。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm1a3w1l7xj30mr0h242u.jpg)

> 注：ReactiveCocoa 和 LinqToObjectiveC 的灵感来源相似。ReactiveCocoa 是以微软的 [Reactive Extensions](http://msdn.microsoft.com/en-gb/data/gg577609.aspx) 库为蓝本，而 LinqToObjectiveC 则是以他们的语言集成查询 API，或者 LINQ，特别是 [Linq to Objects](http://msdn.microsoft.com/en-us/library/bb397919.aspx) 为蓝本。

## 异步加载图片

你可能已经注意到了，每条推特的左边都有一个空隙。这个空间是用来显示 Twitter 用户的头像的。

`RWTweet` 类已经有一个 `profileImageUrl` 属性，该属性被填充了一个合适的 `URL` 来获取这个图片。为了使表格视图能够顺利滚动，你需要确保从给定的 `URL` 中获取这张图片的代码不在主线程上执行。这可以使用 Grand Central Dispatch 或 NSOperationQueue 来实现。但为什么不使用 ReactiveCocoa 呢？

打开 **RWSearchResultsViewController.m**，在文件末尾添加以下方法：

```objc
// 异步加载图片
- (RACSignal *)signalForLoadingImage:(NSString *)imageUrl {
    RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
    
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        [subscriber sendNext:image];
        [subscriber sendCompleted];
        return nil;
    }] subscribeOn:scheduler];
}
```

现在你应该对这个模式很熟悉了吧!

上面的方法首先获得一个后台调度器，因为你希望这个信号在主线程以外的线程上执行。接下来，它创建了一个下载图像数据的信号，并在有订阅者时创建一个 `UIImage`。最后一个魔法是 `subscribeOn:`，它确保信号在给定的调度器上执行。

神奇!

现在，在同一个文件中，更新 `tableView:cellForRowAtIndex:` 方法，在 `return` 语句前添加以下内容：

```objc
cell.twitterAvatarView.image = nil;

[[[self signalForLoadingImage:tweet.profileImageUrl]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(UIImage *image) {
        cell.twitterAvatarView.image = image;
    }];
```

首先首先重置图像，因为这些单元格是重复使用的，因此可能包含陈旧的数据。然后创建所需的信号来获取图像数据。你之前遇到的 `deliverOn:`  管道步骤，将 **next** 事件调度到主线程上执行，这样 `subscribeNext:` 块就可以安全执行了。

很好，很简单！

构建并运行，看看头像现在是否能正确显示：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm1aixg7v5j30mr0h2q89.jpg)

## 节流（Throtting）

你可能已经注意到，每当你输入一个新的字符，Twitter 搜索就会立即执行。如果你是一个快速打字的人（或者干脆按住删除键），这可能会导致应用程序一秒钟执行几次搜索。这并不理想，原因有以下几点：首先，你在敲打 Twitter 搜索API，同时也丢掉了大部分搜索结果。第二，你在不断地更新结果，这对用户来说是相当分心的。

一个更好的方法是，只有在搜索文本在短时间内没有变化的情况下才执行搜索，比如 500 毫秒。

你可能已经猜到了，ReactiveCocoa 让这个任务变得非常简单!

打开 **RWSearchFormViewController.m**，在 `viewDidLoad` 结尾处更新管道，在 `filter` 过滤器之后添加一个 `throttle` 步骤：

```objc
[[[[[[[self requestAccessToTwitterSignal]
  then:^RACSignal * _Nonnull{
    @strongify(self)
    return self.searchText.rac_textSignal;
}] filter:^BOOL(id  _Nullable value) {
    @strongify(self)
    return [self isValidSearchText:value];
}] throttle:0.5]
   flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
    @strongify(self)
    return [self signalForSearchWithText:value];
}] deliverOn:[RACScheduler mainThreadScheduler]]
 subscribeNext:^(NSDictionary *jsonSearchResult) {
    NSArray *statuses = jsonSearchResult[@"statuses"];
    NSArray *tweets = [statuses linq_select:^id(id tweet) {
        return [RWTweet tweetWithStatus:tweet];
    }];
    [self.resultsViewController displayTweets:tweets];
} error:^(NSError * _Nullable error) {
    NSLog(@"An error occurred: %@", error);
}];
```

只有在给定的时间段内没有收到另一个下一个事件时，节流操作才会发送下一个事件。真的就这么简单!

构建并运行确认，只有当你停止输入时长超过 500 毫秒时，搜索结果才会更新。感觉好多了不是吗？你的用户也会这么认为。

而且......有了最后一步，你的 Twitter 即时应用就完成了。给自己拍拍背，跳个快乐的舞蹈吧。

如果你在教程中的某个地方迷失了，你可以下载[最终项目](https://koenig-media.raywenderlich.com/uploads/2014/01/TwitterInstant-Final.zip)（别忘了在打开之前从项目的目录中运行 `pod install`），或者你可以从[GitHub](https://github.com/ColinEberhardt/RWTwitterInstant)上获取代码，在 GitHub 上，本教程中的每个构建和运行步骤都有一个提交。

## 总结

在出发享受一杯胜利咖啡之前，有必要欣赏一下最后的应用程序流水线：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gm1aoo4ix4j30j2099jsb.jpg)

这是相当复杂的数据流，都简明扼要地表达为一条响应式管道。这真是一道美丽的风景线! 你能想象，如果使用非响应式技术，这个应用会有多复杂吗？而要看到这样的应用中的数据流又会有多难呢？听起来非常繁琐，现在你再也不用走这条路了!

现在你知道 ReactiveCocoa 真的相当厉害了吧!

最后一点，ReactiveCocoa 使得使用 Model View ViewModel，也就是 [MVVM 设计模式](http://en.wikipedia.org/wiki/Model_View_ViewModel)成为可能，它可以更好地分离应用逻辑和视图逻辑。如果有人对关于 MVVM 与 ReactiveCocoa 的后续文章感兴趣，请在评论中告诉我。我很想听听你的想法和经验!

