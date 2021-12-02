//
//  HQLAutoHeight2TableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2017/6/16.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLAutoHeight2TableViewController.h"

@interface HQLAutoHeight2TableViewController ()

@property (nonatomic, copy) NSDictionary *dataSourceDictionary;

@end

@implementation HQLAutoHeight2TableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"TableViewCell自适应高度2";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors

- (NSDictionary *)dataSourceDictionary {
    if(!_dataSourceDictionary) {
        _dataSourceDictionary = @{
                                  @"职位":@"村长",
                                  @"姓名":@"张三",
                                  @"性别":@"男",
                                  @"身份证号码":@"123456789012345678",
                                  @"民族":@"汉族",
                                  @"电话号码":@"159159159159",
                                  @"个性签名":@"生活，是一个叹号和一个问号之间的犹豫。在疑问之后则是一个句号。",
                                   @"说说":@"很多人说爱情是没有缘由的，或许情况恰恰相反，每一个爱情的诞生和失去都是有根据的，只是它太小，太日常，太不浪漫，太不刺激，",
                                  @"座右铭":@"世界就是这样，笑个没完没了。每个人都会干蠢事，可在我看来，最蠢的莫过于从不干蠢事。",
                                  @"人生信条":@"人的境遇是一种筛子，筛选了落到我们视野里的人和事， 人一旦掉到一种境遇里，就会变成吸铁石，把铁屑都吸到身边来。",
                                  };
    }
    return _dataSourceDictionary;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellReusreIdentifier = @"UITableViewCellStyleValue1";
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellReusreIdentifier];
    }
    
    NSArray *allkey = [self.dataSourceDictionary allKeys];
    NSString *oneKey = allkey[indexPath.row];

    cell.textLabel.text = oneKey;
    cell.detailTextLabel.text = self.dataSourceDictionary[oneKey];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 参数一：最大宽高 44+19*4
    CGSize maxSize = CGSizeMake(355, MAXFLOAT);
    // 参数二：Font:
    UIFont *defaultFont = [UIFont systemFontOfSize:17.0f];
    // 参数三：String:
    NSArray *allKeys = [self.dataSourceDictionary allKeys];
    NSString *keyString = allKeys[indexPath.row];
    NSString *valueString = self.dataSourceDictionary[keyString];
    
    /*
     用这种方法计算的问题
     返回的cell会存在有的cell上下没有间隙，因为cell中的key和value并不是全文本一段段显示的，而是左右分隔显示的，
     所以该计算方法存在偏差。
     */
    NSString *keyAndValueStr = [keyString stringByAppendingString:valueString];
    CGSize resultSize = [self sizeOfText:keyAndValueStr font:defaultFont maxSize:maxSize];
    NSLog(@"result Size:(%f,%f) \n",resultSize.width,resultSize.height);
    
//    return resultSize.height + 23; // 23即消息上下的空间，可自由调整
    
    // 总高度 / 1行文本的高度 = 行数
    CGFloat labelNum = resultSize.height / 20.5;
    CGFloat height = 44.0 + (labelNum - 1) * 19.0;
    return height;
    
}

// 封装计算多行文本数据size方法
- (CGSize)sizeOfText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName:font};
    CGSize size = [text boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attrs
                                     context:nil].size;
    return size;
}


/**
 默认情况下
 Cell
   * size:(375.000000,44.000000)
   * contentView = 43.5
 Label
   * 字体： 系统17号字体，Interface builder 中的高=21
   * 17号字体时 label:高度为 UIFont.lineHeight:20.287109
   cell.detailTextLabel.intrinsicContentSize 高= 20.500000
 
 空白距离 43.5-20.5 = 23 ,即上下各 11.5
 

//}
**/

/**
 UIKit - NSString:
 计算并返回(在当前图形上下文中)(使用给定选项和显示特征)的指定矩形内绘制的接收器的边界。
 
 @param size 要绘制的矩形的大小。
 @param options 字符串绘图选项。
 @param attributes 要应用于字符串的文本属性字典。 这些属性可以应用于NSAttributedString对象，但在NSString对象的情况下，这些属性适用于整个字符串，而不是字符串中的范围。
 @param context 用于接收器的字符串绘制上下文，指定最小比例因子和跟踪调整。
 @return 使用给定选项和显示特征绘制的接收器的边界。 从该方法返回的直线起点是第一个字形起点。
 */
//- (CGRect)boundingRectWithSize:(CGSize)size
//                       options:(NSStringDrawingOptions)options
//                    attributes:(nullable NSDictionary<NSString *, id> *)attributes context:(nullable NSStringDrawingContext *)context NS_AVAILABLE(10_11, 7_0);

// 关于 options 选项:http://www.itdadao.com/articles/c15a197037p0.html

@end
