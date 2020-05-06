功能：使用 `UITableView` 实现一个名为 **Homepwner** 的应用，用来管理财产清单，通过 `UITableView` 对象显示一组 `BNRItem` 对象，实现表格行的添加、删除和移动操作。

要点：`UITableView`

![](http://upload-images.jianshu.io/upload_images/2648731-5b8f139165a3962e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 关于创建 Empty Application 空应用模板

很多老版的 iOS 入门教程会在创建新项目时使用 **Empty Application** 模板，因为空应用模板几乎没有多余的代码，而其他模板会生成很多通用的代码。这些代码虽然能帮助开发应用，但是对于初学者弊大于利。

而苹果在 **Xcode6** 开始就移除了 **Empty Application** 模板，因此我们无法直接创建 **Empty Application** 模板，但是可以通过先创建一个 **Single View Application** 模板，再修改一下就可以达到此目的：

1. 在 **Xcode** 中创建一个 **Single View Application** 模板；
2. 删除项目中的 **Main.storyboard** 和 **LaunchScreen.storyboard** 这两个 XIB 文件（鼠标选中并右击Delete）;
   ![](https://upload-images.jianshu.io/upload_images/2648731-db24f542ce439b16.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)
3. 在 **info.plist** 配置文件中删除 `Launch screen interface file base name` 和 `Main storyboard file base name` 这两项（选中该行，鼠标点击中间的灰白色减号按钮）
   ![](https://upload-images.jianshu.io/upload_images/2648731-794c19ac80971f1f.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
4. 打开 `AppDelegate.m` 文件，在委托方法 `application:didFinishLaunchingWithOptions:` 中修改如下:

   **Objective-C：**

   ```objectivec
   // 在此之前需要先导入根视图控制器的头文件： #import "ViewController.h"
   - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
       // 创建 UIWindow 对象
       self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
       // 设置 UIWindow 对象的根视图控制器
       ViewController *viewController = [[ViewController alloc] init];
       self.window.rootViewController = viewController;
       // 设置窗口背景色为白色
       self.window.backgroundColor = [UIColor whiteColor];
       // 设置窗口可见
       [self.window makeKeyAndVisible];
       return YES;
   }
   ```

   **Swift 3:**

   ```swift
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool 
   {
       self.window = UIWindow(frame: UIScreen.main.bounds)
       self.window?.backgroundColor = UIColor.white
       self.window?.makeKeyAndVisible()
       return true
   }
   ```

参考：

* [How to create an Empty Application in Xcode 6 without Storyboard @stackoverflow](http://stackoverflow.com/questions/25783282/how-to-create-an-empty-application-in-xcode-6-without-storyboard)
* [Xcode 7 创建 Empty Application 工程](http://featherj.org/?p=252)



# （一）TableView

## MVC设计模式

MVC（Model-View-Controller） 是模型-视图-控制器设计模式。其含义是，应用创建的任何一个对象，其类型必定是以下三种类型中的一种：

* 模型：负责存储数据，与用户界面无关。
* 视图：负责显示界面，与模型对象无关。
* 控制器：负责确保视图对象和模型对象的数据保持一致。

## UITableViewController

**视图控制对象**：该应用采用 **MVC** 的设计模式，`UITableView` 是视图，因此要通过视图控制对象来创建和释放 `UITableView` 视图对象，并负责显示或隐藏视图。

**数据源**：`UITableView` 对象要有数据源才能正常工作。`UITableView` 对象会向数据源查询要显示的行数、显示表格行所需要的数据和其他所需的数据。没有数据的 `UITableView` 对象只是空壳。凡是遵守 `<UITableViewDataSource>` 协议的 Objective-C 对象，都可以成为 `UITableView` 对象的数据源（即`dataSource` 属性所指向的对象）。

**委托对象**：还要为 `UITableView` 对象设置委托对象，以便能在该对象发生特定事件时做出相应的处理。凡是遵守 `<UITableViewDelegate>` 协议的对象，都可以成为 `UITableView` 对象的委托对象。

`UITableViewController` 对象可以扮演以上全部角色，包括 **视图控制对象**、**数据源**和**委托对象**。

`UITableViewController` 对象是 `UIViewController` 的子类，所以也有 `view` 属性。 `UITableViewController` 对象的 `view` 属性指向一个 `UITableView` 对象，并且这个 `UITableView` 对象由 `UITableViewController` 对象负责设置和显示。 `UITableViewController` 对象会在创建 `UlTableView` 对象后，为这个 `UITableView` 对象的 `dataSource` 和 `delegate` 赋值，并指向自己。

![Homepwner对象图](http://upload-images.jianshu.io/upload_images/2648731-1da18efd01ee1cc2.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/800)

### 1. 创建 UITableViewController 子类：HQLItemsViewController

```objectivec
#import <UIKit/UIKit.h>

@interface HQLItemsViewController : UITableViewController

@end
```

Tips: 如果你创建了一个 `UITableViewController` 的子类对象，那么就不需要再显式地声明该对象需要遵守 `dataSource` 和 `delegate` 协议了，因为它是默认遵守的，你只需要去实现协议方法即可。

```objectivec
self.tableView.dataSource = self;
self.tableView.delegate   = self;
```

### 2. 覆盖父类的指定初始化方法 `initWithStyle:`，将指定初始化方法改为`init：`

```objectivec
// 1️⃣ 在【新的指定初始化方法】中调用父类的指定初始化方法；
-(instancetype) init {
    //调用父类的指定初始化方法
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}

// 2️⃣ 覆盖父类的指定初始化方法，调用【新的指定初始化方法】。
- (instancetype) initWithStyle:(UITableViewStyle)style {
    return [self init];
}
```

在 `HQLItemsViewController.m` 文件中实现以上两个初始化方法后，可以确保无论向新创建的 `HQLItemsViewController` 对象发送哪一个初始化方法，初始化后的对象都会使用 `UITableViewStylePlain` 风格。



### 3.创建 HQLItemsViewController 对象

在 `AppDelegate.m` 文件中导入 `HQLItemsViewController.h` 文件并初始化创建 `HQLItemsViewController` 对象。

```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 创建TableView视图控制器
    HQLItemsViewController *itemsViewController = [[HQLItemsViewController alloc] init];
    self.window.rootViewController = itemsViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
```


### 4.为UITableView 对象设置内容

这里从外部导入了一个写好的 HQLItem 类的头文件和实现文件（HQLItem.h 和 HQLItem.m），该类用于生成一组随机数据。


```objectivec
//
//  HQLItem.h
//  2.1 RandomItems
//
//
/**
 *  该对象表示某人在真实世界拥有的一件物品
 *
 */
#import <Foundation/Foundation.h>

// 头文件声明顺序：实例变量、类方法、初始化方法、其他方法
@interface Item : NSObject

// 名称
@property (nonatomic, copy) NSString *itemName;
// 序列号
@property (nonatomic, copy) NSString *serialNumber;
// 价值
@property (nonatomic) int valueInDollars;
// 创建日期
@property (nonatomic, readonly, strong) NSDate *dateCreated;
// 照片的key
@property (nonatomic, copy) NSString *itemKey;

//类方法
+ (instancetype)randomItem;

// Item类的指定初始化方法
// instancetype,该关键字表示的返回值类型和调用方法的类型相同，
// init方法的返回值类型都声明为instancetype
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

// 其他初始化方法
- (instancetype)initwithName:(NSString *)name serialNumber:(NSString *)sNumber;
- (instancetype)initWithItemName:(NSString *)name;

@end


//
//  HQLItem.m
//  2.1 RandomItems
//
//

// #import 可以确保不会重复导入同一个文件
#import "Item.h"

@implementation Item

// 类方法
+ (instancetype)randomItem{
    
    //创建不可变数组对象，包含三个形容词
    NSArray *randomAdjectiveList = @[@"Fluffy",@"Rusty",@"Shiny"];
    
    //创建三个不可变数组对象，包含三个名词
    NSArray *randomNounList = @[@"Bear",@"Spark",@"Mac"];
    
    //根据数组对象所含对象的个数，得到随机索引
    //注意：运算符%是模运算符，运算后得到的是余数
    //因此 adjectiveIndex 是一个0到2（包括2）的随机数
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@%@",
                            randomAdjectiveList [adjectiveIndex],
                            randomNounList [nounIndex]];
    
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%C%C%C%C%C",
                                    (unichar)('0'+arc4random() % 10),
                                    (unichar)('A'+arc4random() % 26),
                                    (unichar)('0'+arc4random() % 10),
                                    (unichar)('A'+arc4random() % 26),
                                    (unichar)('0'+arc4random() % 10)];
    
    Item *newItem = [[self alloc] initWithItemName:randomName
                                    valueInDollars:randomValue
                                      serialNumber:randomSerialNumber];
    
    return newItem;
}


// 串联（chain）使用初始化方法
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber {
    
    self = [super init];
    //if(self):父类的指定初始化方法是否成功创建了父类对象？
    if(self){
        _itemName       = name;
        _serialNumber   = sNumber;
        _valueInDollars = value;
        // 设置_dateCreated的值为系统当前时间
        _dateCreated    = [[NSDate alloc] init];
        // 创建一个 NSUUID 对象，然后获取其 NSString 类型的值
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    //返回初始化后的对象的新地址
    return self;
}

- (instancetype)initwithName:(NSString *)name
                serialNumber:(NSString *)sNumber {
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:sNumber];
    
}

- (instancetype)initWithItemName:(NSString *)name {
    // 调用指定初始化方法
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}

- (instancetype)init {
    return [self initWithItemName:@"Item"];
}

// 覆写 description 方法
// %@,对应的实参类型是指向任何一种对象的指针，首先返回的是该实参的description消息
- (NSString *)description {
    NSString *descriptionString =
        [[NSString alloc] initWithFormat:@"%@(%@): ,Worth $%d ,recorded on %@",
                                        self.itemName,
                                        self.serialNumber,
                                        self.valueInDollars,
                                        self.dateCreated ];
    return descriptionString;
}


#pragma mark - NSCoding

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject :self.itemName       forKey      :@"itemName"];
    [aCoder encodeObject :self.serialNumber   forKey  :@"serialNumber"];
    [aCoder encodeObject :self.dateCreated    forKey   :@"dateCreated"];
    [aCoder encodeInt    :self.valueInDollars forKey:@"valueInDollars"];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        _itemName       = [aDecoder decodeObjectForKey     :@"itemName"];
        _serialNumber   = [aDecoder decodeObjectForKey :@"serialNumber"];
        _dateCreated    = [aDecoder decodeObjectForKey  :@"dateCreated"];
        _valueInDollars = [aDecoder decodeIntForKey  :@"valueInDollars"];
    }
    return self;
}

@end
```


### UITableView 数据源

* 在 **Cocoa Touch** 中，`UITableView` 对象会自己查询另一个对象以获得需要显示的内容，这个对象就是 `UITableView` 对象的数据源，也就是 `dataSource` 属性所指向的对象。   
* 该应用中，`UITableView` 对象的数据源就是 `HQLItemsViewController` 对象自己。所以要为 `HQLItemsViewController` 对象添加相应的属性和方法，使其能够保存多个 `HQLItem` 对象。
* 使用 `HQLItemStore` （类型为`NSMutableArray`）对象来负责保存和加载 `HQLItem` 对象，当某个对象需要访问所有的 `HQLItem` 时，可以通过 `HQLItemStore` 的 `allItems` 方法获取包含所有 `HQLItem` 的`NSMutableArray`。此外，`HQLItemStore` 还会负责将 `HQLItem` 存入文件，或者从文件重新载入。

### 5.创建 HQLItemStore
* `HQLItemStore` 对象是一个**单例**对象。也就是说，每个应用只会有一个这种类型的对象。如果应用尝试创建另一个对象，`HQLItemStore` 类就会返回已经存在的那个对象。

```objectivec
#import <Foundation/Foundation.h>

@interface HQLItemStore : NSObject

//将此类设置为单例对象
+ (instancetype)sharedStore;

@end
```

* 在 `HQLItemStore.m` 中实现 `sharedStore` 单例方法，同时编写一个抛出异常的 `init` 方法和私有指定初始化方法 `initPrivate`。


```objectivec
@implementation HQLItemStore

+ (instancetype)sharedStore {
    
    //将sharedStore声明为了静态变量，当某个定义了静态变量的方法返回时，程序不会释放相应的变量
    static HQLItemStore *sharedStore = nil;
    
    //判断是否需要创建一个sharedStore对象
    // （! sharedStore） 为真 ，即（sharedStore）为假，不存在
    if (! sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
    
}

// 如果误调用了 [[HQLItemstore alloc] init]，就提示应该使用 [HQLItemstore sharedStore]。
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [HQLItemStore sharedStore]"
                                 userInfo:nil];
    return  nil;
}

// 这是真正的（私有的）初始化方法
- (instancetype)initPrivate {
    self = [super init];  
    return self; 
}
```

* 在 `HQLItemStore.h` 中声明一个方法和一个属性，分别用于创建和保存 `HQLItem` 对象。

```objectivec
#import <Foundation/Foundation.h>

//@class 只需要使用类的声明，无需知道具体的实现细节
@class HQLItem;

@interface HQLItemStore : NSObject

//保存 HQLItem
//allItems属性被声明为NSArray（不可变数组），且设置为readonly，这样其他类既无法将一个新的数组赋给allItems，也无法修改allItems
//allItems属性对外部公开使用
@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;

//创建 HQLItem
- (HQLItem *)createItem;

@end
```


* 在 `HQLItemStore.m` 顶部导入 `HQLItem.h` 文件，以便之后向 `HQLItem.h` 对象发送消息。 
* 接下来在 `HQLItemStore.m` 的类扩展中声明一个可变数组。

```objectivec
#import "HQLItemStore.h"
#import "HQLItem.h"

@interface HQLItemStore ()

// 类扩展中为NSMutableArray（可变数组）
//privateItems属性只在内部使用
@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation HQLItemStore
...
```

* 在 `HQLItemStore.m` 中实现 `initPrivate` 方法，初始化 `privateItem` 属性。同时还需要覆盖 `allItem` 的取方法，返回 `privateItems`，同时实现 `createItem` 方法。

```objectivec
- (instancetype)initPrivate {
    self = [super init];
    //父类的init方法是否成功创建了对象
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    
   return self; 
}

- (Item *)createItem {
    
    HQLItem *item = [HQLItem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

//allItems取方法，返回值为NSArray类型
- (NSArray *)allItems {
    
   //方法体中返回值为NSMutableArray类型
   return self.privateItems;
}
```

### 6.实现数据源方法

在 `HQLItemsViewController.m` 顶部导入 `HQLItemStore.h` 和 `HQLItem.h`，然后更新指定初始化方法，创建 5 个随机的 HQLItem 对象并加入 HQLItemStore对象。


```objectivec
-(instancetype) init {
    //调用父类的指定初始化方法
    self = [super initWithStyle:UITableViewStyleGrouped];
    //初始化生成随机对象
    if (self) {
        for (int i = 0; i < 5; i ++) {
            [[HQLItemStore sharedStore] createItem];
        }
    }
    return self;
}
```

在 `QLItemViewController.m` 中实现数据源协议 `tableView: numberOfRowsInSection:` 方法 	

```objectivec
//返回应该显示的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		return [[[HQLItemStore sharedStore] allItems] count];
}
```

另一个必须要实现的数据源协议是 `tableView: cellForRowAtIndexPath:`

*注：实现该方法还涉及到另一个类：`UITableViewCell`，此类的详解及创建自定义子类日后分析*。

```objectivec
//获取用于显示第section个表格段、第row行数据的UITableViewCell对象
//返回各行所需视图,每个表格段对应一组独立的行
- (UITableViewCell *)tableView:(UITableView *)tableView
     cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];

//由协议获取已经分配的单元格，而不是分配一个新的,
//创建或重用UITableViewCell对象
//按照约定，应该将UITableViewCell或者UITableViewCell子类的类名用作reuseIdentifier。
UITableViewCell *cell = [tableView
    dequeueReusableCellWithIdentifier:@"UITableViewCell"
                         forIndexPath:indexPath];

//获取allItem的第n个 HQLItem 对象，这里的n是该UITableViewCell对象所对应的表格行索引
//然后将该Item对象的描述信息赋给UITableViewCell对象的textlabel
NSArray *items = [[HQLItemStore sharedStore] allItems];
HQLItem *item = items[indexPath.row];
cell.textLabel.text = [item description];
return cell;
```
}

### 7. 重用 UITableViewCell 对象
`UITableView` 对象会将移出窗口的 `UITableViewCell` 对象放入`UITableViewCell` 对象池，等待重用。当 `UITableView` 对象要求数据源返回某个 `UITableViewCell` 对象时，数据源可以先查看对象池。如果有未使用的`UITableViewCell` 对象，就可以用新的数据配置这个 `UITableViewCell` 对象，然后将其返回给 `UITableView` 对象，从而避免创建新对象。同时，为了重用 `UITableViewCell` 对象，需要将创建`UITableViewCell` 对象的过程交由系统管理，如果对象池中没有 `UITableViewCell` 对象，则由系统初始化创建所需类型的 `UITableViewCell` 对象。

```objectivec
- (void)viewDidLoad {
    [super viewDidLoad];

    // 重用 UITableViewCell，向表视图注册应该使用的 UITableViewCell 类型
    [self.tableView registerClass:[UITableViewCell class] 		
           forCellReuseIdentifier:@"UITableViewCell"];
}
```

### 8. 编辑模式

在编辑模式下，用户可以管理 `UITableView` 中的表格行，例如添加、删除和移动等操作。

为应用添加编辑模式的界面有两种方式：
1️⃣ 在视图控制器顶层添加 `NavigationController`；
2️⃣ 为 `UITableView` 对象添加表头视图。

#### 方法一：在视图控制器顶层添加导航视图控制器



1. 将导航视图控制器设置为根视图控制器

**AppDelegate.m:**

```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 创建 HQLItemsViewController 对象
    HQLItemsViewController *itemsViewController = [[HQLItemsViewController alloc] init];
    // 创建 UINavigationController 对象
    // 将 HQLItemsViewController 对象设置为 UINavigationController 对象的根视图控制器
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
    // 将 UINavigationController 对象设置为 UIWindow 对象的根视图控制器
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
```

2. 在 HQLItemsViewController.m 中设置导航栏标题和按钮

```objectivec
-(instancetype) init {
    // 调用父类的指定初始化方法
    self = [super initWithStyle:UITableViewStylePlain];
    // 初始化生成随机对象
    if (self) {
         
        // 设置导航栏标题
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        // 为导航栏设置【添加】和【编辑】按钮，以替换表头视图（headerView）
        // 创建新的 UIBarButtonItem 对象
        // 将其目标对象设置为当前对象，将其动作方法设置为 addNewItem
        UIBarButtonItem *bbi =  [[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                             target:self
                                             action:@selector(addNewItem:)];
        // 为 UINavigationItem 对象的 rightBarButtonItem 属性赋值，
        // 指向新创建的 UIBarButtonItem 对象
        navItem.rightBarButtonItem = bbi;
        
        // 为 UINavigationBar 对象添加编辑按钮
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}
```



####  方法二：为 `UITableView` 对象添加表头视图

1. 创建一个针对表格的表头视图   

创建一个新的 XIB 文件。cmd+N -> 在 User Interface 窗口中选择 **Empty**，将文件名设置为 `HeaderView.xib` 并保存。打开 Interface Builder 后，先拖拽一个`UIView` 对象至画布，再添加两个 `UIButton` 对象。  

![](http://upload-images.jianshu.io/upload_images/2648731-2d960c8c5df65d4c.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

> ⚠️ 注意一定要选择 **Empty** 类别的XIB文件，有一次我错选了 **View**，编译运行测试就是加载不出视图来，老纠结了😂

选中**File's Owner**,修改**Class**文本框为 `HQLItemsViewController`。

![](http://upload-images.jianshu.io/upload_images/2648731-2aa6a67734df2d82.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

接着选中 `UIView` 对象，将 `Size` 属性设置为 `Freeform` 以调整视图对象大小 。  
![](http://upload-images.jianshu.io/upload_images/2648731-c912f16dc686b839.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

将 `UIView` 对象的背景颜色改为全透明颜色，即 `ClearColor`.



2. 在 `HQLItemViewController.m` 的类扩展中声明插座变量 `headerView`，并添加两个动作方法。


```objectivec
@interface HQLItemsViewController ()

// 载入XIB文件后，headerView会指向XIB文件中的顶层对象，并且是强引用。
// ⚠️ 指向顶层对象的插座变量必须声明为强引用；相反，当插座变量指向顶层对象所拥有的对象（例如顶层对象的子视图时），应该使用弱引用。
@property (nonatomic,strong) IBOutlet UIView *headerView;

@end

@implementation HQLItemsViewController

// ...

#pragma mark 表头视图按钮

// 添加新项目
- (IBAction)addNewItem:(id)sender {
    // 创建新的 Item 对象并将其加入 HQLItemStore 对象
    Item *newItem = [[HQLItemStore sharedStore] createItem];
    // 获取新创建的对象在 allItem 数组中的索引
    NSInteger lastRow = [[[HQLItemStore sharedStore] allItems] indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow
                                                inSection:0];
    // 将新行插入UITableview对象
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
}

// 切换编辑模式
- (IBAction)toggleEditingMode:(id)sender {
    // 如果当前的视图控制对象已经处在编辑模式
    if (self.isEditing) {
        // 修改按钮文字，提示用户当前的表格状态
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        // 关闭编辑模式
        [self setEditing:NO animated:YES];
    }else {
        // 修改按钮文字，提示用户当前的表格状态
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        // 开启编辑模式
        [self setEditing:YES animated:YES];
    }
}
```



3. 在 `HQLItemsViewController.m` 中使用 **Lazy Loading** 方式实现 `hearerView` 的 `getter` 方法，载入应用程序包中的 XIB 文件。


```objectivec
// 载入headerView.xib文件
- (UIView *)headerView {
    
    // 如果还没有载入headerView
    if (!_headerView) {
        
        /* 载入指定的XIB文件
         *
         * 将 self 作为 owner 实参（拥有者）传给 NSBundle 对象，
         * 目的是当 HQLItemsViewController 将XIB文件加载为NIB文件时，
         * 使用 HQLItemsViewController 对象自身替换占位符对象 File's Owner
         *
         */
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    return _headerView;
}
```



4. 将 **headerView** 设置为 `UITableView` 对象的表头视图。在`HQLItemsViewController.m` 的 `ViewDidLoad` 方法中添加以下代码：

```objectivec
// 加载headerView，并将其设置为UITableView对象的表头视图
UIView *header = self.headerView;
[self.tableView setTableHeaderView:header];
```



### 9. 增加行

该应用中，增加行的实现方式是，在表视图上放置添加按钮，点击添加按钮之后系统调用 `createItem` 方法创建随机对象.   

### 10. 删除行

如果 `UITableView` 对象请求确认的是删除操作，删除 Homepwner 中的某个表格行（即 `UITableViewCell` 对象）步骤：   

1. 删除视图。从 `UITableView` 对象删除指定的 `UITableViewCell` 对象；   
2. 删除模型。找到和需要删除的 `UITableViewCell` 对象对应的 `HQLItem` 对象，也将其从`HQLItemStore` 中删除。   
​	
完成第 2 步需要在 `HQLItemStore.h` 中增加一个删除方法 `removeItem`，用于移除指定的 `HQLItem` 对象，接着在 `HQLItemStore.m` 文件中实现该方法。

`NSMutableArray` 中的删除方法：   
* `removeItem` 方法调用了 `NSMutableArray` 中的 `removeObjectIdenticalTo:` 比较指向对象的指针，该方法只会移除数组所保存的那些和传入对象指针完全相同的指针。
* `removeObject:` 该方法会枚举数组，向每一个对象发送 `isEqual:` 消息，判断当前对象和传入对象所包含的数据是否相等。

```objectivec
- (void)removeItem:(Item *)item {
[self.privateItems removeObjectIdenticalTo:item];
}
```

接下来为 `HQLItemViewController` 实现方法	`tableView：commitEditingStyle:forRowAtIndexPath：`

```objectivec
- (void)tableView:(UITableView *)tableView  //发送该消息的UITableView对象
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle    //编辑风格
forRowAtIndexPath:(NSIndexPath *)indexPath {    //相应表格行所在的表格段索引和行索引

//如果UITableView对象请求确认的是删除操作
if (editingStyle ==UITableViewCellEditingStyleDelete) {
    
    //先删除Item对象
    NSArray *items = [[HQLItemStore sharedStore] allItems];
    Item *deleteItem = items [indexPath.row];
    [[HQLItemStore sharedStore] removeItem:deleteItem];
    
    //还要删除表格视图中的相应表格行（带动画效果）
    [tableView deleteRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
}
}
```

### 11. 更改删除按钮的标题文本

删除 `UITableView` 对象中的某个表格行时，相应的 `UITableViewCell` 对象会在其右侧显示一个标题为“Delete”的按钮，先将该按钮标题改为中文“删除”。

```objectivec
- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  @"删除";
}
```


### 12. 移动行

要改变 `UITableView` 对象所显示的行的排列位置，需要为数据源实现另一个`UITableViewDataSource` 协议的方法，
首先要为数据源实现移动方法: `moveItemAtIndex:toIndex:`，为 `HQLItemStore` 增加该新方法，同样需要先在 .h 文件中声明，然后在 .m 文件中实现。

```objectivec
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }

    //得到要移动的对象的指针，以便稍后能将其插入新的位置
    Item *item = self.privateItems [fromIndex];

    //将item从allItem数组所在位置中移除
    [self.privateItems removeObjectAtIndex:fromIndex];

    //根据新的索引的位置，将item重新插回allItem数组新的位置
    [self.privateItems insertObject:item atIndex:toIndex];
}
```

接下来在 `HQLItemViewController.m` 中实现`tableView:moveRowAtIndexPath:toIndexPath:`，更新 `HQLItemStore` 对象。

```objectivec
- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
  toIndexPath:(NSIndexPath *)destinationIndexPath {

    [[HQLItemStore sharedStore]moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}
```



# （二）在代码中使用自动布局

将之前添加到 Interface Builder 中的 ImageView 删除，改用代码方式创建，并使用视觉格式化语言 **VFL** 为其自动布局：

* 通常，如果是创建整个视图层次结构及所有视图约束，就覆盖 `loadView` 方法；
* 如果只是向通过 NIB 文件创建的视图层次结构中添加一个视图或约束，就覆盖 `viewDidLoad` 方法。

```objectivec
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ------------------------
    // 在代码中使用自动布局 VFL 视觉化格式语言
    // 创建 UIImageView 对象
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    // 设置 UIImageView 对象的内容缩放模式
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // 在 Apple 引入自动布局系统之前，iOS 一直使用自动缩放掩码（autoresizing masks）缩放视图，以适配不同大小的屏幕。
    // 默认情况下，视图会将自动缩放掩码转换为对应的约束，这类约束经常会与手动添加的约束产生冲突。
    // 告诉自动布局系统不要将自动缩放掩码转换为约束
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    // 将 UIImageView 对象添加到 view 上
    [self.view addSubview:iv];
    // 将 UIImageView 对象赋给 imageView 属性
    self.imageView = iv;
    
    
    // 初始 UITextField 的内容放大优先级是 250，而 imageView 的内容放大优先级是 251
    // 如果用户选择了一张小尺寸图片，自动布局系统会增加 UITextField 对象的高度，使得高度超出 UITextField 对象的固有内容大小
    // 将 imageView 垂直方向的优先级设置为比其他视图低的数值
    // 设置垂直方向上的【内容放大优先级】
    [self.imageView setContentHuggingPriority:200
                                      forAxis:UILayoutConstraintAxisVertical];
    // 设置垂直方向上的【内容缩小优先级】
    [self.imageView setContentCompressionResistancePriority:700
                                                    forAxis:UILayoutConstraintAxisVertical];
    // 创建视图名称字典，将名称与视图对象关联起来
    NSDictionary *nameMap = @{
                              @"imageView" :self.imageView,
                              @"dateLabel" :self.dateLabel,
                              @"toolbar"   :self.toolbar
                              };
    // imageView 的左边和右边与父视图的距离都是0点
    NSArray *horizontalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                options:0
                                                metrics:nil
                                                  views:nameMap];
    // imageView 的顶边与 dateLabel 的距离是8点，底边与 toolbar 的距离也是8点
    NSArray *verticalConstrants = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                options:0
                                metrics:nil
                                  views:nameMap];
    
    // 将两个 NSLayoutConstraint 对象数组添加到 HQLDetailViewControl 的 view 中
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstrants];
    
}
```



### 视觉化格式语言（visual formart language，VFL）

* **视觉化格式语言** 定义了一系列使用字符串描述约束的象形语法，而这类字符串称为**视觉化格式字符串**。
* **视觉化格式字符串**可以描述一个方向上的多个约束。

| 字符                | 含义               |
| :---------------- | :--------------- |
| H                 | 水平方向（horizontal） |
| V                 | 垂直方向 (vertical)  |
| []                | 视图需要写在方括号[ ]中    |
| \|                | 表示父视图            |
| -10-              | 约束距离为10          |
| [someView] (==50) | 限定某个视图的宽或者高为50   |



* 描述水平间距的视觉化格式字符串：

```objective-c
@"H:|-0-[imageView]-0-|"
```
含义：imageView 的左边和右边与父视图的距离都是0点。

在视觉化格式语言中，0及其连接符可以省略不写，即

```objectivec
@"H:|[imageView]|"
```

更复杂的约束：

```objectivec
@"H:|-20-[imageView1]-10-[imageView2]-20-|"
```



* 垂直方向上：
* 在垂直方向上，字符串的左边表示顶边，右边表示底边。

```objectivec
@"V:[dateLabel]-[imageView]-[toolbar]"
```

含义：mageView 的顶边与 dateLabel 的距离是8点，底边与 toolbar 的距离也是8点。

```objectivec
@"V:[someView (==50)]"
```

含义：限定某个视图的宽或者高为50



为了让自动布局系统知道视觉格式化字符串中的名称所表示的视图对象，需要通过视图名称字典将名称与视图对象关联起来。

```objectivec
// 创建视图名称字典，将名称与视图对象关联起来
NSDictionary *nameMap = @{
                          @"imageView" :self.imageView,
                          @"dateLabel" :self.dateLabel,
                          @"toolbar"   :self.toolbar
                         };
```



#### 如何判断约束应该添加到哪个视图中？

*  如果约束同时对【多个父视图相同的视图】起作用，那么约束应该添加到它们的父视图中。
*  如果约束只对【某个视图自身】起作用，那么约束应该添加到该视图中。
*  如果约束同时对【多个父视图不同的视图】起作用，但是这些视图在层次结构中有共同的祖先视图，那么约束应该添加到它们最近一级的祖先视图中。
*  如果约束同时对【某个视图及其父视图】起作用，那么约束应该添加到它们的父视图中。

```objectivec
// 将两个 NSLayoutConstraint 对象数组添加到 HQLDetailViewControl 的 view 中
[self.view addConstraints:horizontalConstraints];
[self.view addConstraints:verticalConstrants];
```



### NSLayoutConstraint

```objectivec
// view1.attr1 relation view2.attr2 * multiplier + c 
+ (instancetype)constraintWithItem:(id)view1
                         attribute:(NSLayoutAttribute)attr1
                         relatedBy:(NSLayoutRelation)relation
                            toItem:(id)view2
                         attribute:(NSLayoutAttribute)attr2
                        multiplier:(CGFloat)multiplier
                          constant:(CGFloat)c;
```



# （三）自动转屏，UIPopoverController 与模态视图控制器

## 自动转屏

### 设备类型

物理设备类型

```objectivec
typedef enum UIUserInterfaceIdiom : NSInteger {
    UIUserInterfaceIdiomUnspecified = -1,
    UIUserInterfaceIdiomPhone,
    UIUserInterfaceIdiomPad,
    UIUserInterfaceIdiomTV,
    UIUserInterfaceIdiomCarPlay
} UIUserInterfaceIdiom;
```

### 设备方向（device orientation）

设备方向指的是设备的物理方向

```objectivec
typedef enum UIDeviceOrientation : NSInteger {
    UIDeviceOrientationUnknown,				// 未知方向
    UIDeviceOrientationPortrait,			// 正的竖排方向
    UIDeviceOrientationPortraitUpsideDown,	// 倒置方向
    UIDeviceOrientationLandscapeLeft,		// 左旋转方向
    UIDeviceOrientationLandscapeRight,		// 右旋转方向
    UIDeviceOrientationFaceUp,				// 正面朝上
    UIDeviceOrientationFaceDown				// 正面朝下
} UIDeviceOrientation;
```

### 界面方向（interface orientation）

界面方向指的是用户所看到的应用界面的方向。

```objectivec
typedef enum UIInterfaceOrientation : NSInteger {
  	// 未知方向
    UIInterfaceOrientationUnknown = UIDeviceOrientationUnknown,
  	// 竖排方向，主屏幕按钮位于屏幕下方
    UIInterfaceOrientationPortrait = UIDeviceOrientationPortrait,
    // 竖排方向，主屏幕按钮位于屏幕上方
    UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
    // 横排方向，主屏幕按钮位于屏幕右侧
    UIInterfaceOrientationLandscapeLeft = UIDeviceOrientationLandscapeRight,
  	// 横排方向，主屏幕按钮位于屏幕左侧
    UIInterfaceOrientationLandscapeRight = UIDeviceOrientationLandscapeLeft
} UIInterfaceOrientation;
```

## 自动转屏通告机制

* [Autorotate and orientation in iOS 8.1](https://forums.bignerdranch.com/t/autorotate-and-orientation-in-ios-8-1/7004)

```objectivec
// 视图即将显示时调用
- (void)viewWillAppear:(BOOL)animated {

    // 添加自动转屏通知：iPhone 横屏状态下禁用拍照按钮
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(deviceOrientationDidChange:)
               name:UIDeviceOrientationDidChangeNotification
             object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
}

// 视图即将出栈时调用
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
                  name:UIDeviceOrientationDidChangeNotification
                object:nil];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:orientation];
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation {
    // 如果是 iPad，则不执行任何操作
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // 判断设备是否处于横屏方向
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}
```



## ~~UIPopoverController~~ [Deprecated]

* [UIPopoverController is deprecated](https://forums.bignerdranch.com/t/uipopovercontroller-is-deprecated/7931)




## 类型为 **Block** 的 completion 实参

之前添加的新项目是直接插入列表中显示

```objectivec
// 添加新项目
- (IBAction)addNewItem:(id)sender {
    // 创建新的 Item 对象并将其加入 HQLItemStore 对象
    Item *newItem = [[HQLItemStore sharedStore] createItem];    
    // 获取新创建的对象在 allItem 数组中的索引
    NSInteger lastRow = [[[HQLItemStore sharedStore] allItems] indexOfObject:newItem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow
                                                inSection:0];
    // 将新行插入UITableview对象
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
}
```

现在点击 ”+” 按钮添加新项目 ➔ 把新项目以模态视图的方式显示在 **HQLDetailViewControl** 对象中；

如果选择 **Cancel** 取消，则删除刚刚创建的新项目。

如果选择 **Done** 完成，则添加新项目到列表中，返回的时候还要刷新列表。

![](https://upload-images.jianshu.io/upload_images/2648731-2a61e7f6fa3d4e56.gif?imageMogr2/auto-orient/strip)

实现步骤：

#### 1. **HQLDetailViewControl.h** 中添加一个 **Block** 属性。

```objectivec
@property (nonatomic, copy) void(^dismissBlock)(void);
```



#### 2. 添加新项目时，把新创建的 **HQLDetailViewControl** 对象以新创建的 **UINavigationController** 的根视图控制器模态呈现

```objectivec
// 添加新项目
- (IBAction)addNewItem:(id)sender {
    // 创建新的 Item 对象并将其加入 HQLItemStore 对象
    Item *newItem = [[HQLItemStore sharedStore] createItem];
    
    // 把新项目以模态视图的方式显示在 HQLDetailViewControl 对象中
    HQLDetailViewControl *detailViewController = [[HQLDetailViewControl alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    // 💡 Block 的代码块
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
  
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    // 修改视图控制器的模态样式（对于 iPad 有效）：页单样式
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}
```



#### 3. 修改指定初始化方法

```objectivec
- (instancetype)initForNewItem:(BOOL)isNew {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (isNew) {
            // 导航栏完成按钮
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                 target:self
                                                 action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            // 导航栏取消按钮
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                 target:self
                                                 action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem" userInfo:nil];
    return nil;
}
```



#### 4. 实现导航栏按钮,**模态退出时传入 Block 对象**

```objectivec
- (void)save:(id)sender {
    // UIViewController 对象的 presentingViewController 属性:
    // 当【某个 UIViewController 对象】以模态形式显示时，该属性会指向【~~显示该对象的那个 UIViewController 对象~~】(包含该对象的 UINavigationController 对象)
    // 所以下面一行代码的意思是 向 HQLItemsViewController 对象发送关闭模态视图消息
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}

- (void)cancel:(id)sender {
    // 如果用户按下了 Cancel 按钮，就从 HQLItemStore 对象移除新创建的 Item 对象
    [[HQLItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}
```



## 以模态形式显示视图控制器时的动画效果

```objectivec
typedef enum UIModalTransitionStyle : NSInteger {
    UIModalTransitionStyleCoverVertical = 0,	// 默认，从底部滑入
    UIModalTransitionStyleFlipHorizontal,		// 以3D 效果翻转
    UIModalTransitionStyleCrossDissolve,		// 淡入
    UIModalTransitionStylePartialCurl			// 模拟书页卷角
} UIModalTransitionStyle;
```

示例：

```objectivec
detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
```



## 线程安全的单例

在同一时间，单线程应用只能使用 CPU 的一个核，也只能执行一个函数。相反，多线程应用可以同时在不同的 CPU 核上执行多个函数。

### 单线程应用中创建单例

以 **HQLImageStore** 类为例：

```objectivec
#pragma 单例类
+ (instancetype)sharedStore{
    static HQLImageStore *sharedStore;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

// 私有化方法
- (instancetype) initPrivate{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// 不允许直接调用init方法
- (instancetype) init{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [HqlImageStore sharedStored]"
                                 userInfo:nil];
    return nil;
}
```

以上代码在单线程应用中可以正确创建单例，但是在多线程应用中，以上代码可能会创建多个 `HQLImageStore` 对象。同时，某个线程还可能会访问其他线程中没有正确初始化的 `HQLImageStore` 对象。



### 使用 `dispatch_once ()`

```objectivec
+ (instancetype)sharedInstance
{
   static id sharedInstance = nil;
   static dispatch_once_t onceToken = 0;
   dispatch_once(&onceToken, ^{
      sharedInstance = [[self alloc] init];
   });
   return sharedInstance;
}
```

有可用的代码块：😊

![](https://upload-images.jianshu.io/upload_images/2648731-b92685e7291492cb.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



## 视图控制器之间的关系

* ① 父—子关系；
* ② 显示—被显示关系；

###  

### ① 父—子关系

* 当使用 **视图控制器容器**（view controller container）时，就会产生拥有父—子关系的视图控制器。
* `UINavigationController`、`UITabBarController` 和 `UISplitViewController` 都是**视图控制器容器**。
* 容器对象会将 `viewControllers` 中的视图作为子视图加入自己的视图。
* 容器对象通常都有自己的默认外观。
* 处在同一个父—子关系下的视图控制器形成一个**族系**（family）。 



#### 对象相互访问：

* 任何容器对象都可以通过 `viewControllers` 访问其子对象。
* 子对象可以通过 `UIViewController` 对象的四个特定属性来访问其容器对象：
  * `navinavigationController`
  * `tabBarController`
  * `splitViewController`
  * `parentViewController`，该属性会指向族系中”最近”的那个容器对象。



### ② 显示—被显示关系；

* 当某个视图控制器以**模态形式**显示另一个视图控制器时，就会产生拥有显示—被显示关系的视图控制器。

* 在显示—被显示关系中，位于关系两头的视图控制器**不会处于同一个族系中**。被显示的视图控制器会有自己的族系。

* 当应用以模态形式显示某个视图控制器时，负责显示该视图控制器的将是相关族系中的**顶部视图控制器**。

* 如果设置 `definesPresentationContext` 属性为 **YES** ，那么该视图控制器就会自己负责显示新的视图控制器，而不是将“显示权”向上传递。

  

#### 对象相互访问

视图控制器 A——>模态形式显示视图控制器 B:

* A.`presentedViewController` = B 
* B.`presentingViewController` = A



# 保存、读取与应用状态

略.


# Auto Layout 中的两个属性

![](https://upload-images.jianshu.io/upload_images/2648731-fdc0b99d15d422bf.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* **Content Hugging Priority**: 内容放大优先级
* **Content Compression Resistance Priority**：内容缩小优先级

所有视图都具有 `intrinsicContentSize` 属性，表示视图的固有内容大小，自动布局系统会根据固有内容大小自动为视图添加宽度和高度约束。

如果需要让自动布局系统在必要时基于固有内容大小**放大**视图尺寸，则可以为视图添加一个优先级比视图的内容放大优先级（Content Hugging Priority）高的约束；

相反，如果需要让自动布局系统在必要时基于固有内容大小**缩小**视图尺寸，则可以为视图添加一个优先级比视图的内容缩小优先级（Content Compression Resistance Priority）高的约束；

> 高优先级的的视图会保持固有内容大小，低优先级的视图会根据当前约束拉伸或缩小该视图的高度或宽度。