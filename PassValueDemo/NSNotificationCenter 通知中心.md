# 1.29 通过 NSNotificationCenter 发送通知


## 问题

你想在你的应用程序中广播一个事件，并允许任何愿意收听的对象（取决于广播的通知）采取行动。


## 解决方案

使用默认的通知中心 `NSNotificationCenter`  的 `postNotificationName:object:userInfo:` 方法来发布一个通知，该通知携带一个对象（通常是发布通知的对象）和一个用户信息字典，该字典可以携带关于通知和/或发布通知的对象的额外信息。



## 讨论

通知中心是通知对象的调度中心。例如，当用户在你的应用程序内的任何地方弹出键盘时，iOS 会向你的应用程序发送一个通知。你的应用程序中任何愿意收听此通知的对象都可以将自己添加到默认的通知中心，作为该特定通知的观察者。一旦你的对象的生命周期结束，它必须从通知中心的调度表中删除自己。因此，通知是一条通过通知中心广播给观察者的消息。

通知中心是 `NSNotificationCenter` 类型的一个实例。我们使用 `NSNotificationCenter` 的类方法 `defaultCenter` 来获取系统默认的通知中心对象。

通知是 `NSNotification` 类型的对象。一个通知对象有一个名字（指定为 `NSString` 类型），并且可以携带两个关键信息：

> 备注
>
> 你可以指定你的通知的名称。你不需要为此使用 API。只要确保你的通知名称是唯一的，不会与系统通知发生冲突。

* Sender Object

  这是发布通知的对象的实例。观察者可以使用 `NSNotification` 类的对象实例方法访问这个对象。

* User-Info Dictionary

  这是一个（发送者对象可以创建并与通知对象一起发送的）可选的字典。这个字典通常包含关于通知的更多信息。例如，当你的应用程序内的任何组件的键盘即将在 iOS 中得到显示时，iOS 会将 `UIKeyboardWillShowNotification` 通知发送到默认的通知中心。这个通知的用户信息字典中包含了一些值，例如动画前后的键盘矩形以及键盘的动画持续时间。利用这些数据，观察者可以做出决定，例如，一旦键盘显示在屏幕上，该如何处理可能会被阻挡的 UI 组件。



> 警告
>
> 通知是实现代码解耦的一个好方法。我的意思是，使用通知，你可以摆脱完成处理程序（completion handlers）和委托（delegation）。然而，关于通知有一个潜在的注意事项：它们不会被立即交付。它们是由通知中心派发的，而 NSNotificationCenter 的默认实现对应用程序的程序员是隐藏的。传递有时可能会延迟几毫秒，或者在极端情况下（我从未遇到过），延迟几秒钟。因此，应该由你来决定在哪里使用通知，在哪里不使用通知。



为了构造一个 `NSNotification` 类型的通知，需要使用 `NSNotification` 的 `notificationWithName:object:userInfo:` 类方法，我们很快会看到了。

> 备注
>
> 最好使用 Notification 这个单词来作为你的通知名称的后缀。例如，你当然可以给你的通知起一个类似 `ResultOfAppendingTwoStrings` 的名字。不过最好是起一个像 `ResultOfAppendingTwoStringsNotification` 这样的名字，因为它清楚地表明了这个名字的归属。

让我们来看一个例子。我们将简单地取一个名字和一个姓氏，将它们拼接来创建一个字符串（名字+姓氏），然后使用默认的通知中心广播这个结果。我们将在用户启动我们的应用时，在我们的应用委托的实现中完成这一工作：

```objc
#import "AppDelegate.h"

@implementation AppDelegate

/* The notification name */
const NSString *ResultOfAppendingTwoStringsNotification =
                @"ResultOfAppendingTwoStringsNotification";

/* Keys inside the dictionary that our notification sends */
const NSString
  *ResultOfAppendingTwoStringsFirstStringInfoKey = @"firstString";

const NSString
  *ResultOfAppendingTwoStringsSecondStringInfoKey = @"secondString";

const NSString
  *ResultOfAppendingTwoStringsResultStringInfoKey = @"resultString";

- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

  NSString *firstName = @"Anthony";
  NSString *lastName = @"Robbins";
  NSString *fullName = [firstName stringByAppendingString:lastName];

  NSArray *objects = [[NSArray alloc] initWithObjects:
                      firstName,
                      lastName,
                      fullName,
                      nil];

  NSArray *keys = [[NSArray alloc] initWithObjects:
                   ResultOfAppendingTwoStringsFirstStringInfoKey,
                   ResultOfAppendingTwoStringsSecondStringInfoKey,
                   ResultOfAppendingTwoStringsResultStringInfoKey,
                   nil];

  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:objects
                                                         forKeys:keys];

  NSNotification *notificationObject =
  [NSNotification
   notificationWithName:(NSString *)ResultOfAppendingTwoStringsNotification
   object:self
   userInfo:userInfo];

  [[NSNotificationCenter defaultCenter] postNotification:notificationObject];

  self.window = [[UIWindow alloc] initWithFrame:
                 [[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}
```



当然，你不必为每一个你想广播的通知指定一个对象或一个用户信息字典。但是，如果你和一个团队的开发人员在同一个应用程序上工作，或者你正在编写一个静态库，我建议你完整地记录你的通知，并清楚地指出你的通知是否携带一个对象和/或一个用户信息字典。如果有，你必须说明每个通知携带什么对象，以及用户信息字典里有什么键和值。如果你不打算发送对象或用户信息字典，那么我建议你使用 `NSNotificationCenter` 的实例方法 `postNotificationName:object:` 。指定一个代表你的通知名称的字符串作为第一个参数，第二个参数是 `nil`，它是应该与通知一起被携带的对象。下面是一个例子：

```objc
#import "AppDelegate.h"

@implementation AppDelegate

/* The notification name */
const NSString *NetworkConnectivityWasFoundNotification =
              @"NetworkConnectivityWasFoundNotification";

- (BOOL)            application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

  [[NSNotificationCenter defaultCenter]
   postNotificationName:(NSString *)NetworkConnectivityWasFoundNotification
   object:nil];

  self.window = [[UIWindow alloc] initWithFrame:
                 [[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}
```



# 1.30 监听来自 NSNotificationCenter 的通知

## 问题

你想使用 `NSNotificationCenter` 监听各种系统广播通知和自定义广播通知。


## 解决方案

在一个通知被广播之前，使用 `NSNotificationCenter` 的实例方法 `addObserver:selector:name:object:` 将你的观察者对象添加到通知中心。要停止监听一个通知，使用 `NSNotificationCenter` 的实例方法 `removeObserver:name:object:` 并传递你的观察者对象，然后是你想停止观察的通知的名称和你最初订阅的对象（这将在本章节的讨论部分详细解释）。


## 讨论


任何对象都可以广播通知，同一应用中的任何对象也都可以选择监听特定名称的通知。两个具有相同名称的通知可以被广播，但它们必须来自两个不同的对象。例如，你可以有一个名称为 DOWNLOAD_COMPLETED 的通知，从两个类中触发，一个用于从互联网上下载图片的下载管理器，另一个是从连接到 iOS 设备的附件中下载数据的下载管理器。观察者可能只对来自特定对象的通知感兴趣；例如，从附件中下载数据的下载管理器。你可以在开始监听通知时，使用通知中心的 `addObserver:selector:name:object:` 方法的对象参数，指定这个源对象（广播者）。

下面是 `addObserver:selector:name:object:` 实例方法接受的每个参数的简要描述：

* addObserver：接收通知的对象（观察者）。
* selector：当通知被广播并被观察者接收时，要在观察者中调用的选择器（方法）。这个方法需要一个 `NSNotification` 类型的单一参数。
* name：要观察的通知名称。
* object：可以选择指定广播通知的来源（指定发送通知的对象）。如果这个参数为 `nil`，无论哪个对象广播该通知，观察者都将收到指定名称的通知。如果这个参数被设置，那么只有由给定对象广播的指定名称的通知将被观察者接收。

在章节 1.29 中，我们学习了如何发布通知。现在让我们试着观察一下我们在那里学到的发布通知的方法：

```objc
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/* 通知的名称 */
const NSString *ResultOfAppendingTwoStringsNotification = @"ResultOfAppendingTwoStringsNotification";

/* 通知中发送的字典的 keys 值 */
const NSString *ResultOfAppendingTwoStringsFirstStringInfoKey = @"firstString";
const NSString *ResultOfAppendingTwoStringsSecondStringInfoKey = @"secondString";
const NSString *ResultOfAppendingTwoStringsResultStringInfoKey = @"resultString";

/* 广播通知 */
- (void)broadcastNotification {
    
    NSString *firstName = @"Anthony";
    NSString *lastName = @"Robbins";
    NSString *fullName = [firstName stringByAppendingString:lastName];
    
    NSArray *objects = [[NSArray alloc] initWithObjects:firstName, lastName, fullName, nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:ResultOfAppendingTwoStringsFirstStringInfoKey,
                                                     ResultOfAppendingTwoStringsSecondStringInfoKey,
                                                     ResultOfAppendingTwoStringsResultStringInfoKey,
                                                     nil];
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    NSNotification *notificationObject = [NSNotification notificationWithName:(NSString *)ResultOfAppendingTwoStringsNotification
                                                                       object:self
                                                                     userInfo:userInfo];
    
    [[NSNotificationCenter defaultCenter] postNotification:notificationObject];
}

/* 观察者接收到通知时，执行的方法 */
- (void)appendingIsFinished:(NSNotification *)paramNotification {
    NSLog(@"Notification is received.");
    NSLog(@"Notification Object = %@", [paramNotification object]);
    NSLog(@"Notification User-Info Dict = %@", [paramNotification userInfo]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 监听通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appendingIsFinished:)
                                                 name:(NSString *)ResultOfAppendingTwoStringsNotification
                                               object:self];
    /* 广播通知 */
    [self broadcastNotification];
}

- (void)dealloc {
    /* 我们不再监听任何通知了 */
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
```

当你运行该应用程序时，你会看到类似于下面的东西打印到控制台窗口：

```objc
Notification is received.
Notification Object = <ViewController: 0x14dd08570>
Notification User-Info Dict = {
    firstString = Anthony;
    resultString = AnthonyRobbins;
    secondString = Robbins;
}
```

正如你所看到的，我们正在使用通知中心的 `removeObserver:` 方法来移除我们的（作为所有通知的观察者的）对象。当然也有其他方法将你的对象从观察者链中移除。你可以像我们在这里所做的那样冷处理，也就是说，将你的对象完全从观察任何通知中移除，或者你可以在你的应用程序的生命周期中随时将你的对象从观察特定通知中移除。如果你想指定你要移除的（你的对象观察的）通知，只需调用通知中心的`removeObserver:name:object:` 方法，并指定你要退订的通知的名称，以及（可选）发送通知的对象。



# 在iOS 9中取消注册 NSNotificationCenter 观察者对象

提醒大家注意苹果公司在 iOS 9 和 OS X 10.11 的 [Foundation Release Notes](https://developer.apple.com/library/content/releasenotes/Foundation/RN-FoundationOlderNotes/index.html#10_11NotificationCenter) 中偷偷加入的内容。**当 NSNotificationCenter 的观察者被删除时，它不再需要取消注册**。如果你需要支持 iOS 8 或使用基于 block 的观察者时，有一些注意事项。我在写上周关于[detecting low power mode](https://useyourloaf.com/blog/detecting-low-power-mode/) 的文章时忘记了这一点，所以在这里，为了唤起我的记忆，我把细节和一个额外的提示放在这里。


## iOS 9 中 NSNotificationCenter 的变化

在 iOS 和 OS X 中，为 `NSNotificationCenter` 通知注册一个观察者是一项常见的任务。下面是典型的代码示例，你可以在视图控制器的 `viewDidLoad` 方法中使用，当用户改变偏好的字体大小时接收通知：

```swift
NSNotificationCenter.defaultCenter().addObserver(self,
  selector:#selector(didChangePreferredContentSize(_:)),
  name: UIContentSizeCategoryDidChangeNotification, 
  object: nil)
```

使用 iOS 8 或更早的版本，你需要在删除观察者对象之前取消对该通知的注册。如果你忘记了，当通知中心向一个不再存在的对象发送下一条通知时，你会有崩溃的风险。

使用 iOS 9 或更高版本的 Foundation 框架发布说明包含一些好消息：

> In OS X 10.11 and iOS 9.0 NSNotificationCenter and NSDistributedNotificationCenter will no longer send notifications to registered observers that may be deallocated.

通知中心现在保持对观察者归零的弱引用（zeroing reference）。

> If the observer is able to be stored as a zeroing-weak reference the underlying storage will store the observer as a zeroing weak reference, alternatively if the object cannot be stored weakly (i.e. it has a custom retain/release mechanism that would prevent the runtime from being able to store the object weakly) it will store the object as a non-weak zeroing reference.
>
> 如果观察者能够被存储为归零的弱引用，那么底层存储将把观察者存储为归零的弱引用。反之，如果对象不能被弱存储（即它有一个自定义的保留/释放机制，这将阻止运行时能够弱存储对象），它将把对象存储为非归零的弱引用。

所以下次通知中心想向观察者发送通知时，它可以检测到它不再存在，并为我们删除观察者。

> 这意味着观察者不需要在其 deallocation 方法中取消注册。下一个发送到该观察者的通知将检测到归零的引用，并自动取消观察者的注册。

请注意，如果你使用的是基于 block 的观察者，这并不适用。

> 通过 `[NSNotificationCenter addObserverForName:object:queue:usingBlock]` 方法创建的基于 block 的观察者在不再使用时仍然需要被取消注册，因为系统仍然持有这些观察者的强引用。

另外，如果你喜欢，或需要兼容 iOS 8 或更低的版本，你仍然可以（像原来那样）删除观察者。

> 仍然支持提前移除观察者（无论是弱引用还是归零引用）。

要明确的是，如果你需要兼容 iOS 8 或更低的版本，不要忘记在deinit方法中删除观察者。

```objc
deinit {
  NSNotificationCenter.defaultCenter().removeObserver(self, 
    name: UIContentSizeCategoryDidChangeNotification, 
    object: nil)
}
```

## 调试信息

`NSNotificationCenter` 和 `NSDistributedNotificationCenter` 现在将在调试器打印时提供一个调试描述，该描述将列出所有注册的观察者，包括已被清零的引用，以帮助调试通知注册的情况。

```bash
(lldb) p NSNotificationCenter.defaultCenter().debugDescription
(String) $R10 = "<NSNotificationCenter:0x134e0cb10>\nName, Object, Observer,  Options
UIAccessibilityForceTouchSensitivityChangedNotification, 0x19b0bbb60, 0x134d5d2e0, 1400
UIAccessibilityForceTouchSensitivityChangedNotification, 0x19b0bbb60, 0x134d605f0, 1400
...
UIContentSizeCategoryDidChangeNotification, 0x19b0bbb60, 0x134e5c2a0, 1400
```

你可能会发现你的应用程序所观察到的通知数量多得令人吃惊，你很可能需要增加输出字符串的最大长度，以便在LLDB控制台中看到它们。

```bash
(lldb) set set target.max-string-summary-length 50000
```




## 参考

* [1.29. Sending Notifications with NSNotificationCenter](https://www.oreilly.com/library/view/ios-6-programming/9781449342746/ch01s30.html)
* [1.30. Listening for Notifications Sent from NSNotificationCenter](https://www.oreilly.com/library/view/ios-6-programming/9781449342746/ch01s31.html)
* [Stackoverflow: Send and receive messages through NSNotificationCenter in Objective-C?](https://stackoverflow.com/questions/2191594/send-and-receive-messages-through-nsnotificationcenter-in-objective-c)
* [Unregistering NSNotificationCenter Observers in iOS 9](https://useyourloaf.com/blog/unregistering-nsnotificationcenter-observers-in-ios-9/)
* [NSNotification &NSNotificationCenter](https://nshipster.cn/nsnotification-and-nsnotificationcenter/)
* [Foundation: NSNotificationCenter](http://southpeak.github.io/2015/03/20/cocoa-foundation-nsnotificationcenter/)
