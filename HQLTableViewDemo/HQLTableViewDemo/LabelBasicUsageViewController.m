//
//  LabelBasicUsageViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "LabelBasicUsageViewController.h"
#import <Chameleon.h>

@interface LabelBasicUsageViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation LabelBasicUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.flatWhiteColor;
    
    [self addLabel1];
    [self addLabel2];
    [self addlabel3];
    [self addLabel41];
    [self addLabel42];
    [self addLabel43];
    [self addLabel44];
    
    [self.view addSubview:self.label];
}

// MARK: 创建 UILabel 对象
- (void)addLabel1 {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(40, 100, 125, 24);
    label.tag = 5;
    label.text = @"创建 UILabel 对象";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor lightGrayColor];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.numberOfLines = 0;
    
    // 设置字体颜色，自适应深色模式
    if (@available(iOS 13.0, *)) {
        label.textColor = UIColor.labelColor;
    } else {
        label.textColor = [UIColor blueColor];
    }
    
    [self.view addSubview:label];
}

// MARK: 自动缩小文本字体以适应 label 宽度
- (void)addLabel2 {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 150, 80, 35)];
    label.text = @"缩小文本字体以适应宽度";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = UIColor.flatMintColor;
    
    // 当 Label 的宽度小于完整字符串宽度时，缩小文本字体以适应宽度
    label.adjustsFontSizeToFitWidth = YES;
    
    // 当 adjustsFontSizeToFitWidth = YES 时，如果文本 font 要缩小时,
    // 可以设置 baselineAdjustment来控制文本的基线位置，只有文本行数为1时有效。
    label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    label.numberOfLines = 1; // 默认为1，可以省略
    
    // 字体最小比例因子
    // 当文本字体缩小时，缩放比例 >= minimumScaleFactor
    label.minimumScaleFactor = 0.5;

    [self.view addSubview:label];
}

/**
 MARK: 根据字符串长度设置 Label 的 frame
 
 @brief 需要注意的是，该方法返回的 CGSize 是行数为 1 的情况下，计算出来的 Size。
 当它超过屏幕的宽度（[UIScreen mainScreen].bounds.size.width）时，还会存在文本显示不完全的问题。
 
 因此，该方法仅适用于短文本，还有一种情况是做跑马灯效果时会用到这种方法。
 */
- (void)addlabel3 {
    // 需要显示的字符串
    NSString *string = @"根据字符串长度设置 Label 的 frame";
    // 字符串在  UILabel 上显示时所使用的字体
    UIFont *font = [UIFont systemFontOfSize:18];
    // 计算 18 号字体下，该字符串的宽度和高度
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:font}];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 210, ceil(size.width), ceil(size.height))];
    label.text = string;
    label.font = font;
    label.backgroundColor = UIColor.flatGreenColor;
    [self.view addSubview:label];
}

/**
 MARK: 根据文本内容调整 UILabel 对象的大小
 
 - (CGSize)sizeThatFits:(CGSize)size;
 // return 'best' size to fit given size. does not actually resize view. Default is return existing view size
 // 返回“最佳”大小以适应给定的大小,默认返回已经存在的视图 size

 - (void)sizeToFit;
 // calls sizeThatFits: with current view bounds and changes bounds size.
 // 调用这个方法会改变当前 view 的 bounds.size
 */

// sizeToFit 示例
- (void)addLabel41 {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(40, 260, 125, 24);
    label.text = @"sizeToFit 示例";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    label.backgroundColor = UIColor.lightGrayColor;
    label.lineBreakMode = NSLineBreakByTruncatingTail;

    // 设置 sizeToFit
    [label sizeToFit];
    label.numberOfLines = 0;
    [self.view addSubview:label];
}

// sizeThatFits 示例
- (void)addLabel42 {
    UILabel *label = [[UILabel alloc] init];
    // 给标签对象设置一段较长的文本内容
    label.text = @"The appearance of labels is configurable, and they can display attributed strings, allowing you to customize the appearance of substrings within a label. You can add labels to your interface programmatically or by using Interface Builder.";
    label.textColor = UIColor.flatSkyBlueColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    // 设置标签不限制行数
    label.numberOfLines = 0;
    label.backgroundColor = UIColor.lightGrayColor;
    
    // 限定 label 的宽度和高度，让 label 在此范围内自适应
    CGSize size = [label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40*2, MAXFLOAT)];
    label.frame = CGRectMake(40, 300, ceil(size.width), ceil(size.height));
    // 将标签对象，添加到当前视图控制器的根视图
    [self.view addSubview:label];
}

// 测试方法 [UIColor colorWithWhite:1.0 alpha:0.8]
- (void)addLabel43 {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(40, 580, 200, 24);
    label.text = @"[White:1.0 alpha:0.8]";
    label.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    label.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:label];
}

- (void)addLabel44 {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(40, 610, 200, 24);
    label.text = @"rgba(255, 255, 255, 0.8)";
    label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    label.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:label];
}

#pragma mark - Custom Accessors

- (UILabel *)label {
    if (!_label) {
        // 创建 UILabel 对象
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(40, 480, 125, 24);
        // _label.backgroundColor = [UIColor lightGrayColor];
        _label.tag = 10;
        
        // 字体样式
        _label.text = @"Lazy Loading Label";
        _label.font = [UIFont systemFontOfSize:20];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor blueColor];
        
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        _label.numberOfLines = 0; // 设置不限制文本行数
        
        // !!!: 设置缩小文本字体以适应 UILabel 固定宽度
        // 当 Label 的宽度小于完整字符串宽度时，缩小文本字体以适应宽度
        _label.adjustsFontSizeToFitWidth = YES;
        // 字体最小缩放比例
        _label.minimumScaleFactor = 0.5;
        
        // !!!: 调整 UILabel 宽度以显示完整文本
        // 根据文本内容自动调整 UILabel 对象的大小，适用于单行文本。
        [_label sizeToFit];
        
        // 优化设置圆角（推荐方法）
        // 设置 layer 的背景颜色，这样就可以避免离屏渲染问题
        _label.layer.backgroundColor = HexColor(@"#62C067").CGColor;
        _label.layer.cornerRadius = 10;
        // _label.layer.masksToBounds = YES;
        
        // 设置边框
        _label.layer.borderWidth = 1.0;
        _label.layer.borderColor = [UIColor flatSkyBlueColor].CGColor;
    }
    return _label;
}

@end
