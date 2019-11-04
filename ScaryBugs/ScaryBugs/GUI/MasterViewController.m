//
//  MasterViewController.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2017/12/27.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "MasterViewController.h"

// Controller
#import "DetailViewController.h"

// Model
#import "HQLScaryBugData.h"
#import "HQLScaryBugDoc.h"

// Framework
#import <CoreData/CoreData.h>
#import "Person+CoreDataClass.h"
#import "Person+CoreDataProperties.h"

#import "AppDelegate.h"

@interface MasterViewController ()


@end

@implementation MasterViewController {
    NSManagedObjectContext *context;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Scary Bugs";
    
    // 导航栏编辑按钮
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    // 导航栏添加“+”按钮
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.tableView.tableFooterView = [UIView new];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addTapped:(id)sender {
    if (!self.bugs) {
        self.bugs = [[NSMutableArray alloc] init];
    }
    
    // 1.添加空白模型，并刷新UI
    HQLScaryBugDoc *newDoc = [[HQLScaryBugDoc alloc] initWithTitle:@"New Bug" rating:0 thumbImage:nil fullImage:nil];
    [self.bugs insertObject:newDoc atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // 选中该行，自动进入详细列表界面编辑模型
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
    
}

// 当用户进入 detailViewController 更新数据并返回，刷新本列表视图以同步显示数据
- (void)didMoveToParentViewController:(UIViewController *)parent {
    [self.tableView reloadData];
}

#pragma mark - Segues

// 向下一个页面传递模型数据
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HQLScaryBugDoc *bug = self.bugs[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.detailItem = bug;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bugs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBasicCell" forIndexPath:indexPath];
    HQLScaryBugDoc *bug = [self.bugs objectAtIndex:indexPath.row];
    cell.textLabel.text = bug.data.title;
    cell.imageView.image = bug.thumbImage;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 如果是删除模式，删除对应的模型数据，并更新UI
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [_bugs removeObjectAtIndex:indexPath.row];
        
        HQLScaryBugDoc *doc=  [_bugs objectAtIndex:indexPath.row];
        [doc deleteDoc];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


#pragma mark - Test Method
- (void)coreDataTestMethod {
    
    //------------⭐️⭐️⭐️Core Data 添加数据⭐️⭐️⭐️----------------------
    // 1.获取 NSManagedObjectContext 上下文对象
    context = [AppDelegate new].context;
    
    // 2.使用 NSEntityDescription 创建 NSManagedObject 对象
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    person.name = @"Jack";
    person.age = 17;
    
    // 3.使用 NSManagedObjectContext 上下文对象保存 NSManagedObject 数据到 SQLite 数据库
    NSError *error;
    [context save:&error];
    
    //------------⭐️⭐️⭐️Core Data 查询数据⭐️⭐️⭐️----------------------
    /*
     
     Core Data 从数据库中查询数据，会用到三个类
     * NSFetchRequest:一条查询请求，相当于 SQL 中的 select 语句
     * NSPredicate:谓词，指定一些查询条件，相当于 SQL 中的 where 语句
     * NSSortDescriptor:指定排序规则，相当于 SQL 中的 order by
     
     ## NSFetchRequest
     属性 predicate ：是 NSPredicate 对象
     属性 sortDescriptors：是一个 NSSortDescriptor 数组，数组中前面的优先级比后面高。可以有多个排列规则
     
     其他属性：
     fetchLimit：结果集最大数，相当于 SQL 中的 limit
     fetchOffset：查询的偏移量，默认为0
     fetchBatchSize：分批处理查询的大小，查询分批返回结果集
     entityName/entity：数据表名，相当于 SQL 中的 from
     propertiesToGroupBy：分组规则，相当于 SQL 中的 group by
     propertiesToFetch：定义要查询的字段，默认查询全部字段
     
     设置好 NSFetchRequest 之后，调用 NSManagedObjectContext 上下文的 executeFetchRequest 方法执行查询请求，就会返回结果集
     
     */
    
    // Xcode 自动创建的 NSManagedObject 会生成 fetchRequest 方法，可以直接得到 NSFetchRequest
    NSFetchRequest *fetchRequest = [Person fetchRequest];
    
    // 也可以这样：直接查询实体名
    // [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    // 使用谓词
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"age == %@",@(18)];
    
    // 排序:按升序排序
    NSArray<NSSortDescriptor *> *sortDescriptor = @[[NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]];
    fetchRequest.sortDescriptors = sortDescriptor;
    
    // 使用 executeFetchRequest 方法得到结果集
    NSArray<Person *> *personResult = [context executeRequest:fetchRequest error:nil];
    
    
    // snippet:fetch
    /*
    // 指定要查询的实体
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"<#Entity name#>" inManagedObjectContext:<#context#>];
    [fetchRequest setEntity:entity];
     
    // 指定筛选要提取对象的条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
    [fetchRequest setPredicate:predicate];
     
    // 指定如何对抓取的对象进行排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"<#key#>"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    // 执行查询方法
    NSError *error = nil;
    NSArray *fetchedObjects = [<#context#> executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        <#Error handling code#>
    }
     */
    
    
    //------------⭐️⭐️⭐️Core Data 更改数据⭐️⭐️⭐️----------------------
    // 查询出要修改的数据后，直接修改值，然后用 context save 保存
    for (Person *person in personResult) {
        person.age = 23;
    }
    // 使用 NSManagedObjectContext 上下文保存修改结果
    [context save:&error];
    
    
    //------------⭐️⭐️⭐️Core Data 删除数据⭐️⭐️⭐️----------------------
    // 查询出来要删除的数据后，调用 NSManagedObjectContext 上下文的 deleteObject 方法删除数据
    for (Person *person in personResult) {
        // 删除数据
        if (person.age == 23) {
            [context deleteObject:person];
        }
    }
    // 使用 NSManagedObjectContext 上下文保存修改结果
    [context save:&error];
}

@end
