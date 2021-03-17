![“因为山在那里！”——1924年，英国登山家George Mallory回答《纽约时报》“你为什么要攀登珠峰？”时说的一句话](http://upload-images.jianshu.io/upload_images/2648731-108ee588e91bcf17.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## GCD简介

GCD 是 `libdispatch` 的市场名称，而 libdispatch 作为 Apple 的一个库，为并发代码在多核硬件（iOS 或 OS X ）上执行提供有力支持。它具有以下优点：

* GCD 能通过推迟昂贵计算任务并在后台运行它们来改善你的应用的响应性能。
* GCD 提供一个易于使用的并发模型而不仅仅只是锁和线程，以帮助我们避开并发陷阱。
* GCD 具有在常见模式（例如单例）上用更高性能的原语优化你的代码的潜在能力。



为了让开发者更加容易的使用设备上的多核 CPU，苹果在 OS X 10.6 和 iOS 4 中引入了 Grand Central Dispatch（GCD）。Grand Central Dispatch (GCD) 是 Apple 开发的多线程编程解决方法。

通过 GCD，开发者不用再直接跟线程打交道了，只需要向队列中添加代码块即可，GCD 在后端管理着一个[线程池](http://en.wikipedia.org/wiki/Thread_pool_pattern)。GCD 不仅决定着你的代码块将在哪个线程被执行，它还根据可用的系统资源对这些线程进行管理。这样可以将开发者从线程管理的工作中解放出来，通过集中的管理线程，来缓解大量线程被创建的问题。

GCD 带来的另一个重要改变是，作为开发者可以将工作考虑为一个队列，而不是一堆线程，这种并行的抽象模型更容易掌握和使用。

GCD 公开有 5 个不同的队列：运行在主线程中的 main queue，3 个不同优先级的后台队列，以及一个优先级更低的后台队列（用于 I/O）。 另外，开发者可以创建自定义队列：串行或者并行队列。自定义队列非常强大，在自定义队列中被调度的所有 block 最终都将被放入到系统的全局队列中和线程池中。

![GCD 队列](http://upload-images.jianshu.io/upload_images/2648731-82402700a5bfdbcb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




### GCD 与 操作队列 （operation queue）

GCD 是纯 C 的 API，而操作队列则是 Objective-C 的对象。

操作队列在底层是用 GCD 来实现的。



## 进程、线程、队列、串行、并发、同步、异步、傻傻分不清楚

### Thread 线程

[线程](http://zh.wikipedia.org/wiki/%E7%BA%BF%E7%A8%8B)（thread）是组成进程的子单元，操作系统的调度器可以对线程进行单独的调度。实际上，所有的并发编程 API 都是构建于线程之上的 —— 包括 GCD 和操作队列（operation queues）。

多线程可以在单核 CPU 上同时（或者至少看作同时）运行。操作系统将小的时间片分配给每一个线程，这样就能够让用户感觉到有多个任务在同时进行。如果 CPU 是多核的，那么线程就可以真正的以并发方式被执行，从而减少了完成某项操作所需要的总时间。



### Synchronous vs. Asynchronous 同步 vs. 异步

描述一个函数/方法与一个任务之间的关系，该函数要求一个任务在 GCD 下执行。

同步函数：方法会在指定的任务完成之后才返回。

异步函数：方法会立即返回，预定的任务会完成但不会等待它完成。因此，一个异步函数不会阻塞当前线程去执行下一个函数。

区别：方法是否立即返回。



### Critical Section 临界区

就是一段代码不能被并发执行，也就是，两个线程不能同时执行这段代码。这很常见，因为代码去操作一个共享资源，例如一个变量若能被并发进程访问，那么它很可能会变质（译者注：它的值可能被动态更改了但是还没有返回）



### Race Condition 竞态条件

这种状况是指基于特定序列或时机的事件的软件系统以不受控制的方式运行的行为，例如程序的并发任务执行的确切顺序。竞态条件可导致无法预测的行为，而不能通过代码检查立即发现。

关于竞态条件更好的诠释可以参考 [objc.io](https://www.objccn.io/issue-2-1/) 的例子：

![竞态条件](http://upload-images.jianshu.io/upload_images/2648731-43efe47dc15291c4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




### Deadlock 死锁

两个（或更多）东西——在大多数情况下，是线程——所谓的死锁是指它们都卡住了，并等待对方完成或执行其它操作。第一个不能完成是因为它在等待第二个的完成。但第二个也不能完成，因为它在等待第一个的完成。【与内存管理的循环引用问题类似】



### 互斥锁

[互斥](http://en.wikipedia.org/wiki/Mutex)访问的意思就是同一时刻，只允许一个线程访问某个特定资源。为了保证这一点，每个希望访问共享资源的线程，首先需要获得一个共享资源的[互斥锁](http://en.wikipedia.org/wiki/Lock_%28computer_science%29)，一旦某个线程对资源完成了操作，就释放掉这个互斥锁，这样别的线程就有机会访问该共享资源了。

![互斥锁](http://upload-images.jianshu.io/upload_images/2648731-33e902a7f2571de1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 优先级反转

优先级反转是指程序在运行时低优先级的任务阻塞了高优先级的任务，有效的反转了任务的优先级。由于 GCD 提供了拥有不同优先级的后台队列，甚至包括一个 I/O 队列，所以我们最好了解一下优先级反转的可能性。

高优先级和低优先级的任务之间共享资源时，就可能发生优先级反转。当低优先级的任务获得了共享资源的锁时，该任务应该迅速完成，并释放掉锁，这样高优先级的任务就可以在没有明显延时的情况下继续执行。然而高优先级任务会在低优先级的任务持有锁的期间被阻塞。如果这时候有一个中优先级的任务(该任务不需要那个共享资源)，那么它就有可能会抢占低优先级任务而被执行，因为此时高优先级任务是被阻塞的，所以中优先级任务是目前所有可运行任务中优先级最高的。此时，中优先级任务就会阻塞着低优先级任务，导致低优先级任务不能释放掉锁，这也就会引起高优先级任务一直在等待锁的释放。

![优先级反转](http://upload-images.jianshu.io/upload_images/2648731-22228c77641062ce.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




解决这个问题的方法，通常就是不要使用不同的优先级。通常最后你都会以让高优先级的代码等待低优先级的代码来解决问题。**当你使用 GCD 时，总是使用默认的优先级队列**（直接使用，或者作为目标队列）。如果你使用不同的优先级，很可能实际情况会让事情变得更糟糕。

从中得到的教训是，使用不同优先级的多个队列听起来虽然不错，但毕竟是纸上谈兵。它将让本来就复杂的并行编程变得更加复杂和不可预见。如果你在编程中，遇到高优先级的任务突然没理由地卡住了，可能你会想起本文，以及那个美国宇航局的工程师也遇到过的被称为优先级反转的问题。



### Thread Safe 线程安全

线程安全的代码能在多线程或并发任务中被安全地调用，而不会导致任何问题（数据损坏，崩溃等）。线程不安全的代码在某个时刻只能在一个上下文中运行。一个线程安全代码的例子是 `NSDictionary` 。你可以在同一时间在多个线程中使用它而不会有问题。相反，`NSMutableDictionary` 就不是线程安全的，应该保证一次只能有一个线程访问它。



### Context Switch 上下文切换

一个上下文切换：在单个进程里切换执行不同的线程时存储与恢复执行状态的过程。这个过程在编写多任务应用时很普遍，但会带来一些额外的开销。



### Concurrency vs Parallelism 并发与并行

并发代码的不同部分可以“同步”执行。然而，该怎样发生或是否发生都取决于系统。多核设备通过并行来同时执行多个线程；然而，为了使单核设备也能实现这一点，它们必须先运行一个线程，执行一个上下文切换，然后运行另一个线程或进程。这通常发生地足够快以致给我们并发执行地错觉，如下图所示：

![](http://upload-images.jianshu.io/upload_images/2648731-7bf5831c9245fe4e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


虽然你可以编写代码在 GCD 下并发执行，但 GCD 会决定有多少并行的需求。**并行要求并发，但并发不能保证并行**。



### Queues 队列

GCD 提供 `dispatch queues` 来处理代码块，这些队列管理你提供给 GCD 的任务并用 FIFO 顺序执行这些任务。这就保证了第一个被添加到队列里的任务会是队列中第一个开始的任务，而第二个被添加的任务将第二个开始，如此直到队列结束。

所有的调度队列（dispatch queues）自身都是线程安全的，你能从多个线程并行的访问它们。当你了解了调度队列如何为你自己代码的不同部分提供线程安全后，GCD的优点就会显而易见。关于这一点的关键是：**选择正确类型的调度队列和正确的调度函数来提交你的工作**。



#### Serial vs. Concurrent 串行 vs. 并发

描述当前任务与其它被执行任务之间的关系

串行队列：每次只有一个任务被执行；

并发队列：同一时间可以有多个任务被执行。



#### Serial Queues 串行队列

串行队列中的任务一次执行一个，每个任务只有在前一个任务完成后才会开始。而且，你不能确定 Block 任务执行的时间长度，如下图所示：

![](http://upload-images.jianshu.io/upload_images/2648731-f8fe678a0b66db26.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


这些任务的执行时机受到 GCD 的控制；唯一能确保的事情是： **GCD 一次只执行一个任务，并且按照我们添加到队列中的顺序来执行。**

由于在串行队列中不会有两个任务并发执行，因此不会出现同时访问临界区的风险；相对于这些任务来说，这就从竞态条件下保护了临界区。所以如果访问临界区的唯一方式是通过提交到调度队列的任务，那么你就不需要担心临界区的安全问题了。



#### Concurrent Queues 并发队列

并发队列中的任务能得到的保证是：**它们会按照被添加的顺序开始执行**，但这就是全部的保证了。任务可能以任意顺序完成，你不知道何时开始执行下一个任务，或者何时有多少 Block 任务在执行。再说一遍，这完全取决于 GCD 。

下图展示了一个示例任务执行计划，GCD 管理着四个并发任务：

![](http://upload-images.jianshu.io/upload_images/2648731-b59dad582581369d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


注意 Block 1、2 和 3 都是立即执行的，一个接一个。在 Block 0 开始后，Block 1等待了好一会儿才开始。同样， Block 3 在 Block 2 之后才开始，但它先于 Block 2 完成。

何时开始一个 Block 完全取决于 GCD 。如果一个 Block 的执行时间与另一个重叠，也是由 GCD 来决定是否将其运行在另一个不同的核心上，如果那个核心可用，就用上下文切换的方式来执行不同的 Block 。

有趣的是， GCD 给你提供了至少五个特定的队列，可根据队列类型选择使用。



#### Queue Types 队列类型

首先，系统给你提供了一个叫做 `主队列（main queue）` 的特殊队列。和其它串行队列一样，该队列中的任务一次只能执行一个。然而，它能保证所有的任务都在主线程执行，而**主线程是唯一可用于更新 UI 的线程。**这个队列用于发送消息或通知给 `UIView` 、响应用户交互。

同时，系统给你提供了几个并发队列。它们叫做 `全局调度队列（Global Dispatch Queues）` 。目前的四个全局队列有着不同的优先级：`background`、`low`、`default` 以及 `high`。要知道，Apple 的 API 也会使用这些队列，所以你添加的任何任务都不会是这些队列中唯一的任务。

最后，你也可以创建自己的串行队列或并发队列。这就是说，至少有**五个队列**任你处置：主队列、四个全局调度队列，再加上任何你自己创建的队列。

以上是调度队列的大框架！

GCD 的“艺术”归结为**选择合适队列的调度函数以提交你的工作**。





## 多线程的四种解决方案

* pthread：运用 C 语言，是一套通用的 API，可跨平台 Unix/Linux/Windows。线程的生命周期由程序员管理。
*  NSThread：面向对象，可直接操作线程对象。线程的生命周期由程序员管理。
* GCD：代替 NSThread，可以充分利用设备的多核，自动管理线程生命周期。
*  NSOperation：底层是 GCD，比 GCD 多了一些方法，更加面向对象，自动管理线程生命周期。



## GCD 方法

GCD 是纯 C 的 API，如果你使用 MBProgressHUD 框架，你会看到使用 GCD 的这个示例：

```objective-c
// 在根视图上显示 HUD
MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

// 异步后台线程执行，使UIKit有机会重新绘制 HUD 并添加到视图层次结构中。
dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

    // Do something useful in the background
    [self doSomeWork];

    // 主线程执行，请确保始终在主线程上更新UI（包括MBProgressHUD）。
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
});
```



### 全局队列， `dispatch_get_global_queue()`

函数：`dispatch_get_global_queue(long identifier, unsigned long flags)`

1. 参数一：`long identifier`：qos_class_t 中定义的服务质量或者 dispatch_queue_priority_t 中定义的队列优先级。

   * **dispatch_queue_priority_t** ：队列优先级

     ```objective-c
     // 派发到队列中的任务将以最高优先级运行，此队列任务将会被安排到默认优先级或者低优先级的任务之前运行。
     #define DISPATCH_QUEUE_PRIORITY_HIGH 2

     // 派发到队列中的任务将以默认优先级运行，即，该任务将会在【所有高优先级任务已经被调度之后，并且在所有低优先级任务被调度之前】被调度执行。
     #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0

     // 派发到队列中的任务将以低优先级运行，即在所有默认优先级和高优先级任务已经被执行之后，该队列中的任务将会被调度执行
     #define DISPATCH_QUEUE_PRIORITY_LOW (-2)

     // 派发到队列中的任务将以后台优先级运行，也就是说，在调度了所有高优先级任务之后，该队列中的任务将被调度执行，并且系统将在具有根据 setpriority 的后台状态的线程上运行该队列上的任务。（磁盘 I/O 受到限制，线程的调度优先级设置为最低值）。
     #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN
     ```

   * **qos_class_t**：服务质量，*iOS 8.0 新增*

     ```objective-c
      * Apple 建议我们使用服务质量类别的值来标记全局并发队列
      *  - QOS_CLASS_USER_INTERACTIVE
      *  - QOS_CLASS_USER_INITIATED
      *  - QOS_CLASS_DEFAULT
      *  - QOS_CLASS_UTILITY
      *  - QOS_CLASS_BACKGROUND
      *
      * 全局并发队列仍然可以通过优先级来识别,它会被映射到以下QOS类：
      *  - DISPATCH_QUEUE_PRIORITY_HIGH:         QOS_CLASS_USER_INITIATED
      *  - DISPATCH_QUEUE_PRIORITY_DEFAULT:      QOS_CLASS_DEFAULT
      *  - DISPATCH_QUEUE_PRIORITY_LOW:          QOS_CLASS_UTILITY
      *  - DISPATCH_QUEUE_PRIORITY_BACKGROUND:   QOS_CLASS_BACKGROUND
        
      /*!
      * @constant QOS_CLASS_USER_INTERACTIVE
      * @abstract 该线程执行的是与用户交互的工作
      * @discussion 与系统上运行的其他工作相比，该工作被要求以最高优先级运行。指定这个 QOS 类会请求几乎所有可用的系统 CPU 和 I/O 带宽运行，甚至不惜争用资源。
      * 这不是一个适用于大型任务的节能 QOS 类。 这个 QOS 类的使用应限于与用户的关键交互，例如处理主事件循环中的事件，绘图，动画等。
      *
      * @constant QOS_CLASS_USER_INITIATED
      * @abstract 该线程执行的工作的 QOS 类是由用户发起的并且用户可能正在等待结果。
      * @discussion 这种工作的优先级低于关键的用户交互工作，但比系统上的其他工作要高。 
      * 这不是一个适用于大型任务的节能 QOS 类。它的使用应该限制在足够短的时间内，以至于用户不太可能在等待结果的时候切换任务。 典型的用户发起的通过显示占位符内容或模态用户界面来指示进度的工作。
      *
      * @constant QOS_CLASS_DEFAULT
      * @abstract 系统在缺少更具体的QOS分类信息的情况下使用的默认QOS分类。
      * @discussion 这种工作优先级低于关键的用户交互和用户发起的工作，但比实用工具和后台任务要高。 由pthread_create（）创建的没有指定QOS类的属性的线程将默认为QOS_CLASS_DEFAULT。 这个QOS类的值并不打算作为工作分类，只有在传播或恢复系统提供的QOS类值时才应设置。
      *
      * @constant QOS_CLASS_UTILITY
      * @abstract 该线程执行的工作的QOS类或许可能由用户发起，并且用户并不期待立即等待结果。
      * @discussion 这种工作的优先级低于关键用户交互和用户启动的工作，但比低级系统维护任务要高。 使用这个QOS级别表明工作应该以节能和高效率的方式运行。 效用工作的进展可能会也可能不会被指示给用户，但这种工作的效果是用户可见的。
      *
      * @constant QOS_CLASS_BACKGROUND
      * @abstract 该线程执行的工作的QOS类不是由用户发起的，并且用户可能不知道结果。
      * @discussion 这项工作的优先级低于其他工作。 使用这个QOS级别表明工作应该以最节能，最高效的方式进行。
      *
      * @constant QOS_CLASS_UNSPECIFIED
      * @abstract 指示QOS类信息的缺失或移除的QOS类值。
      * @discussion 作为API返回值，可能表示线程或pthread属性是使用与旧版API不兼容或与QOS类系统冲突的配置。
      */

     __QOS_ENUM(qos_class, unsigned int,
     	QOS_CLASS_USER_INTERACTIVE
     			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x21,
     	QOS_CLASS_USER_INITIATED
     			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x19,
     	QOS_CLASS_DEFAULT
     			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x15,
     	QOS_CLASS_UTILITY
     			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x11,
     	QOS_CLASS_BACKGROUND
     			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x09,
     	QOS_CLASS_UNSPECIFIED
     			__QOS_CLASS_AVAILABLE(macos(10.10), ios(8.0)) = 0x00,
     );

     #undef __QOS_ENUM
     ```

     


2. 参数二：`unsigned long flags`

   Apple 保留以供将来使用的值。 传递除零以外的任何值都可能导致返回值为NULL。因此，**这个值我们务必设置为0**。

使用示例：

```objective-c
// 异步后台队列
dispatch_queue_t global_queue = dispatch_get_global_queue(0, 0);

dispatch_async(dispatch_get_global_queue(0, 0), ^{
   // 异步后台任务...
});
```



### 异步队列， `dispatch_async`

三种方式：



#### 异步自定义串行队列

```objective-c
dispatch_queue_t my_queue = dispatch_queue_create("com.companyName.projectName.taskName", NULL); // 传参 NULL 代表这是一个串行队列。
dispatch_async(my_queue, ^{
    // 异步自定义任务
});
```

当你想串行执行后台任务并追踪它时就是一个好选择。这消除了资源争用，因为你知道一次只有一个任务在执行。注意若你需要获取某个方法的数据，你必须内联另一个 Block 来找回它或考虑使用 `dispatch_sync`。



#### 异步主队列

```objective-c
dispatch_async(dispatch_get_main_queue(), ^{
    // 异步主线程任务
});
```

这是在一个并发队列上完成任务后更新 UI 的共同选择。要这样做，你将在一个 Block 内部编写另一个 Block 。以及，如果你在主队列调用 `dispatch_async` 到主队列，你能确保这个新任务将在当前方法完成后的某个时间执行。



#### 异步全局队列

```objective-c
dispatch_async(dispatch_get_global_queue(0, 0), ^{
    // 异步并发任务
});
```

这是在后台执行非 UI 工作的共同选择。



### 延后执行任务，dispatch_after 

延迟 n 秒执行，使用 snippet 代码块：==dispatch_after==

```objective-c
double delayInSeconds = 2.0;
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    // code to be executed after a specified delay
});
```

`dispatch_after` 可以使任务延后执行，缺点是无法取消 block 中将要执行的代码。如果你需要一些事情在某个特定的时刻运行，那么 `dispatch_after` 或许会是个好的选择。确保同时考虑了 `NSTimer`，这个API虽然有点笨重，但是它允许你取消定时器的触发。

不知道何时适合使用 `dispatch_after` ？

* 自定义串行队列：在一个自定义串行队列上使用 `dispatch_after` 要小心。你最好坚持使用主队列。
* ✅主队列（串行）：是使用 `dispatch_after` 的好选择；Xcode 提供了一个不错的 snippet 模版（==dispatch_after==）。
* 并发队列：在并发队列上使用 `dispatch_after` 也要小心；你会这样做就比较罕见。还是在主队列做这些操作吧。

因此，**强烈建议在主队列上执行延后任务**。



### 单次执行，dispatch_once

`dispatch_once()` 以线程安全的方式执行且仅执行其代码块一次。试图访问临界区（即传递给 `dispatch_once` 的代码）的不同的线程会在临界区已有一个线程的情况下被阻塞，直到临界区完成为止。

使用 snippet 代码块创建：==dispatch_once==

```objective-c
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    // code to be executed once
});
```

该方法常用于**单例类**初始化，可以防止竞态条件发生：

❎不推荐的单例创建方法：

```objective-c
+ (instancetype)sharedManager
{
    static PhotoManager *sharedPhotoManager = nil;
    if (!sharedPhotoManager) {
        sharedPhotoManager = [[PhotoManager alloc] init];
        sharedPhotoManager->_photosArray = [NSMutableArray array];
    }
    return sharedPhotoManager;
}
```

原因在于，**if 条件分支不是线程安全的。**如果调用这个单例方法多次，系统可能对创建多个实例对象——竞态条件。

✅推荐的方法：

```objective-c
+ (instancetype)sharedManager
{
    static PhotoManager *sharedPhotoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPhotoManager = [[PhotoManager alloc] init];
        sharedPhotoManager->_photosArray = [NSMutableArray array];
    });
    return sharedPhotoManager;
}
```



### 栅栏，dispatch_barriers

> Note：这些称谓指的都是 dispatch_barriers 函数：栅栏、障碍、屏障...

#### 读写问题

照片管理类可以对照片执行**写**方法：

```objective-c
- (void)addPhoto:(Photo *)photo {
    if (photo) {
        [_photosArray addObject:photo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postContentAddedNotification];
        });
    }
}
```

也可以执行**读**方法：

```objective-c
- (NSArray *)photos {
    return _photosArray;
}
```

⚠️问题在于，这两个方法不能提供任何保护措施来对抗当一个线程调用读方法 `photos` 的同时另一个线程调用写方法 `addPhoto:` 。

GCD 通过用 `dispatch barriers` 创建一个`读写锁` 提供了一个优雅的解决方案。

Dispatch barriers 是一组函数，在并发队列上工作时扮演一个串行式的瓶颈。使用 GCD 的障碍（barrier）API 确保提交的 Block 在那个特定时间上是指定队列上唯一被执行的条目。这就意味着所有的先于调度障碍提交到队列的条目必能在这个 Block 执行前完成。

当这个 Block 的时机到达，调度障碍执行这个 Block 并确保在那个时间里队列不会执行任何其它 Block 。一旦完成，队列就返回到它默认的实现状态。 GCD 提供了同步和异步两种障碍函数。

下图显示了 `dispatch_barriers` 函数对多个异步队列的影响：

![](http://upload-images.jianshu.io/upload_images/2648731-e5566ff6768ea219.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


注意到正常部分的操作就如同一个正常的并发队列。但当障碍执行时，它本质上就如同一个串行队列。也就是，障碍是唯一在执行的事物。在障碍完成后，队列回到一个正常并发队列的样子。

下面是你何时会，或者不会使用障碍函数的情况：

* ❎自定义串行队列：一个很坏的选择；障碍不会有任何帮助，因为不管怎样，一个串行队列一次只执行一个操作。
* ❎全局并发队列：要小心；这可能不是最好的主意，因为其它系统可能在使用队列而且你不能垄断它们只为你自己的目的。
* ✅自定义并发队列：这对于原子或临界区代码来说是极佳的选择。任何你在设置或实例化的需要线程安全的事物都是使用障碍的最佳候选。



```objective-c
@property (nonatomic, strong) dispatch_queue_t concurrentPhotoQueue;

//...

/*
1. “写操作”可以放入并发队列，因为设置方法并不需要返回值；
2. 使用 dispatch_barrier 将此并发队列加锁，保证任一时刻只有一个“写操作”在执行；
2. 自定义并发队列，而不是全局并发队列的原因是：全局队列中还可能有其他任务，一旦加锁就会阻塞其他任务的正常执行，不能为了个人利益影响国家嘛，因此我们开辟一个新的自定义并发队列专门处理这个问题。
*/
- (void)addPhoto:(Photo *)photo {
    if (photo) {
        dispatch_barrier_async(self.concurrentPhotoQueue, ^{
            [_photosArray addObject:photo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self postContentAddedNotification];
            });
        });
    }
}
```

⚠️  注意：当使用并发队列时，要确保所有的 *barrier* 调用都是 *async* 的。如果你使用 `dispatch_barrier_sync` ，那么你很可能会使你自己（更确切的说是，你的代码）产生死锁。写操作*需要* barrier，并且*可以*是 async 的。



### 自定义线程，dispatch_queue_create()

函数：`dispatch_queue_create(const char * _Nullable label, dispatch_queue_attr_t  _Nullable attr)`

参数一：`const char * _Nullable label`，自定义线程的标识符，一般为反向DNS域名

参数二：指定队列类型（串行/并发队列），可以传入的参数类型如下：

* 串行：`DISPATCH_QUEUE_SERIAL` ：一个按FIFO顺序调用块的调度队列。
* 并发：`DISPATCH_QUEUE_CONCURRENT`：使用 `DISPATCH_QUEUE_CONCURRENT` 属性创建的队列可以同时调用块（类似于全局并发队列，但可能会有更多的开销），并且，它支持使用调度栅栏 API （`dispatch barriers` ）提交的栅栏块，例如， 能够实现高效的读写器方案。

> 注意：当你在网上搜索例子时，你会经常看人们传递 `0` 或者 `NULL` 给 `dispatch_queue_create` 的第二个参数。这是创建串行队列的过时方式；明确你的参数总是更好。

使用 `dispatch_queue_create` 方法

  ```objective-c
dispatch_queue_t urls_queue = dispatch_queue_create("com.companyName.project.taskName", NULL);
dispatch_async(urls_queue, ^{
  // your code
});
  ```


修改使用自定义队列：

```objective-c
@property (nonatomic, strong) dispatch_queue_t concurrentPhotoQueue;

//...
+ (instancetype)sharedManager
{
    static PhotoManager *sharedPhotoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPhotoManager = [[PhotoManager alloc] init];
        sharedPhotoManager->_photosArray = [NSMutableArray array];
        
        // 自定义并发队列 
        sharedPhotoManager -> _concurrentPhotoQueue = dispatch_queue_create("com.selander.GooglyPuff.photoQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return sharedPhotoManager;
}
```



### 同步队列，dispathc_sync

`dispatch_sync()` 同步地提交工作并在返回前等待它完成。使用 `dispatch_sync` 跟踪你的调度障碍工作，或者当你需要等待操作完成后才能使用 Block 处理过的数据。如果你使用第二种情况做事，你将不时看到一个 `__block` 变量写在 `dispatch_sync` 范围之外，以便返回时在 `dispatch_sync` 使用处理过的对象。

但你需要很小心。想像如果你调用 `dispatch_sync` 并放在你已运行着的当前队列。这会导致死锁，因为调用会一直等待直到 Block 完成，但 Block 不能完成（它甚至不会开始！），直到当前已经存在的任务完成，而当前任务无法完成！这将迫使你自觉于你正从哪个队列调用——以及你正在传递进入哪个队列。

下面是一个快速总览，关于在何时以及何处使用 `dispatch_sync` ：

* 自定义串行队列：在这个状况下要非常小心！如果你正运行在一个队列并调用 `dispatch_sync` 放在同一个队列，那你就百分百地创建了一个死锁（同步队列嵌套会导致死锁问题！！！）
* 主队列（串行）：同上面的理由一样，必须非常小心！这个状况同样有潜在的导致死锁的情况。
* ✅并发队列：这才是做同步工作的好选择，不论是通过调度障碍，或者需要等待一个任务完成才能执行进一步处理的情况。



```objective-c
// 将“读操作”放入同步队列，这样方法就不会立即返回了，它会等待执行“读操作”完毕后才返回。
- (NSArray *)photos
{
  // __block 关键字允许对象在 Block 内可变。没有它，array 在 Block 内部就只是只读的，你的代码甚至不能通过编译。
    __block NSArray *array;
    dispatch_sync(self.concurrentPhotoQueue, ^{
        array = [NSArray arrayWithArray:_photosArray];
    });
    return _photosArray;
}
```



#### 小结：读写的线程安全问题

一、以上几个函数是如何解决读写问题的呢？

1. **写方法**：将**写操作**放在 `dispatch_barrier_async` 阻塞函数中，同时，该阻塞函数运行在自定义并发队列中：`dispatch_queue_create("com.selander.GooglyPuff.photoQueue", DISPATCH_QUEUE_CONCURRENT)`。
2. **读方法**：将**读操作**放入同步队列 `dispatch_sync` 中，方法会等待**读操作**执行完毕后再返回，同时，该同步队列仍然运行在自定义并发队列中：因为多个获取方法可以并发执行。
3. 获取方法与设置方法之间不能并发执行，因此我们将他们放在同一个自定义并发队列中。





### dispatch_sync 与 dispatch_async 的区别

* `dispatch_sync`，同步队列，函数会等待它返回后再继续执行。
* `dispatch_async`，异步队列，函数会立即返回。

#### dispatch_sync

`viewDidLoad` 方法会等待同步队列任务返回后再继续执行。

![](http://upload-images.jianshu.io/upload_images/2648731-6320304aeee900fa.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




#### dispatch_async

`viewDidLoad` 方法会立即继续执行，不会等待异步队列任务返回。

![](http://upload-images.jianshu.io/upload_images/2648731-b6b484acd22ed291.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)






### 调度组，dispatch_group_t

Dispatch Group 会在整个组的任务都完成时通知你。这些任务可以是同步的，也可以是异步的，即便在不同的队列也行。而且在整个组的任务都完成时，Dispatch Group 可以用同步的或者异步的方式通知你。因为要监控的任务在不同队列，那就用一个 `dispatch_group_t` 的实例来记下这些不同的任务。

当组中所有的事件都完成时，GCD 的 API 提供了两种通知方式。

示例代码一：

```
// 让后台 2 个线程并行执行，然后等 2 个线程都结束后，再汇总执行结果。
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
    // 并行执行线程一
});
dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
    // 并行执行线程二
});
dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
    // 汇总结果
});
```



因为下载任务是在后台执行的，它会立即返回，如何监听下载完成并做一些下载完成后的处理？使用 `dispatch_group_t`。

第一种是 `dispatch_group_wait` ，它会阻塞当前线程，直到组里面所有的任务都完成或者等到某个超时发生。

1⃣️ **dispatch_group_wait()** 函数，会阻塞主线程：

```objective-c
- (void)downloadPhotosWithCompletionBlock:(BatchPhotoDownloadingCompletionBlock)completionBlock
{
    // 因为 dispatch_group_wait() 方法会阻塞主线程，所以使用 dispatch_async() 将整个方法放入后台队列中以避免阻塞主线程。
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{ // 1
        
        __block NSError *error;
        
        // 创建一个任务调度组
        dispatch_group_t downloadGroup = dispatch_group_create(); // 2
        
        for (NSInteger i = 0; i < 3; i++) {
            NSURL *url;
            switch (i) {
                case 0:
                    url = [NSURL URLWithString:kOverlyAttachedGirlfriendURLString];
                    break;
                case 1:
                    url = [NSURL URLWithString:kSuccessKidURLString];
                    break;
                case 2:
                    url = [NSURL URLWithString:kLotsOfFacesURLString];
                    break;
                default:
                    break;
            }
            
            // dispatch_group_enter 手动通知 Dispatch Group 任务已经开始。你必须保证 dispatch_group_enter 和 dispatch_group_leave 成对出现，否则你可能会遇到诡异的崩溃问题。
            dispatch_group_enter(downloadGroup); // 3
            Photo *photo = [[Photo alloc] initwithURL:url
                                  withCompletionBlock:^(UIImage *image, NSError *_error) {
                                      if (_error) {
                                          error = _error;
                                      }
                                      dispatch_group_leave(downloadGroup); // 4
                                  }];
            
            [[PhotoManager sharedManager] addPhoto:photo];
        }
        
        // dispatch_group_wait 会一直等待，直到任务全部完成或者超时。如果在所有任务完成前超时了，该函数会返回一个非零值。你可以对此返回值做条件判断以确定是否超出等待周期；然而，你在这里用 DISPATCH_TIME_FOREVER 让它永远等待。它的意思，勿庸置疑就是，永－远－等－待！这样很好，因为图片的创建工作总是会完成的。
        dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER); // 5
        
        // 此时此刻，你已经确保了，要么所有的图片任务都已完成，要么发生了超时。然后，你在主线程上运行 completionBlock 回调。这会将工作放到主线程上，并在稍后执行。
        dispatch_async(dispatch_get_main_queue(), ^{ // 6
            if (completionBlock) {
                completionBlock(error);
            }
        });
    });
}
```



2⃣️ **dispatch_group_notify()** 函数，异步执行，不会阻塞主线程：

```objective-c
- (void)downloadPhotosWithCompletionBlock:(BatchPhotoDownloadingCompletionBlock)completionBlock
{
    __block NSError *error;

    // 创建一个任务调度组
    dispatch_group_t downloadGroup = dispatch_group_create(); // 1
    
    for (NSInteger i = 0; i < 3; i++) {
        NSURL *url;
        switch (i) {
            case 0:
                url = [NSURL URLWithString:kOverlyAttachedGirlfriendURLString];
                break;
            case 1:
                url = [NSURL URLWithString:kSuccessKidURLString];
                break;
            case 2:
                url = [NSURL URLWithString:kLotsOfFacesURLString];
                break;
            default:
                break;
        }
        
        dispatch_group_enter(downloadGroup); // 2
        Photo *photo = [[Photo alloc] initwithURL:url
                              withCompletionBlock:^(UIImage *image, NSError *_error) {
                                  if (_error) {
                                      error = _error;
                                  }
                                  dispatch_group_leave(downloadGroup); // 3
                              }];
        
        [[PhotoManager sharedManager] addPhoto:photo];
    }
    
    // dispatch_group_notify 以异步的方式工作。当 Dispatch Group 中没有任何任务时，它就会执行其代码，那么 completionBlock 便会运行。你还指定了运行 completionBlock 的队列，此处，主队列就是你所需要的。
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{ // 4
        if (completionBlock) {
            completionBlock(error);
        }
    });
}
```



关于何时以及怎样使用有着不同的队列类型的 Dispatch Group ：

* 自定义串行队列：它很适合当一组任务完成时发出通知。
* 主队列（串行）：它也很适合这样的情况。但如果你要同步地等待所有工作地完成，那你就不应该使用它，因为你不能阻塞主线程。然而，异步模型是一个很有吸引力的能用于在几个较长任务（例如网络调用）完成后更新 UI 的方式。
* 并发队列：它也很适合 Dispatch Group 和完成时通知。



### 并发循环、迭代执行，dispatch_apply

`dispatch_apply` 表现得就像一个 `for` 循环，但它能并发地执行不同的迭代。这个函数是同步的，所以和普通的 `for` 循环一样，它只会在所有工作都完成后才会返回。

当在 Block 内计算任何给定数量的工作的最佳迭代数量时，必须要小心，因为过多的迭代和每个迭代只有少量的工作会导致大量开销以致它能抵消任何因并发带来的收益。而被称为`跨越式（striding）`的技术可以在此帮到你，即通过在每个迭代里多做几个不同的工作。

> 译者注：大概就能减少并发数量吧，作者是提醒大家注意并发的开销，记在心里！

那何时才适合用 `dispatch_apply` 呢？

* 自定义串行队列：串行队列会完全抵消 `dispatch_apply` 的功能；你还不如直接使用普通的 `for` 循环。
* 主队列（串行）：与上面一样，在串行队列上不适合使用 `dispatch_apply` 。还是用普通的 `for` 循环吧。
* ✅并发队列：对于并发循环来说是很好选择，特别是当你需要追踪任务的进度时。



使用示例：

```objective-c
- (void)downloadPhotosWithCompletionBlock:(BatchPhotoDownloadingCompletionBlock)completionBlock
{
    __block NSError *error;

    // 创建一个任务调度组
    dispatch_group_t downloadGroup = dispatch_group_create(); // 1
    
    // 使用 dispatch_apply 代替 for (NSInteger i = 0; i < 3; i++) 循环
    dispatch_apply(3, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^(size_t i) {
        NSURL *url;
        switch (i) {
            case 0:
                url = [NSURL URLWithString:kOverlyAttachedGirlfriendURLString];
                break;
            case 1:
                url = [NSURL URLWithString:kSuccessKidURLString];
                break;
            case 2:
                url = [NSURL URLWithString:kLotsOfFacesURLString];
                break;
            default:
                break;
        }
        
        dispatch_group_enter(downloadGroup); // 2
        Photo *photo = [[Photo alloc] initwithURL:url
                              withCompletionBlock:^(UIImage *image, NSError *_error) {
                                  if (_error) {
                                      error = _error;
                                  }
                                  dispatch_group_leave(downloadGroup); // 3
                              }];
        
        [[PhotoManager sharedManager] addPhoto:photo];
    });

    // dispatch_group_notify 以异步的方式工作。当 Dispatch Group 中没有任何任务时，它就会执行其代码，那么 completionBlock 便会运行。你还指定了运行 completionBlock 的队列，此处，主队列就是你所需要的。
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{ // 4
        if (completionBlock) {
            completionBlock(error);
        }
    });
}
```

实际上，在这个例子里并不值得。下面是原因：

* 你创建并行运行线程而付出的开销，很可能比直接使用  `for` 循环要多。若你要以合适的步长迭代非常大的集合，那才应该考虑使用 `dispatch_apply`。
* 你用于创建应用的时间是有限的——除非实在太糟糕否则不要浪费时间去提前优化代码。如果你要优化什么，那去优化那些明显值得你付出时间的部分。你可以通过在 Instruments 里分析你的应用，找出最长运行时间的方法。看看 [如何在 Xcode 中使用 Instruments](http://www.raywenderlich.com/23037/how-to-use-instruments-in-xcode) 可以学到更多相关知识。
* 通常情况下，优化代码会让你的代码更加复杂，不利于你自己和其他开发者阅读。请确保添加的复杂性能换来足够多的好处。

记住，不要在优化上太疯狂。你只会让你自己和后来者更难以读懂你的代码。

> 💡使用线程并不是没有代价的，线程会有**创建时的时间开销**，还会消耗内核的内存，即**应用的内存空间**。



### 信号量函数，dispatch_semaphore_t

信号量让你控制多个消费者对有限数量资源的访问。举例来说，如果你创建了一个有着两个资源的信号量，那同时最多只能有两个线程可以访问临界区。其他想使用资源的线程必须在一个…你猜到了吗？…FIFO队列里等待。

...



### 每秒执行，dispatch_source

帮助你去响应或监测 Unix 信号、文件描述符、Mach 端口、VFS 节点，以及其它晦涩的东西。

常用于**倒计时器**，使用 snippet 代码块：==dispatch_source==

示例一：
```objective-c
// 60秒倒计时定时器，每秒执行一次，
double intervalInSeconds = 60.0; // 时间间隔
dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, intervalInSeconds * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
dispatch_source_set_event_handler(timer, ^{
    // code to be executed when timer fires
});
dispatch_resume(timer);
```
示例二：
```objective-c
// 点击“获取验证码按钮”，开启60秒倒计时
-(void)buttonCountDown:(UIButton *)button {
    button.enabled = NO;
    
    __block int timeout = 60; // 倒计时时间
    NSTimeInterval intervalInSeconds = 1.0; // 执行时间间隔
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, intervalInSeconds * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                button.enabled = YES;
                [button setTitle:@"重新获取验证码" forState:UIControlStateNormal];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                button.enabled = NO;
                NSString *buttonTitle = [NSString stringWithFormat:@"%ds后重新发送",timeout];
                [button setTitle:buttonTitle forState:UIControlStateNormal];
            });
        }
        timeout --;
    });
    dispatch_resume(timer);
}
```


### 参考文献
* [深入理解GCD](https://bestswifter.com/deep-gcd/)
* [使用GCD @唐巧](http://blog.devtang.com/2012/02/22/use-gcd/)

  > 简单描述了 block、GCD 的几个方法。

* [Ray Wenderlich: iOS系统中的多线程和GCD的初学者教程](https://www.raywenderlich.com/4295/multithreading-and-grand-central-dispatch-on-ios-for-beginners-tutorial)

  > Ray Wenderlich 系列的教程，非常值得一看，只不过这篇教程是2011年写的，年代有些久远，教程中还使用了 ASIHTTPRequest（一个已经停止更新的网络库，目前流行的是 AFNetworking），参考起来有些费解，教程的大致内容总结如下：
  >
  > 教程讲解了一个 ImageGrabber 应用，它的功能是打开 HTML 网页，检索并抓取所有图片的链接，然后将所有抓取到的图片显示在列表视图上。它还可以下载 zip 文件，并提取出 zip 文件内的图像。
  >
  > 但是，如果应用程序在主线程上执行所有的操作：解析HTML、下载图片、下载并解压 zip 文件、遍历并提取出 zip 文件中所有图片。这样会导致主线程阻塞造成UI界面卡顿或者无法响应用户交互，用户不得不等待大量的时间，也不知道应用程序是否仍然正常工作！
  >
  > 优化一：异步下载，并使用 NSNotification 通知更新UI。
  >
  > 优化二：使用GCD将下载并解压 zip 文件的耗时任务放到后台线程执行。
  >
  > 不建议：在主线程上执行所有的任务。
  >
  > 推荐：把一个进程分解成多个线程执行。主线程用于更新UI，响应用户事件，后台线程用于检索HTML页面、下载并解压缩文件。

* [Ray Wenderlich: GCD 深入理解：第一部分](https://github.com/nixzhu/dev-blog/blob/master/2014-04-19-grand-central-dispatch-in-depth-part-1.md)

  > ⭐️⭐️⭐️

* [Ray Wenderlich: GCD 深入理解：第二部分](https://github.com/nixzhu/dev-blog/blob/master/2014-05-14-grand-central-dispatch-in-depth-part-2.md)

  > ⭐️⭐️⭐️

* [Ray Wenderlich: NSOperation and NSOperationQueue Tutorial in Swift](https://www.raywenderlich.com/76341/use-nsoperation-nsoperationqueue-swift)

* [iOS 并发编程之 Operation Queues](http://blog.leichunfeng.com/blog/2015/07/29/ios-concurrency-programming-operation-queues/)

* [ios多线程操作（六）—— GCD全局队列与主队列](http://subscribe.mail.10086.cn/subscribe/readAll.do?columnId=563&itemId=3130310)

  > 全局队列函数`dispatch_get_global_queue()`及其参数。

* [Objc中国期刊 第二期：并发编程](https://www.objccn.io/issues/)

  > 并发编程面临的挑战：资源共享导致的竞态条件、互斥锁、死锁、资源饥饿、优先级反转。
  >
  > 
  >
  > 我们建议采纳的安全模式是这样的：从主线程中提取出要使用到的数据，并利用一个操作队列在后台处理相关的数据，最后回到主队列中来发送你在后台队列中得到的结果。使用这种方式，你不需要自己做任何锁操作，这也就大大减少了犯错误的几率。
  >
  > Apple没有把 UIKit 设计为线程安全的类是有意为之的，将其打造为线程安全的话会使很多操作变慢。而事实上 UIKit 是和主线程绑定的，这一特点使得编写并发程序以及使用 UIKit 十分容易的，你唯一需要确保的就是**对于 UIKit 的调用总是在主线程中来进行**。

* [Apple: Threading Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html#//apple_ref/doc/uid/10000057i-CH12-SW1)

  > 苹果官方文档，描述了OS X 和 iOS 中一些关键框架的高级线程安全性。

* [iOS多线程全套：线程生命周期，多线程的四种解决方案，线程安全问题，GCD的使用，NSOperation的使用](http://www.jianshu.com/p/7649fad15cdb)

* Matt Galloway. Effective Objective-C 2.0: 编写高质量 iOS 与 OS X 代码的52个有效方法[M] .北京: 机械工业出版社，2014: 149-180.

  > [我的笔记](https://www.jianshu.com/p/67492063fd49)
  >
  > * 第41条：多用派发队列，少用同步锁。
  >
  > 这一条是针对读写的竞态条件而言的。作者推荐使用 GCD 方法中的同步队列以及栅栏块实现同步语义，而不是 @synchronized 块或者 NSLock 对象。
  >
  > * 第42条：多用 GCD，少用 performSelector 系列方法。
  >
  > performSelector 系列方法本身有许多不足：内存管理方面有疏忽、可处理的方法也有局限。
  >
  > performSelector 系列方法中有延后执行选择子，或者将其放在另一个线程上执行的方法，这些我们都可以通过 GCD 提供的方法来替换实现。
  >
  > * 第43条：掌握 GCD 及操作队列的使用时机。
  >
  > 在解决多线程与任务管理问题时，派发队列并非唯一方案。
  >
  > 操作队列提供了一套高层的 Objective-C API，能实现纯 GCD 所具备的绝大部分功能，而且还能完成一些更为复杂的操作，那些操作若改用GCD来实现，则需另外编写代码。
  >
  > * 第44条：通过 Dispatch Group 机制，根据系统资源状况来执行任务。
  > * 第45条：使用 dispatch_once 来执行只需运行一次的线程安全代码。
  >
  > 单例类的创建问题。
  >
  > * 第46条：不要使用 dispatch_get_current_queue。
  >
  > dispatch_get_current_queue 函数的行为常常与开发者所预期的不同。此函数已废弃，只应做调试之用。
  >
  > 由于派发队列是按层级来组织的，所以无法单用某个队列对象来描述当前队列这一概念。
  >
  > dispatch_get_current_queue 函数用于解决由不可重入的代码所引发的死锁，然而能用此函数解决的问题，通常也能改用“队列特定数据”来解决。

* Gaurav Vaish. 高性能 iOS 应用开发[M] .北京: 人民邮电出版社，2017: 89-116.