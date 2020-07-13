//
//  TableViewController.m
//  Colors
//
//  Created by Qilin Hu on 2020/7/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "TableViewController.h"

// Framework
#import "UIScrollView+EmptyDataSet.h"

// Controller
#import "SearchViewController.h"

// Model
#import "Palette.h"
#import "Color.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleSubtitle";
static NSString * const KSegueIdentifier = @"table_push_detail";

@interface TableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation TableViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Table";
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (IBAction)refreshColors:(id)sender {
    [[Palette sharedPalette] reloadAll];
    [self.tableView reloadData];
}

- (IBAction)removeColors:(id)sender {
    [[Palette sharedPalette] removeAll];
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Palette sharedPalette] colors].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.selectedBackgroundView = [UIView new];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.125 alpha:1.0];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    }
    
    Color *color = [[Palette sharedPalette] colors][indexPath.row];
    cell.textLabel.text = color.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"#%@",color.hex];
    cell.imageView.image = [Color roundThumbWithColor:color.color];

    return cell;
}

// MARK: 支持左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        // 执行删除操作
        case UITableViewCellEditingStyleDelete: {
            Color *color = [[Palette sharedPalette] colors][indexPath.row];
            [[Palette sharedPalette] removeColor:color];
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Color *color = [[Palette sharedPalette] colors][indexPath.row];
    
    if ([self shouldPerformSegueWithIdentifier:KSegueIdentifier sender:color]) {
        [self performSegueWithIdentifier:KSegueIdentifier sender:color];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// MARK: 支持长按复制
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
        return YES;
    }
    return NO;
}

// 长按 cell 复制时，显示弹出菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // 复制 Hex 值到剪切板
        if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
            Color *color = [[Palette sharedPalette] colors][indexPath.row];
            if (color.hex.length > 0) {
                [[UIPasteboard generalPasteboard] setString:color.hex];
            }
        }
    });
}

#pragma mark - <DZNEmptyDataSetSource>

// 空白页显示标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No colors loaded";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0],
        NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
        NSParagraphStyleAttributeName: paragraphStyle
    };
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

// 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"To show a list of random colors, tap on the refresh icon in the right top corner.\n\nTo clean the list, tap on the trash icon.";
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

// 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"empty_placeholder"];
}

// 设置空白页背景颜色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

// 设置空白页自定义视图
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}

// 设置空白页面元素视图之间的垂直距离，默认为 11pt。
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0;
}


#pragma mark - <DZNEmptyDataSetDelegate>

// 空白页面是否允许被点击以响应点击事件
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

// 空白页面是否允许被滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

// 空白页面视图被点击后调用
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:KSegueIdentifier]) {
        SearchViewController *controller = [segue destinationViewController];
        controller.selectedColor = sender;
    }
}

#pragma mark - View Auto-Rotation

// 支持转屏功能
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
