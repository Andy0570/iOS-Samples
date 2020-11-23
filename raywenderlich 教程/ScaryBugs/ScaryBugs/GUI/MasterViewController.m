//
//  MasterViewController.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2020/11/21.
//

#import "MasterViewController.h"

// Controller
#import "DetailViewController.h"

// View

// Model
#import "RWTScaryBugDoc.h"
#import "RWTScaryBugData.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 导航栏编辑按钮
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // 导航栏添加“+”按钮
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.title = @"Scary Bugs";
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Actions

- (void)addTapped:(id)sender {
    if (!self.bugs) {
        self.bugs = [NSMutableArray array];
    }
    
    // 1.添加空白模型，并刷新UI
    RWTScaryBugDoc *newDoc = [[RWTScaryBugDoc alloc] initWithTitle:@"New Bug" rating:0 thumbImage:nil fullImage:nil];
    [self.bugs insertObject:newDoc atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // 2.选中该行，自动进入详细列表界面编辑模型
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self performSegueWithIdentifier:@"MySegue" sender:self];
}

#pragma mark - Segues

// 当用户进入 detailViewController 更新数据并返回，刷新本列表视图以同步显示数据
- (void)didMoveToParentViewController:(UIViewController *)parent {
    [self.tableView reloadData];
}

// 向下一个页面传递模型数据
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MySegue"]) {
        DetailViewController *controller = (DetailViewController *)segue.destinationViewController;
        RWTScaryBugDoc *bug = [self.bugs objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        controller.detailItem = bug;
//        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bugs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBasicCell" forIndexPath:indexPath];
    RWTScaryBugDoc *bug = [self.bugs objectAtIndex:(NSUInteger)indexPath.row];
    cell.textLabel.text = bug.data.title;
    cell.imageView.image = bug.thumbImage;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 如果是删除模式，删除对应的模型数据，并更新UI
        
        // 1.删除内存数据
        [_bugs removeObjectAtIndex:indexPath.row];
        
        // 2.删除磁盘数据
        RWTScaryBugDoc *doc = [_bugs objectAtIndex:indexPath.row];
        [doc deleteDoc];
        
        // 3.更新列表 UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

@end
