//
//  HQLSecongTableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/21.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLSecongTableViewController.h"
#import "HQLDataModel.h"
#import <objc/runtime.h>

static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";
char* const buttonKey = "buttonKey";

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface HQLSecongTableViewController ()

/** 列表每行的数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HQLSecongTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"医院科室";
    [self setupTableView];
}

- (void)setupTableView {
    // 重用UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReusreIdentifier];
    // 列表底部视图
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Custom Accessors

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        NSDictionary *JSON = @{@"group":
  @[
  @{@"groupName":@"内科",
    @"groupCount":@"9",
    @"groupArray":@[@"心血管内科",@"呼吸科",@"消化内科",@"神经内科",@"肾内科",@"血液科",@"风湿免疫科",@"感染性疾病科",@"内分泌科"]},
  @{@"groupName":@"外科",
    @"groupCount":@"7",
    @"groupArray":@[@"普外科",@"心胸外科",@"神经外科",@"肛肠科",@"泌尿外科",@"医疗美容科",@"烧伤整形科"]},
  @{@"groupName":@"骨科",
    @"groupCount":@"1",
    @"groupArray":@[@"骨科"]},
  @{@"groupName":@"妇产科",
    @"groupCount":@"1",
    @"groupArray":@[@"妇产科"]},
  @{@"groupName":@"儿科",
    @"groupCount":@"2",
    @"groupArray":@[@"儿科",@"儿外科"]},
  @{@"groupName":@"眼科",
    @"groupCount":@"1",
    @"groupArray":@[@"眼科"]},
  @{@"groupName":@"耳鼻咽喉头颈科",
    @"groupCount":@"1",
    @"groupArray":@[@"耳鼻喉科"]},
  @{@"groupName":@"口腔科",
    @"groupCount":@"1",
    @"groupArray":@[@"口腔科"]},
  @{@"groupName":@"皮肤性病科",
    @"groupCount":@"1",
    @"groupArray":@[@"皮肤性病科"]},
  @{@"groupName":@"肿瘤科",
    @"groupCount":@"3",
    @"groupArray":@[@"放疗科",@"立体定向科",@"肿瘤科"]},
  @{@"groupName":@"疼痛科",
    @"groupCount":@"1",
    @"groupArray":@[@"疼痛科"]},
  @{@"groupName":@"皮肤性病科",
    @"groupCount":@"1",
    @"groupArray":@[@"皮肤性病科"]},
  @{@"groupName":@"医学影像科",
    @"groupCount":@"1",
    @"groupArray":@[@"核医学科"]},
  @{@"groupName":@"皮肤性病科",
    @"groupCount":@"1",
    @"groupArray":@[@"皮肤性病科"]},
  @{@"groupName":@"中医科",
    @"groupCount":@"1",
    @"groupArray":@[@"中医科"]},
  @{@"groupName":@"其他",
    @"groupCount":@"3",
    @"groupArray":@[@"介入放射科",@"康复科",@"老年病科"]},
                                       ]
                               };

        /* NSDictionary -> HQLDataModel, 手动将字典对象转化为模型对象，
         * 这里建议使用框架转换，如 YYModel。
         *
         */
        for (NSDictionary *groupDictionary in JSON[@"group"]) {
            HQLDataModel *dataModel = [[HQLDataModel alloc]
                                       initWithState:false groupName:groupDictionary[@"groupName"] groupCount:[groupDictionary[@"groupCount"] integerValue]
                                       modelArray:groupDictionary[@"groupArray"]];
            [_dataSource addObject:dataModel];
        }
    }
    return _dataSource;
}

#pragma mark - IBAction
// headButton点击
- (void)buttonPress:(UIButton *)sender {
    HQLDataModel *dataModel = self.dataSource[sender.tag];
    UIImageView *imageView =  objc_getAssociatedObject(sender,buttonKey);
    if (dataModel.isOpen) {
        // 点击动画
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            CGAffineTransform currentTransform = imageView.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, -M_PI/2); // 在现在的基础上旋转指定角度
            imageView.transform = newTransform;
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionCurveLinear animations:^{
            CGAffineTransform currentTransform = imageView.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, M_PI/2); // 在现在的基础上旋转指定角度
            imageView.transform = newTransform;
        } completion:nil];
    }
    // 切换状态
    dataModel.isOpen = !dataModel.isOpen;
    // 重新加载section
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource

// 显示段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return self.dataSource.count;
}

// 动态显示每段行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HQLDataModel *dataModel = self.dataSource[section];
    NSInteger count = dataModel.isOpen?dataModel.modelArray.count:0;
    return count;
}

// 每行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier forIndexPath:indexPath];
    HQLDataModel *dataModel = self.dataSource[indexPath.section];
    NSArray *modelArray = dataModel.modelArray;
    cell.textLabel.text = modelArray [indexPath.row];
    // 辅助指示器
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

// ⭐️⭐️⭐️自定义头部视图，返回按钮
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HQLDataModel *dataModel = self.dataSource[section];
    // 设置UIButton
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [button setTag:section];
    // 设置标题
    [button setTitle:dataModel.groupName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 设置Image
    if (dataModel.isOpen) {
        [button setImage:[UIImage imageNamed:@"ico_list"] forState:UIControlStateNormal];
        CGAffineTransform currentTransform = button.imageView.transform;
        CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, M_PI/2); // 在现在的基础上旋转指定角度
        button.imageView.transform = newTransform;
        objc_setAssociatedObject(button, buttonKey, button.imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else {
        [button setImage:[UIImage imageNamed:@"ico_list"] forState:UIControlStateNormal];
        objc_setAssociatedObject(button, buttonKey, button.imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    // 设置偏移量
    CGFloat imageOriginX = button.imageView.frame.origin.x;
    CGFloat imageWidth = button.imageView.frame.size.width;
    CGFloat titleOriginX = button.titleLabel.frame.origin.x;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -titleOriginX+imageWidth + 20, 0, titleOriginX-imageWidth-20)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -imageOriginX + 10, 0, imageOriginX -  10);
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0];
    // 添加点击事件
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// 头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

// 底部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

@end
