//
//  HQLItemsViewController.m
//  HQLHomepwner
//
//  Created by ToninTech on 16/8/30.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLItemsViewController.h"
#import "HQLDetailViewControl.h"
#import "HQLItemStore.h"
#import "Item.h"
#import "HQLItemCell.h"
#import "HQLImageViewController.h"
#import "HQLImageStore.h"

static NSString *reuserIdentifier = @"UITableViewCell";

@interface HQLItemsViewController () <UIPopoverPresentationControllerDelegate, UIDataSourceModelAssociation>

// 载入XIB文件后，headerView 会指向XIB文件中的顶层对象，并且是强引用。
// ⚠️ 指向顶层对象的插座变量必须声明为强引用；相反，当插座变量指向顶层对象所拥有的对象（例如顶层对象的子视图时），应该使用弱引用。
//@property (nonatomic,strong) IBOutlet UIView *headerView;

@end

@implementation HQLItemsViewController

#pragma mark - Lifecycle

/**
 *  将 UITableViewController 的指定初始化方法改为 init：
 *  
 *  规则：
 *  1️⃣ 在【新的指定初始化方法】中调用父类的指定初始化方法；
 *  2️⃣ 覆盖父类的指定初始化方法，调用【新的指定初始化方法】。
 */

// 1️⃣
-(instancetype) init {
    
    // 调用父类的指定初始化方法
    self = [super initWithStyle:UITableViewStylePlain];
    // 初始化生成随机对象
    if (self) {
        
        // 创建5个随机的Item 对象
//        for (int i = 0; i < 5; i ++) {
//            [[HQLItemStore sharedStore] createItem];
//        }
        
        // 设置导航栏标题
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        // 创建恢复标识和恢复类
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
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
        
        // 注册观察者:UIContentSizeCategoryDidChangeNotification
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(updateTableViewForDynamicTypeSize)
                              name:UIContentSizeCategoryDidChangeNotification
                            object:nil];
    }
    return self;
}

// 2️⃣
- (instancetype) initWithStyle:(UITableViewStyle)style {
    return [self init];
}

// 视图已加载后调用
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 将创建 UITableViewCell 对象的过程交由系统管理
    // 重用 UITableViewCell，向表视图注册应该使用的 UITableViewCell 类型
    // 如果对象池中没有 UITableViewCell 对象，系统会根据要求初始化指定的 UITableViewCell 类型
    // 💡 如果重用的是 UITableViewCell 对象而不是自定义的 UITableViewCell 子类对象，这里的方法只能创建默认的 UITableViewCellStyleDefault 风格
//    [self.tableView registerClass:[UITableViewCell class]
//           forCellReuseIdentifier:reuserIdentifier];
    
    // 创建 UINib 对象，该对象代表包含了 HQLItemCell 的 NIB 文件。
    UINib *nib = [UINib nibWithNibName:@"HQLItemCell" bundle:nil];
    // 通过 UINib 对象注册相应的 NIB 文件
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HQLItemCell"];
    
    self.tableView.restorationIdentifier = @"HQLItemsViewControllerTableView";

    // 加载headerView，并将其设置为UITableView对象的表头视图
//    UIView *header = self.headerView;
//    [self.tableView setTableHeaderView:header];
    
    // 设置背景图片
//    [self settingTableViewImage];
    
    self.tableView.tableFooterView = [UIView new];
}

// 视图将要显示前调用
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 重新加载更新后的信息
    // detailViewController 中的数据更新后退回本页面需要刷新数据

    [self updateTableViewForDynamicTypeSize];
}

- (void)dealloc {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}


#pragma mark - Custom Accessors


// 载入headerView.xib文件
//- (UIView *)headerView {
//    
//    // 如果还没有载入headerView
//    if (!_headerView) {
//        
//        /* 载入指定的XIB文件
//         *
//         * 将 self 作为 owner 实参（拥有者）传给 NSBundle 对象，
//         * 目的是当 HQLItemsViewController 将XIB文件加载为NIB文件时，
//         * 使用 HQLItemsViewController 对象自身替换占位符对象 File's Owner
//         *
//         */
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
//                                      owner:self
//                                    options:nil];
//    }
//    return _headerView;
//    
//}


#pragma mark - IBActions

#pragma mark 表头视图按钮

// 添加新项目
- (IBAction)addNewItem:(id)sender {
    // 创建新的 Item 对象并将其加入 HQLItemStore 对象
    HQLItem *newItem = [[HQLItemStore sharedStore] createItem];
    
    // 把新项目以模态视图的方式显示在 HQLDetailViewControl 对象中
    HQLDetailViewControl *detailViewController = [[HQLDetailViewControl alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    // 修改视图控制器的模态样式（对于 iPad 有效）：页单样式
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}

/*
 
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
 
*/

#pragma mark - Private
- (void)settingTableViewImage {
    UIImageView *imageView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj3"]];
    self.tableView.backgroundView = imageView;
}

// 根据用户首选字体动态改变 UITableView 的行高
- (void)updateTableViewForDynamicTypeSize {
    static NSDictionary *cellHeightDictionary;
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{
                                 @"UICTContentSizeCategoryXS" : [NSNumber numberWithInt:44],
                                 @"UICTContentSizeCategoryS" : [NSNumber numberWithInt:50],
                                 @"UICTContentSizeCategoryM" : [NSNumber numberWithInt:55],
                                 @"UICTContentSizeCategoryL" : [NSNumber numberWithInt:60],
                                 @"UICTContentSizeCategoryXL" : [NSNumber numberWithInt:70],
                                 @"UICTContentSizeCategoryXXL" : [NSNumber numberWithInt:80],
                                 @"UICTContentSizeCategoryXXXL" : [NSNumber numberWithInt:90],
                                 @"UICTContentSizeCategoryAccessibilityM" : [NSNumber numberWithInt:100],
                                 @"UICTContentSizeCategoryAccessibilityL" : [NSNumber numberWithInt:105],
                                 @"UICTContentSizeCategoryAccessibilityXL" : [NSNumber numberWithInt:110],
                                 @"UICTContentSizeCategoryAccessibilityXXL" : [NSNumber numberWithInt:115],
                                 @"UICTContentSizeCategoryAccessibilityXXXL" : [NSNumber numberWithInt:120],
                                 };
    }
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

// 返回表格段数目（section），不实现，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 返回每个表格段应该显示的行数
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[[HQLItemStore sharedStore] allItems] count];
}

// 返回各行所需视图
// 获取用于显示第section个表格段、第row行数据的UITableViewCell对象
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    /** 重用 UITableViewCell 对象
     *
     *  UITableView 对象会将移出窗口的 UITableViewCell 对象放入 UITableViewCell 对象池，等待重用。
     *  当 UITableView 对象要求数据源返回某个 UITableViewCell 对象时，数据源可以先查看对象池。
     *  如果有未使用的 UITableViewCell 对象，就可以用新的数据配置这个 UITableViewCell 对象，然后将其返回给UITableView对象，从而避免创建新对象。
     */
    // 按照约定，应该将 UITableViewCell 或者 UITableViewCell 子类的类名用作 reuseIdentifier。
//    UITableViewCell *cell = [tableView
//        dequeueReusableCellWithIdentifier:reuserIdentifier
//                             forIndexPath:indexPath];
    
    // 获取 HQLItemCell 对象，返回的可能是现有的对象，也可能是新创建的对象
    HQLItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HQLItemCell"
                                                        forIndexPath:indexPath];
    
    // 获取 allItem 的第n个 Item 对象，这里的n是该 UITableViewCell 对象所对应的表格行索引
    // 然后将该 Item 对象的描述信息赋给 UITableViewCell 对象的 textlabel
    NSArray *items = [[HQLItemStore sharedStore] allItems];
    HQLItem *item = items[indexPath.row];
//    cell.textLabel.text = [item description];
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.backgroundColor = [UIColor clearColor];
    
    // 根据 Item 对象设置 HQLItemCell 对象
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d",item.valueInDollars];
    cell.thumbnailView.image = item.thumbnail;
    
    // 将 actionBlock 对 cell 的引用改为弱引用，消除引用循环
    
    UIImageView *thumbnailView = cell.thumbnailView;
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@",item);
        
        NSString *itemKey = item.itemKey;
        // 如果 Item 对象没有图片，就直接返回
        UIImage *img = [[HQLImageStore sharedStore] imageForKey:itemKey];
        if (!img) {
            return;
        }
        // 根据 UITableView 对象的坐标系获取 UIImageView 对象的位置和大小
        CGRect rect = [self.view convertRect:thumbnailView.bounds
                                    fromView:thumbnailView];

        // 创建 HQLImageViewConotroller 对象并为 Image 属性赋值
        HQLImageViewController *ivc = [[HQLImageViewController alloc] init];
        ivc.modalPresentationStyle = UIModalPresentationPopover;
        ivc.image = img;
        
        UIPopoverPresentationController *imagePopOver = [ivc popoverPresentationController];
        imagePopOver.delegate = self;
        // 根据 UIImageView 对象的位置和大小
        imagePopOver.sourceRect = rect;
        imagePopOver.sourceView = thumbnailView;
        [self presentViewController:ivc animated:YES completion:nil];
    };
    return cell;
}

/**
 *  在默认的情况下,UIPopoverPresentationController 会根据是否是 iphone 和 ipad 来选择弹出的样式,如果当前的设备是 iphone ,那么系统会选择 modal 样式,并弹出到全屏.如果我们需要改变这个默认的行为,则需要实现代理,在代理 - adaptivePresentationStyleForPresentationController: 这个方法中返回一个 UIModalPresentationNone 样式
 */
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}


/**
 删除

 @param tableView 发送该消息的UITableView对象
 @param editingStyle 编辑类型
 @param indexPath 相应表格行所在的表格段索引和行索引
 */
- (void)tableView:(UITableView *)tableView
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
         forRowAtIndexPath:(NSIndexPath *)indexPath {
    /** 如果UITableView对象请求确认的是删除操作
     *
     *  删除Homepwner中的某个表格行（UITableViewCell对象）步骤：
     *  1️⃣ 从 UITableView 对象删除指定的 UITableViewCell 对象；
     *  2️⃣ 找到和需要删除的 UITableViewCell 对象对应的 Item 对象，也将其从 HQLItemStore 中删除。
     */
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 先删除Item对象
        NSArray *items = [[HQLItemStore sharedStore] allItems];
        HQLItem *deleteItem = items[indexPath.row];
        [[HQLItemStore sharedStore] removeItem:deleteItem];
        // 还要删除表格视图中的相应表格行（带动画效果）
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

// 修改“删除”按钮的标题文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  @"删除";
}

// 移动行
- (void)tableView:(UITableView *)tableView
        moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
               toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [[HQLItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}


#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建 HQLDetailViewControl 对象，然后将新创建的对象压入 UINavigationController 对象的栈
    HQLDetailViewControl *detailViewControl =[[HQLDetailViewControl alloc] initForNewItem:NO];
    
    NSArray *items = [[HQLItemStore sharedStore] allItems];
    HQLItem *selectedItem = items[indexPath.row];
    //将选中的 Item 对象赋值给 DetailViewControl 对象
    detailViewControl.item = selectedItem;
    
    //将新创建的 HQLDetailViewControl 对象压入 UINavigationController 对象的栈
    [self.navigationController pushViewController:detailViewControl animated:YES];
}


#pragma mark - UIViewControllerRestoration

+ (nullable UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    return [[self alloc] init];
}

- (void) encodeRestorableStateWithCoder:(NSCoder *)coder {
    [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void) decodeRestorableStateWithCoder:(NSCoder *)coder {
    self.editing = [coder decodeBoolForKey:@"TableViewIsEditing"];
    [super decodeRestorableStateWithCoder:coder];
}

#pragma mark - UIDataSourceModelAssociation

- (nullable NSString *) modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view {
    NSString *identifier = nil;
    if (idx && view) {
        // 为 NSIndexPath 参数所对应的 Item 对象设置唯一标识符
        HQLItem *item = [[HQLItemStore sharedStore] allItems][idx.row];
        identifier = item.itemKey;
    }
    return identifier;
}

// 根据 Item 对象的唯一标识符返回其所在的 NSIndexPath
- (nullable NSIndexPath *) indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view {
    NSIndexPath *indexPath = nil;
    if (identifier && view) {
        NSArray *items = [[HQLItemStore sharedStore] allItems];
        for (HQLItem *item in items) {
            if ([identifier isEqualToString:item.itemKey]) {
                NSInteger row = [items indexOfObjectIdenticalTo:item];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    return indexPath;
}
@end
