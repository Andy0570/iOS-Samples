## 点击TableView列表展示WebView

注： **本文参考 *IOS编程（第四版）* 第21章 *web服务与UIwebView* 相关内容开发一款名为Nerdfeed的应用。展示 *UITableView* 与 *UIWebView* 相关知识内容，以为整理记录，作为日后开发过程中参考并使用。**

**Needfeed** 的作用是读取并通过 `UITableView`  显示 Big Nerd Ranch 提供的在线课程，选择某项课程会打开相应课程的网页。

![Needfeed](http://upload-images.jianshu.io/upload_images/2648731-04d5f253d8f0537a.gif?imageMogr2/auto-orient/strip)


要实现以上 Demo 所示的 Needfeed 应用，需要完成两项任务：   
1. 连接指定的 web 服务并获取数据，然后根据得到的数据创建模型对象。   
2. 使用 `UIWebView` 显示 Web 内容。



## 1. 创建HQLCoursesViewController类，并将其父类设置为UITableViewController

```objectivec
@interface HQLCoursesViewController : UITableViewController
```

### 遵守 `<UITableViewDataSource>` 协议的类需要实现数据源方法

> The UITableViewDataSource protocol is adopted by an object that mediates the application’s data model for a UITableView object. The data source provides the table-view object with the information it needs to construct and modify a table view.
> 当一个对象需要为应用程序的 `UITableView` 对象提供数据源模型时，采用`UITableViewDataSource` 协议。数据源则为 table-view 对象提供它需要建立和修改列表视图的信息。


遵守 `<UITableViewDataSource>` 协议必须（`@requored`）实现的两个方法：

```objectivec
// 向数据源获取并返回列表视图中给定段中的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;   

// 在列表视图的特定单元格位置插入请求到的数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;   
```

因此，我们先在 `HQLCoursesViewController.m` 中实现空的数据源方法，之后再作修改。

```objectivec
//返回行数
- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    return 0;
}

//获取用于显示第section个表格段、第row行数据的UITableViewCell对象
- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
```


## 2. 在 `AppDelegate.m` 中创建视图控制器对象
需要创建 `UINavigationControl` 对象，并将其设置为 `UIWindow` 的根视图控制器：

```objectivec
//创建coursesViewController对象 cvc
HQLCoursesViewController *cvc = [[HQLCoursesViewController alloc] initWithStyle:UITableViewStylePlain];

//UINavigationController对象 masterNav 是 cvc 的根视图控制器
UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:cvc];

self.window.rootViewController = masterNav;
```




## NSURL、NSURLRequest、NSURLSession和NSURLSessionTask

要从 web 服务器获取数据，Nerdfeed 需要使用 `NSURL`、`NSURLRequest`、`NSURLSession` 和 `NSURLSessionTask` 四个类。
 推荐阅读：[^1]

[^1]:http://www.cnblogs.com/kenshincui/p/4042190.html      

关系图：
![](http://upload-images.jianshu.io/upload_images/2648731-069f2b28b2799215.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


* `NSURL`对象负责以 **URL** 的格式保存 web 应用的位置。对大多数 web 服务，**URL** 将包含基地址（base address）、web 应用名和需要传送的参数。
* `NSURLRequest`对象负责保存需要传送给 web 服务器的全部数据，这些数据包括：一个`NSURL`对象、缓存方法（caching policy）、等待 web 服务器响应的最长时间和需要通过 HTTP 协议传送的额外信息（`NSMutableURLRequest` 是 `NSURLRequest` 的可变子类）。
* 每一个 `NSURLSessionTask` 对象都表示一个 `NSURLRequest` 的生命周期。`NSURLSessionTask` 可以跟踪 `NSURLRequest` 的状态，还可以对 `NSURLRequest` 执行取消、暂停和继续操作。`NSURLSessionTask` 有多种不同功能的子类，包括 `NSURLSessionDataTask`，`NSURLSessionUploadTask` 和 `NSURLSessionDownloadTask`。
* `NSURLSession` 对象可以看作是一个生产 `NSURLSessionTask` 对象的工厂。可以设置其生产出来的`NSURLSessionTask` 对象的通用属性，例如请求的内容、是否允许在蜂窝网络下发送请求等。`NSURLSession` 对象还有一个功能强大的委托，可以跟踪 `NSURLSessionTask` 对象的状态、处理服务器的认证要求等。



## 3. 构建URL与发送请求

### NSURLSession
`NSURLSession` 有两种不同的含义：第一种含义指 `NSURLSession` 类；第二种含义指一组用于处理网络请求的API。

此处使用第一种含义，首先在 `HQLCoursesViewController.m` 的类扩展中添加一个属性，用于保存`NSURLSession` 对象：

```objectivec
@property (nonatomic) NSURLSession *session;
```

接下来覆盖 `HQLCoursesViewController.m` 的 `initWithStyle:` 方法，创建 `NSURLSession` 对象：

```objectivec
- (instancetype) initWithStyle:(UITableViewStyle)style {

//创建NSURLSession对象
self = [super initWithStyle:style];

if (self) {
    
    self.navigationItem.title = @"BNRCourses";
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    _session = [NSURLSession sessionWithConfiguration:config
                                        //NSURLSessionConfiguration对象
                                             delegate:nil   //委托
                                        delegateQueue:nil]; //委托队列

}
 return self;
}
```



在 `HQLCoursesViewController.m` 中实现```fetchFeed```方法连接 web 服务器：
此处 `NSURLRequest` 使用默认的 **GET** 请求方法，若要使用 **POST** 方法，需要设置 **POST** 请求体。



```objectivec
// 获取数据方法
 -(void) fetchFeed {

//创建NSURLRequest请求对象
NSString *requestString = @"http://bookapi.bignerdranch.com/private/courses.json";
NSURL *url = [NSURL URLWithString:requestString];
NSURLRequest *req = [NSURLRequest requestWithURL:url];

//使用NSURLSession对象创建一个NSURLSessionDataTask对象，将NSURLRequest对象发送给服务器
NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                 completionHandler://block对象
                                  ^(NSData * _Nullable data,
                                    NSURLResponse * _Nullable response,
                                    NSError * _Nullable error) {
//接收数据    
NSString *json = [[NSString alloc] initWithData:data
                                       encoding:NSUTF8StringEncoding];
NSLog(@"%@",json);
    
//NSURLSessionDataTask在刚创建的时候处于暂停状态，需要手动调用resume方法恢复,让NSURLSessionDataTask开始向服务器发送请求。
[dataTask resume];    
}
```

Nerdfeed 应该在创建 `HQLCoursesViewController` 对象后就发起网络请求。修改 `HQLCoursesViewController.m`的 `initWithStyle:`方法，添加调用 `fetchFeed` 的方法。
session 对象创建完成后调用```[self fetchFeed];```

```objectivec
- (instancetype) initWithStyle:(UITableViewStyle)style {

  //创建NSURLSession对象
  self = [super initWithStyle:style];

  if (self) {

      self.navigationItem.title = @"BNRCourses";

      NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

      _session = [NSURLSession sessionWithConfiguration:config
                                          //NSURLSessionConfiguration对象
                                               delegate:nil   //委托
                                          delegateQueue:nil]; //委托队列
      [self fetchFeed];
  }

   return self;
}
```



## 4. JSON数据

JSON 数据只包含有限的几种基础对象，用于表示来自服务器的模型对象，例如数组、字典、字符串和数字。而每个 JOSN 文件是由这些基础对象嵌套组合而成的。



### 解析JSON数据

`NSJSONSerialization`：用于解析 JSON 数据。可以将 JSON 数据转换为 Objective-C 对象。**字典**会转换为`NSDictionary` 对象；**数组**会转换为`NSArray`对象；**字符串**会转换为`NSString`对象；**数字**会转换为`NSNumber`对象	        

```objectivec
NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                           options:0
                                                             error:nil];
NSLog(@"%@",jsonObject);
```


在 `HQLCoursesViewController.m` 的类扩展中添加一个属性用于保存在线课程数组。数组中的每一个元素都是一个`NSDictionary` 对象，表示一项课程的详细信息。

```objectivec
@interface HQLCoursesViewController () 

@property (nonatomic) NSURLSession *session;

//保存在线课程数组
@property (nonatomic,copy) NSArray *courses;

@end
```

然后修改 `NSURLSessionDataTask` 的 `completionHandler`：

```objectivec
NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                     completionHandler: //block对象
                                      ^(NSData * _Nullable data,
                                        NSURLResponse * _Nullable response,
                                        NSError * _Nullable error) {
        

        
        // 解析JSON数据
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:nil];
 		 //NSLog(@"%@",jsonObject)
        //将NSDictionary代表的课程存入数组
        self.courses = jsonObject[@"courses"];
        NSLog(@"%@",self.courses);
        
    }];
    
    //NSURLSessionDataTask在刚创建的时候处于暂停状态
    [dataTask resume];  //手动调用resume方法恢复
    
}
```



接下来修改 `UITableView` 的数据源方法，将课程的标题显示在相应的`UITableViewCell`中。最后还需要覆盖```viewDidLoad```方法，向`UITableView`注册`UITableViewCell`：

```objectivec
- (void) viewDidLoad {

[super viewDidLoad];

//重用UITableViewCell，向表视图注册应该使用的UITableViewCell
[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

}

//获取数据源
//UITableViewDataSource协议必须（@requored）实现的2个方法
////返回行数
- (NSInteger) tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {

//返回课程数目
return self.courses.count;
}

//获取用于显示第section个表格段、第row行数据的UITableViewCell对象
- (UITableViewCell *) tableView:(UITableView *)tableView
      cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//创建或重用UITableViewCell对象
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                         forIndexPath:indexPath];

NSDictionary *course = self.courses[indexPath.row];
cell.textLabel.text  = course [@"title"];//设置标题
return cell;
}
```


## 主线程
* 主线程有时也被称为用户界面线程（UI thread），这是由于修改用户界面的代码必须在主线程中运行。
* 当web服务请求成功后，`HQLCoursesViewController` 需要重新加载`UITableView`对象的数据（调用`UITableView`对象的```reloadData```方法），默认情况下`NSURLSessionDataTask`是在后台线程中执行```completionHandler:```的，为了让```reloadData```方法在主线程中运行，可以使用`dispatch_asynch`函数.

```objectivec
// 将NSDictionary代表的课程存入数组
self.courses = jsonObject[@"courses"];
NSLog(@"%@",self.courses);

dispatch_async(dispatch_get_main_queue(), ^{
    //重新加载UITableView对象的数据
    [self.tableView reloadData];        
```

## 5. UIWebView
⚠️ 官方建议，以 iOS 8 或者以后的版本运行的应用程序，使用 `WKWebView` 类而不是使用 `UIWebView`。

本人已对`UIWebView`、`WKWebView`官方文档作了粗略的翻译，可点击查看：

[API翻译：UIWebView](http://www.jianshu.com/p/bc935fab4e30) 、  [API翻译：WKWebView](http://www.jianshu.com/p/793d815006c5) 、  [API翻译：WebKit](http://www.jianshu.com/p/18d2f56b8414) 

课程返回的JSON数据中，每个Course对象都是一个NSDictionary对象，其中含有"url"键，值是一个URL字符串，表示对应的网址。
新建一个`HQLWebViewController`对象，父类是`UIViewController`：

```objectivec
#import <UIKit/UIKit.h>

@interface HQLWebViewController : UIViewController 

@property (nonatomic) NSURL *URL;

@end 
```


在 `HQLWebViewController.m` 中，加入以下代码：

```objectivec
@implementation HQLWebViewController

- (void) loadView {
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView ;
    
}

- (void) setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
    }
}

@end

```

在`HQLCoursesViewController.h`中，声明一个新属性，指向`HQLWebViewController`。

```objectivec
#import <UIKit/UIKit.h>
@class HQLWebViewController;

@interface HQLCoursesViewController : UITableViewController

@property (nonatomic) HQLWebViewController *webViewController;

@end
```


在`AppDelegate.m`中，创建`HQLWebViewController`对象并将其赋给`HQLCoursesViewController`对象的`webViewController`属性。


```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HQLCoursesViewController *cvc = [[HQLCoursesViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:cvc];
    
    HQLWebViewController *wvc = [[HQLWebViewController alloc] init];
    cvc.webViewController = wvc;
    
    self.window.rootViewController = masterNav;
        
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
```

在`HQLCoursesViewController.m`中导入`HQLWebViewController.h`,然后实现`UITableView`对象的数据源协议，用户点击`UITableView`对象中的某个`UITableViewCell`后，NerdFeed会创建`HQLWebViewController.h`对象并将其压入`UINavigationController`栈。

```objectivec
#import "HQLWebViewController.h"

@implementation HQLCoursesViewController

//获取用于显示第section个表格段、第row行数据的UITableViewCell对象
- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //创建或重用UITableViewCell对象
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                             forIndexPath:indexPath];
    
    NSDictionary *course = self.courses[indexPath.row];
    cell.textLabel.text  = course [@"title"];//设置标题
    return cell;
}

// 返回表格段数（section）目，不实现，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
```

### 6.认证信息
* web服务可以在返回HTTP响应时附带认证要求（authentication challenge）,只有当发起方提供相应的认证信息（比如用户名和密码），且当认证通过后，web服务才会返回真正的HTTP相应。

* 当应用收到认证要求时，NSURLSession的委托会收到```(void)URLSession:task:didReceiveChallenge:completionHandler:```消息，可以在该消息中发送用户名和密码，完成认证。

打开`HQLCoursesViewController.m`文件，修改```fetchFeed```方法中的URL地址将**http**改为**HTTPS**。

```NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";```

还需要在初始化时为NSURLSession设置委托。更新```initWithStyle：```方法,代码如下：

```objectivec
_session = [NSURLSession sessionWithConfiguration:config  // NSURLSessionConfiguration对象
                                         delegate:self    // 设置委托
                                    delegateQueue:nil];   // 委托队列
```

然后设置使`HQLCoursesViewController`遵守`<NSURLSessionDataDelegate>`协议：

```objectivec
@interface HQLCoursesViewController () <NSURLSessionDataDelegate>
```

实现 `-(void)URLSession:task:didReceiveChallenge:completionHandler:` 方法，处理认证信息：

```objectivec
//处理web服务认证
- (void) URLSession:(NSURLSession *)session
               task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
  completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    //凭据
    NSURLCredential *cred = [NSURLCredential
                             credentialWithUser:@"BigNerdRanch"
                             password:@"AchieveNerdvana"
                             persistence:NSURLCredentialPersistenceForSession];//认证信息有效期，枚举值
    
    //完成处理程序 completionHandler(认证类型，认证信息)
    completionHandler (NSURLSessionAuthChallengeUseCredential,cred);
}
```
