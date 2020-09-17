//
//  HQLYYLabelTestViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/9/16.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLYYLabelTestViewController.h"
#import <YYKit.h>

@interface HQLYYLabelTestViewController ()
@property (nonatomic, strong) YYLabel *textLabel;
@end

@implementation HQLYYLabelTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addYYLabel];
}

// MARK: 创建一个有展开/收起按钮的 YYLabel
- (void)addYYLabel {
    self.textLabel = [[YYLabel alloc] init];
    NSString *string = @"Hero 9 Black 的感光器升级到 20MP，让它可以录影最多 5K 30p 的视频，并保留 4K 60p 和 2.7K 240p 的高流畅度录影能力。\nHero 9 Black 的电池容量为 1,720mAh，比上一代提升 30%，且在低温环境下的性能提高。\n内置地平线修正功能，支持 30 秒视频预录，定时拍摄、限时拍摄、实况照片多种模式。还可实现 1080P 视频直播。";
    self.textLabel.text = string;
    self.textLabel.font = [UIFont systemFontOfSize:17.0f];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.numberOfLines = 0;
    self.textLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    
    self.textLabel.frame = CGRectMake(0, 0, kScreenWidth - 20, 63);
    self.textLabel.center = self.view.center;
    [self.view addSubview:self.textLabel];
    
    // 创建属性字符串"...展开"
    NSMutableAttributedString *expandString = [[NSMutableAttributedString alloc] initWithString:@"...展开"];
    expandString.font = self.textLabel.font;

    NSRange highlightRange = [expandString.string rangeOfString:@"展开"];
    [expandString setColor:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000]
                     range:highlightRange];
    
    // 创建一个“高亮”属性
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setFont:self.textLabel.font];
    [highlight setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];
    
    // !!!: 点击「展开」按钮，执行的动作
    __weak __typeof(self)weakSelf = self;
    highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf updateTextLabelWithText:strongSelf.textLabel.text];
    };
    [expandString setTextHighlight:highlight range:highlightRange];
    
    // 将属性字符串设置到 YYLabel 中
    YYLabel *expandLabel = [[YYLabel alloc] init];
    expandLabel.attributedText = expandString;
    [expandLabel sizeToFit];
    
    // 将此带高亮属性的 YYLabel 设置为整个 YYLabel 的截断符
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:expandLabel contentMode:UIViewContentModeCenter attachmentSize:expandLabel.size alignToFont:expandString.font alignment:YYTextVerticalAlignmentCenter];
    self.textLabel.truncationToken = truncationToken;
}

- (void)updateTextLabelWithText:(NSString *)string {
    // 创建属性字符串“收起”
    NSMutableAttributedString *collapseString = [[NSMutableAttributedString alloc] initWithString:@"收起"];
    collapseString.font = self.textLabel.font;
    collapseString.color = [UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000];
    
    // 创建一个“高亮属性”
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setFont:self.textLabel.font];
    [highlight setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];
    
    // !!!: 点击「收起」按钮，执行的动作
    __weak __typeof(self)weakSelf = self;
    highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.textLabel.frame = CGRectMake(0, 0, kScreenWidth - 20, 63);
        strongSelf.textLabel.center = self.view.center;
        strongSelf.textLabel.text = string;
    };
    [collapseString setTextHighlight:highlight range:collapseString.rangeOfAll];
    
    // 设置整个文本的属性字符串
    NSDictionary *attributes = @{
        NSFontAttributeName: self.textLabel.font,
        NSForegroundColorAttributeName: self.textLabel.textColor
    };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    // 将“收起”字符串附加到整个文本末尾
    [attributedString appendAttributedString:collapseString];
    self.textLabel.attributedText = attributedString;
    [self.textLabel sizeToFit];
}

@end
