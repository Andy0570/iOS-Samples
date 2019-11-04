
//
//  HQLAutoHeightTableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2017/1/13.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLAutoHeightTableViewController.h"
#import "HQLAutoTableViewCell.h"

// 重用标识符
static NSString * const cellReusreIdentifier = @"UITableViewCell";

@interface HQLAutoHeightTableViewController ()

/** 2.2.2缓存高度：实现点击状态栏自动滚动到顶部*/
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;

/** 数据源*/
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HQLAutoHeightTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏标题&颜色
    self.navigationItem.title = @"自适应高度";
    // 注册重用cell
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([HQLAutoTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellReusreIdentifier];
    
//    // 2.1设置tableView自适应高度【方法1】
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

// 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 每行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 注册重用cell
    HQLAutoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier
                                                                 forIndexPath:indexPath];
    // 设置Cell内容
    NSDictionary *dictionary = self.dataArray[indexPath.row];
    NSArray *key = [dictionary allKeys];
   
    cell.keyLabel.text = key[0];
    cell.valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.valueLabel.text = [dictionary objectForKey:key[0]];
    return cell;
}

#pragma mark - UITableViewDelegate

// ⭐️⭐️⭐️
// 用一个字典做容器，在cell将要显示的时候在字典中保存这行cell的高度。
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

// ⭐️⭐️⭐️
// 2.2.1设置tableView自适应高度【方法2】
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 先去字典查看有没有缓存高度，有就返回，没有就返回一个大概高度
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    return (height ? height.floatValue : 100);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中，点按效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getters

// 列表数据源
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSDictionary *array1 = @{
                                 @"职位":@"村长"
                                 };
        [_dataArray addObject:array1];
        NSDictionary *array2 = @{
                                 @"姓名":@"张三"
                                 };
        [_dataArray addObject:array2];
        NSDictionary *array3 = @{
                                 @"性别":@"男"
                                 };
        [_dataArray addObject:array3];
        NSDictionary *array4 = @{
                                 @"身份证号码":@"123456789012345678"
                                 };
        [_dataArray addObject:array4];
        NSDictionary *array5 = @{
                                 @"民族":@"汉族"
                                 };
        [_dataArray addObject:array5];
        NSDictionary *array6 = @{
                                 @"电话号码":@"159159159159"
                                 };
        [_dataArray addObject:array6];
        NSDictionary *array7 = @{
                                 @"个性签名":@"生活，是一个叹号和一个问号之间的犹豫。在疑问之后则是一个句号。"
                                 };
        [_dataArray addObject:array7];
        NSDictionary *array8 = @{
                                 @"说说":@"很多人说爱情是没有缘由的，或许情况恰恰相反，每一个爱情的诞生和失去都是有根据的，只是它太小，太日常，太不浪漫，太不刺激，"
                                 };
        [_dataArray addObject:array8];
        NSDictionary *array9 = @{
                                 @"座右铭":@"世界就是这样，笑个没完没了。每个人都会干蠢事，可在我看来，最蠢的莫过于从不干蠢事。"
                                 };
        [_dataArray addObject:array9];
        NSDictionary *array10 = @{
                                  @"人生信条":@"人的境遇是一种筛子，筛选了落到我们视野里的人和事， 人一旦掉到一种境遇里，就会变成吸铁石，把铁屑都吸到身边来。"
                                 };
        [_dataArray addObject:array10];
    }
    return _dataArray;
}

@end
