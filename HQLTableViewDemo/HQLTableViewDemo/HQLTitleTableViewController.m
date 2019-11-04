//
//  HQLTitleTableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2017/3/17.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLTitleTableViewController.h"


/**
 添加两个协议：
 UITableViewDataSource 是表格视图的数据源协议；
 UITableViewDelegate 是表格视图的代理协议。
 */
@interface HQLTitleTableViewController ()

/** 头部视图*/
@property (strong, nonatomic) IBOutlet UIView *headerView;

/** 编辑按钮*/
@property (weak, nonatomic) IBOutlet UIButton *editButton;

/** 插入按钮*/
@property (weak, nonatomic) IBOutlet UIButton *insertButton;

/** 属性：可变数组，作为表格视图的数据源*/
@property (nonatomic,retain) NSMutableArray *dataSourceArray;

/** 编辑类型:删除\插入 */
@property (nonatomic,assign) UITableViewCellEditingStyle editingStyle;

@end

@implementation HQLTitleTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置nib文件创建的表头视图
    [self.tableView setTableHeaderView:self.headerView];
    
    // 清除单元格间的分隔线颜色
    self.tableView.separatorColor = [UIColor clearColor];
    // 清楚单元格之间的分隔线
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // 初始化索引路径对象，指定表格视图滑动到的目标位置
    NSIndexPath *scrollTo = [NSIndexPath indexPathForRow:11 inSection:0];
    // 执行表格视图的滑动动作
    [self.tableView scrollToRowAtIndexPath:scrollTo atScrollPosition:UITableViewScrollPositionTop animated:NO];

}

#pragma mark - Custom Accessors

- (UIView *)headerView {
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
                                      owner:self
                                    options:nil];
    }
    return _headerView;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        // 初始化数组，作为表格视图的数据源
        _dataSourceArray = [NSMutableArray arrayWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    }
    return _dataSourceArray;
}


#pragma mark - IBAction

// 编辑模式：排序移动
- (IBAction)editingStyleNoneButton:(id)sender {
    if (self.isEditing) {

        // 如果正在编辑中，点击按钮关闭编辑模式
        [self setEditing:NO animated:YES];
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        
        _insertButton.enabled = YES;
    }else {
        
        // 不在编辑模式中，点击按钮，打开编辑模式
        [self setEditing:YES animated:YES];
        _editingStyle = UITableViewCellEditingStyleNone;
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        // 禁用插入按钮
        _insertButton.enabled = NO;
    }
}

// 插入模式
- (IBAction)editingStyleInsertButton:(id)sender {
    if (self.isEditing) {
        
        // 如果正在插入中，点击按钮关闭
        _editingStyle = UITableViewCellEditingStyleDelete;
        [self setEditing:NO animated:YES];
        [sender setTitle:@"插入" forState:UIControlStateNormal];
        _editButton.enabled = YES;
        
    }else{
        
        // 不在编辑中，打开编辑模式
        _editingStyle = UITableViewCellEditingStyleInsert;
        [self setEditing:YES animated:YES];
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        // 禁用编辑按钮
        _editButton.enabled = NO;
    }
}


#pragma mark - UITableViewDataSource

// 设定表格的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

// 设定单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

// 初始化和返回表格视图的单元格，是最重要的一个代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建一个字符串，作为单元格的标识符
    static NSString *reuserIdentifier = @"Cell";
    
    // 单元格的标识符，可以看作是一种重用机制，此方法可以从所有已经开辟内存的单元格里面，选择一个具有同样标识符的、空闲的单元格。
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    
    // 如果没有可以重复使用的单元格，则创建新的单元格
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuserIdentifier];
    }
    
    // 索引路径用来标识单元格在表格中的位置。它有 section 和 row 两个属性，前者标识单元格处于第几个段落，后者标识单元格在段落中的第几行。
    NSUInteger num = indexPath.row;
    
    // 如果是偶数单元格,则设置为知更鸟蛋色的cell
    if (num % 2 == 0) {
    
        // 获取数组中的数据，指定为当前单元格的标题文字
        cell.textLabel.text = [self.dataSourceArray objectAtIndex:num];
        // 设置单元格的描述文字内容
        cell.detailTextLabel.text = @"Detail Information";
        
        // 设置单元格的背景颜色为知更鸟蛋色
        UIColor *robinEggColor = [UIColor colorWithRed:140/255.0f green:218/255.0f blue:247/255.0f alpha:1.0];
        cell.backgroundColor = robinEggColor;
        
        // 建立第一个图片对象，作为单元格默认状态的图片
        UIImage *img1 = [UIImage imageNamed:@"colorDog"];
        cell.imageView.image = img1;
        
        // 建立另一个图片对象，作为单元格被选中状态的图片
        UIImage *img2 = [UIImage imageNamed:@"blackDog"];
        cell.imageView.highlightedImage = img2;

    }else {
        
        // 如果是奇数单元格，则设置为另外一种背景色的cell
        cell.textLabel.text = [self.dataSourceArray objectAtIndex:num];
        cell.detailTextLabel.text = @"Detail Information";
        
        CGRect rect = CGRectMake(0, 0, 100, 100);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        UIColor *salmonColor = [UIColor colorWithRed:237/255.0f green:87/255.0f blue:96/255.0f alpha:1.0];
        view.backgroundColor = salmonColor;
        
        // 将视图作为单元格的背景视图，这里视图的作用仅仅是改变单元格背景色，您也可以根据需要，设定一张图片作为背景。
        [cell setBackgroundView:view];
        
        UIImage *img1 = [UIImage imageNamed:@"colorDog"];
        cell.imageView.image = img1;
        
        UIImage *img2 = [UIImage imageNamed:@"blackDog"];
        cell.imageView.highlightedImage = img2;
    }
    return cell;
}

//  表格视图的各个行是否可编辑，默认是YES
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 该代理方法，用来设定是否允许拖动单元格
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 该代理方法，用来处理单元格编辑结束后的动作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (editingStyle) {
            
        // 1.删除模式
        case UITableViewCellEditingStyleDelete:
        {
            // 获得当前编辑的单元格的行编号
            NSUInteger num = indexPath.row;
            // 从数组中将该单元格的内容清除，以保证数据的一致性
            [self.dataSourceArray removeObjectAtIndex:num];
            // 再从表格视图中清除该单元格
            NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
            
        // 2.插入模式
        case UITableViewCellEditingStyleInsert:
        {
            // 获得当前编辑的单元格的行编号
            NSUInteger num = indexPath.row;
            // 往数组中同步插入新数据，及时更新数据源
            [self.dataSourceArray insertObject:@"Nice day" atIndex:num];
            // 再往表格视图中插入新单元格
            NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
        }
            break;
        default:
            break;
    }
}

// 该代理方法，用来响应单元格的移动动作
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // 获得单元格移动前、后的位置
    NSUInteger fromRow = sourceIndexPath.row;
    NSUInteger toRow = destinationIndexPath.row;
    
    // 获得数组在单元格移动前的对象
    id object = [self.dataSourceArray objectAtIndex:fromRow];
    // 删除数组中单元格移动前位置的对象
    [self.dataSourceArray removeObjectAtIndex:fromRow];
    // 然后在数组中的目标位置，重新插入一份删除前保留的对象，以及时同步数据源，保证数据与界面的一致性
    [self.dataSourceArray insertObject:object atIndex:toRow];
    
}

#pragma mark - UITableViewDelegate

// 该代理方法，用来执行单元格被选中时的动作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    // 根据索引路径，获得被选中的单元格的对象
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        // 如果该单元格没有被选中，则将单元格设置为选中模式
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        // 如果该单元格已经被选中，则再次点击时，将恢复为默认模式
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

// 取消选中某一行之后调用
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

// 该代理方法，用来设定单元格的编辑方式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.设定单元格的编辑方式为删除模式
    //    return  UITableViewCellEditingStyleDelete;
    
    // 2.设定单元格的编辑方式为插入模式
//    return UITableViewCellEditingStyleInsert;
    
    // 3.设定单元格的编辑方式为编辑模式
//    return UITableViewCellEditingStyleNone;
    
    if (self.isEditing) {
        return _editingStyle;
    }else {
        return UITableViewCellEditingStyleDelete;
    }
}

@end
