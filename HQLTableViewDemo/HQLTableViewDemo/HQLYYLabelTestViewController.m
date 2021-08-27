//
//  HQLYYLabelTestViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/9/16.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLYYLabelTestViewController.h"
#import <YYKit.h>
#import <Chameleon.h>
#import <JKCategories.h>
#import <Masonry.h>

@interface HQLYYLabelTestViewController ()
@property (nonatomic, strong) YYLabel *textLabel;
@property (nonatomic, strong) YYLabel *serviceAgreementLabel;
@property (nonatomic, strong) YYLabel *addressLabel;
@end

@implementation HQLYYLabelTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //  添加带 Image 的 Tag 标签
    [self addTagLabel];
    
    // 创建一个有展开/收起按钮的 YYLabel
    [self addYYLabel];
    
    // 详细地址：Image + 文字
    [self.view addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).with.offset(10);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(10);
    }];
    [self renderAddressLabel];
    
    // 用户协议说明字符串
    [self.view addSubview:self.serviceAgreementLabel];
    [self.serviceAgreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

/**
 FIXME: 添加带 Image 的 Tag 标签
 
 需要实现的样式：Image 在文本前面，YYLabel 宽度需要稍微比文本宽，以适应裁减的圆角
 */
- (void)addTagLabel {
    NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    UIColor *textColor = UIColorHex(#F57C00);
    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSForegroundColorAttributeName : textColor
    };
    
    UIImage *tagImage = [UIImage imageNamed:@"topicTag"];
    tagImage = [UIImage imageWithCGImage:tagImage.CGImage scale:2 orientation:UIImageOrientationUp];
    
    NSMutableAttributedString *attachImage = [NSMutableAttributedString attachmentStringWithContent:tagImage contentMode:UIViewContentModeCenter attachmentSize:tagImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [attributedString appendAttributedString:attachImage];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"我是一个图文结合的标签" attributes:attributes]];
    
    YYLabel *tagLabel = [YYLabel new];
    tagLabel.userInteractionEnabled = NO;
    tagLabel.attributedText = attributedString;
    tagLabel.layer.backgroundColor = UIColorHex(#FFE0B2).CGColor;
    tagLabel.layer.cornerRadius = 5.0f;
//    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    [self.view addSubview:tagLabel];
//    CGSize size = [attributedString size];
//    tagLabel.size = CGSizeMake(size.width + 20, size.height + 6);
    [tagLabel sizeToFit];
//    CGSize size = tagLabel.size;
//    tagLabel.size = CGSizeMake(size.width + 30, size.height);
    tagLabel.center = CGPointMake(100, 150);
}

// MARK: 创建一个有展开/收起按钮的 YYLabel
- (void)addYYLabel {
    self.textLabel = [[YYLabel alloc] init];
    NSString *string = @"Hero 9 Black 的感光器升级到 20MP，让它可以录影最多 5K 30p 的视频，并保留 4K 60p 和 2.7K 240p 的高流畅度录影能力。\nHero 9 Black 的电池容量为 1,720mAh，比上一代提升 30%，且在低温环境下的性能提高。\n内置地平线修正功能，支持 30 秒视频预录，定时拍摄、限时拍摄、实况照片多种模式。还可实现 1080P 视频直播。";
    self.textLabel.text = string;
    self.textLabel.font = [UIFont systemFontOfSize:17.0f];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.numberOfLines = 0;
    // MARK: 多行文本设置最大宽度
    self.textLabel.preferredMaxLayoutWidth = kScreenWidth-30;
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
    
    // 创建一个“高亮"属性
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

#pragma mark - Custom Accessors

// 登录即代表您已经同意《用户协议》
- (YYLabel *)serviceAgreementLabel {
    if (!_serviceAgreementLabel) {
        _serviceAgreementLabel = [[YYLabel alloc] init];
        _serviceAgreementLabel.textAlignment = NSTextAlignmentCenter;
        NSString *string = @"登录即代表您已经阅读并同意用户协议";
        NSUInteger stringLength = string.jk_wordsCount;
        UIFont *font = [UIFont systemFontOfSize:15];
        
        // 全局字体颜色
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSDictionary *attributes1 = @{
            NSForegroundColorAttributeName:[UIColor lightGrayColor],
            NSFontAttributeName:font
        };
        [attributedString setAttributes:attributes1 range:NSMakeRange(0, stringLength - 4)];
        
        // 用户协议，蓝色下划线
        NSRange serviceAgreementRange = NSMakeRange(stringLength - 4, 4);
        NSDictionary *attributes2 = @{
            NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#007AFF"],
            NSFontAttributeName:font,
            NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
            NSUnderlineColorAttributeName: [UIColor colorWithHexString:@"#007AFF"]
        };
        [attributedString setAttributes:attributes2 range:serviceAgreementRange];
        
        // 用户协议，高亮点击事件
        __weak __typeof(self)weakSelf = self;
        [attributedString setTextHighlightRange:serviceAgreementRange
                                          color:[UIColor colorWithHexString:@"#007AFF"]
                                backgroundColor:[UIColor colorWithHexString:@"#CECED2"]
                                      tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            //[weakSelf.view jk_makeToast:@"点击高亮文本"];
            [weakSelf showMessage:@"点击高亮文本"];
        }];
        
        _serviceAgreementLabel.attributedText = attributedString;
    }
    return _serviceAgreementLabel;
}

// 详细地址
- (YYLabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[YYLabel alloc] init];
        _addressLabel.layer.backgroundColor = [UIColor flatGreenColor].CGColor;
        _addressLabel.layer.cornerRadius = 10.0f;
        _addressLabel.userInteractionEnabled = NO;
        _addressLabel.font = [UIFont systemFontOfSize:12.0f];
        _addressLabel.textColor = HexColor(@"#5E99FF");
        _addressLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _addressLabel.numberOfLines = 1;
        
        // !!!: 这俩设置不能同时使用
        //_addressLabel.preferredMaxLayoutWidth = kScreenWidth - 16 * 2;
        _addressLabel.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10);
        /**
         上述设置可以替代增加详细地址标签的宽度
         if ([_subject.detailAddress isNotBlank]) {
             CGFloat addressTextWidth = [_subject.detailAddress widthForFont:self.addressLabel.font];
             [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                 make.size.mas_equalTo(CGSizeMake(addressTextWidth + 20, 20));
             }];
         }
         */
        
    }
    return _addressLabel;
}

- (void)renderAddressLabel {
    NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: UIColor.whiteColor
    };
    
    // 定位图片
    UIImage *locationImage = [UIImage imageNamed:@"store_location"];
    locationImage = [UIImage imageWithCGImage:locationImage.CGImage scale:2 orientation:UIImageOrientationUp];
    NSMutableAttributedString *attachImage = [NSMutableAttributedString attachmentStringWithContent:locationImage contentMode:UIViewContentModeCenter attachmentSize:locationImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [attributedString appendAttributedString:attachImage];
    
    // 详细地址
    NSString *detailAddress = @"上海市浦东新区川沙镇黄赵路310号";
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:detailAddress attributes:attributes]];
    
    self.addressLabel.attributedText = attributedString;
}

- (void)showMessage:(NSString *)msg {
    CGFloat padding = 44;
    
    YYLabel *label = [YYLabel new];
    label.text = msg;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:0.730];
    label.textContainerInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    label.width = self.view.width;
    label.height = [msg heightForFont:label.font width:label.width] + 2 * padding;
    label.bottom = kiOS9Later ? 88 : 0;
    [self.view addSubview:label];
    
    // 显示 Label 动画
    [UIView animateWithDuration:0.3 animations:^{
        label.top = (kiOS9Later ? 88 : 0);
    } completion:^(BOOL finished) {
        
        // 嵌套动画，2秒后隐藏label动画
        [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.bottom = kiOS9Later ? 88 : 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

@end
