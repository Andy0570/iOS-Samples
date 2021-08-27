## LazyScrollView

- [GitHub: lazyscrollview](https://github.com/alibaba/lazyscrollview)
- [苹果核 - iOS 高性能异构滚动视图构建方案 —— LazyScrollView](http://pingguohe.net/2016/01/31/lazyscroll.html)
- [苹果核 - iOS 高性能异构滚动视图构建方案 —— LazyScrollView 详细用法](http://pingguohe.net/2017/03/02/lazyScrollView-demo.html)



LazyScrollView 用于解决异构滚动视图的复用回收问题。它可以支持跨 View 层的复用，用易用方式来生成一个高性能的滚动视图。

通过一个双索引可见区域组件发现算法，实现了跨父节点组件的高效回收和复用。

LazyScrollView 属于相对底层的视图层，在复用上提供的比较高的灵活度。一些更高程度的封装，比如类似 `UICollection` 的 Layout，对复用更简易的管理，对组件的解析、赋值等管理，我们都放在了 Tangram 里面。



### 实现 TMLazyScrollViewDataSource

```objective-c
@protocol TMLazyScrollViewDataSource <NSObject>

@required

/**
 * 返回 ScrollView 中 item 的个数
 *
 * @discussion 与 UITableView 的 'tableView:numberOfRowsInSection:' 类似
 */
- (NSUInteger)numberOfItemsInScrollView:(nonnull TMLazyScrollView *)scrollView;

/**
 * 根据 index 返回 TMLazyItemModel
 *
 * @discussion 与 UITableView 的 'tableView:heightForRowAtIndexPath:' 类似
 * 管理当前 item 视图的 muiID 以实现高性能。
 */
- (nonnull TMLazyItemModel *)scrollView:(nonnull TMLazyScrollView *)scrollView
                       itemModelAtIndex:(NSUInteger)index;

/**
 返回下标所对应的 view

 与 UITableView 的 'tableView:cellForRowAtIndexPath:' 类似
 它将在 item 模型中使用 muiID 而不是 index 索引。
 */
- (nonnull UIView *)scrollView:(nonnull TMLazyScrollView *)scrollView
                   itemByMuiID:(nonnull NSString *)muiID;

@end
```

第一个方法很简单，获取 `TMLazyScrollView` 中 item 的个数。

第二个方法需要按照 index 返回 `TMLazyItemModel` 对象，它会携带对应 index 的 View 相对 `TMLazyScrollView`  的绝对坐标：

```objective-c
@interface TMLazyItemModel : NSObject

// item 视图在 LazyScrollView 中的绝对坐标
@property (nonatomic, assign) CGRect absRect;
@property (nonatomic, readonly) CGFloat top;
@property (nonatomic, readonly) CGFloat bottom;

// item 视图在 LazyScrollView 中的唯一标识符
// 如果该值为 nil，将被设置为 index 的字符串值
// 该 ID 必须是唯一的！
@property (nonatomic, copy) NSString *muiID;

@end
```

第三个方法，返回 View。首先，我们在 UIView 之外加了一个 Category：

```objective-c
@interface UIView (TMLazyScrollView)

// 索引过的标识，在 LazyScrollView 范围内唯一
@property (nonatomic, copy) NSString *muiID;
// 重用的 ID
@property (nonatomic, copy) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;

@end
```



### 刷新视图

设置 `TMLazyScrollView` 对象的  `contentSize` ， 并且 `Reload`  即可。

```objective-c
 scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 1230);
 [scrollview reloadData];
```



### 视图的生命周期

如果 `- (UIView *)scrollView:(TMLazyScrollView *)scrollView itemByMuiID:(NSString *)muiID` 返回的 item 视图遵守 `<TMLazyItemViewProtocol>` 协议，并实现了以下方法，可以在组件的生命周期的时候执行相关代码：

```objective-c
/**
 如果 LazyScrollView 中的 item 视图实现了这个协议。
 它就可以在 LazyScrollView 的生命周期中接收到对应的事件。
 */
@protocol TMLazyItemViewProtocol <NSObject>

@optional

/**
 如果 item 视图在 'dequeueReusableItemWithIdentifier:' 中被重用，该方法就会被调用。
 在即将被复用时调用，通常用于清空 View 内展示的数据。
 它与 UITableViewCell 的 'prepareForReuse' 方法类似。 
 */
//准备复用的时候，做的动作。调用时机是在 dequeueReusableItemWithIdentifier 返回 View 之前
//调用 dequeueReusableItemWithIdentifier 一定会调用到这个方法
- (void)mui_prepareForReuse;

/**
 如果 item 视图被加载到缓冲区，该方法将被调用。
 这个回调通常用于设置（setup）项目视图。
 它与 UIViewController 的 'viewDidLoad' 方法类似。
 
 该方法在 LazyScrollView 执行完 - (UIView *)scrollView:(TMMuiLazyScrollView *)scrollView itemByMuiID:(NSString *)muiID 方法并获取到视图之后执行。
 
 和 didEnterWithTimes 的区别是，因为 LazyScrollView 有一个 RenderBuffer 的概念，实际渲染的视图比可视范围上下各增加了 20 个像素，使得展示更加流畅。afterGetView 会执行的更早。
 */
//提供一个渲染View的时机，生成View后执行
//在View从delegate中返回之后执行，推荐把布局视图等方法放在这个方法内
//如果是在Tangram的组件中使用，在这个方法执行的时候会带frame
- (void)mui_afterGetView;

/**
 当 item 视图进入滚动视图的可视范围内时执行。
 times 是进入可视范围的次数，从 0 开始。
 如果 item 视图进入可见区域，并且 LazyScrollView 被重新加载，这个回调将不会被调用。
 这个回调通常用于跟踪用户操作。有时，它也用于启动定时器事件。
 */
//当View进入视图范围内，调用这个方法，传入enter的次数，曝光埋点打在这里是精确的点
//注意：并非是在视图init的时候，视图init会受缓冲区的影响，生成View的范围比视图实际区域会大一些
//times 次数的意思,从0开始 0的意思是第一次，1第二次，以此类推
- (void)mui_didEnterWithTimes:(NSUInteger)times;

/**
 当 item 视图离开可视区域时，该方法将被调用。
 这个回调通常用于停止定时器事件。
 */
- (void)mui_didLeave;

@end
```

