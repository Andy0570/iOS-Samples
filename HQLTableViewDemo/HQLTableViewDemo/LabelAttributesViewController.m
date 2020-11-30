//
//  LabelAttributesViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "LabelAttributesViewController.h"
#import <Chameleon.h>
#import <Masonry.h>
#import "UILabel+HQLAttributedText.h"

@interface LabelAttributesViewController ()

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@end

@implementation LabelAttributesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self addLabel1];
    [self addPriceLabel];
    [self addOriginalPriceLabel];
    
    
    /**
     1. 通过 Lazy Loading 方式加载 Label；
     2. 通过 Masonry 框架实现自动布局；
     3. 通过 Cateogory 方法设置属性字符串；
     */
    // 现价
    [self.priceLabel hql_setAttributedTextWithProductPrice:149.50];
    [self.view addSubview:self.priceLabel];
    // 原价
    [self.originalPriceLabel hql_setAttributedTextWithOriginalPrice:199.90];
    [self.view addSubview:self.originalPriceLabel];
    // 已优惠
    [self.discountLabel hql_setAttributedTextWithPromotionAmount:50.00];
    [self.view addSubview:self.discountLabel];
    // 合计
    [self.totalPriceLabel hql_setAttributedTextWithTotalPrice:4288.00];
    [self.view addSubview:self.totalPriceLabel];
    // 共 n 件商品
    [self.amountLabel hql_setAttributedTextWithProductAmount:15];
    [self.view addSubview:self.amountLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat padding = 16.0f;
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).with.offset(250);
        make.left.mas_equalTo(self.view).with.offset(padding);
    }];
    
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceLabel.mas_right).with.offset(6);
        make.baseline.mas_equalTo(self.priceLabel);
    }];
    
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.priceLabel);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.discountLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.discountLabel);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalPriceLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.totalPriceLabel);
    }];
}

- (void)addLabel1 {
    // 创建 UILabel 对象
    // 效果：“25.8” 红色，“元起” 灰色
    UILabel *label = [[UILabel alloc] init];

    // 设置 attributedText
    NSString *string = @"25.8元起";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    UIFont *font = [UIFont systemFontOfSize:15];

    NSDictionary *attributes1 = @{
        NSForegroundColorAttributeName:HexColor(@"#FF4359"),
        NSFontAttributeName:font
    };
    [attributedString setAttributes:attributes1 range:NSMakeRange(0, 4)];

    NSDictionary *attributes2 = @{
        NSForegroundColorAttributeName:HexColor(@"#7E7B93"),
        NSFontAttributeName:font
    };
    [attributedString setAttributes:attributes2 range:NSMakeRange(4, 2)];

    label.attributedText = attributedString;

    // 限定 label 的宽度和高度，让 label 在此范围内自适应
    CGSize size = [label sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 15*2, MAXFLOAT)];
    label.frame = CGRectMake(20, 100, size.width, size.height);

    [self.view addSubview:label];
}

// 商品价格：¥ 12.88
- (void)addPriceLabel {
    CGFloat price = 12.88;
    NSString *priceStr = [NSString stringWithFormat:@"¥ %.2f", price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSDictionary *attributes1 = @{
        NSForegroundColorAttributeName:[UIColor redColor],
        NSFontAttributeName:[UIFont systemFontOfSize:12]
    };
    [attributedString setAttributes:attributes1 range:NSMakeRange(0, 1)];

    NSDictionary *attributes2 = @{
        NSForegroundColorAttributeName:[UIColor redColor],
        NSFontAttributeName:[UIFont systemFontOfSize:15]
    };
    [attributedString setAttributes:attributes2 range:NSMakeRange(2, priceStr.length-2)];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 100, 100)];
    priceLabel.attributedText = attributedString;
    [priceLabel sizeToFit];
    [self.view addSubview:priceLabel];
}

// 商品原价：¥ 299
- (void)addOriginalPriceLabel {
    CGFloat price = 299;
    NSString *originalPriceStr = [NSString stringWithFormat:@"¥%.0f", price];
    NSMutableAttributedString *originalPrice = [[NSMutableAttributedString alloc] initWithString:originalPriceStr];
    [originalPrice addAttribute:NSStrikethroughStyleAttributeName
                            value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)
                            range:NSMakeRange(0, originalPrice.length)];
    
    UILabel *originalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 100, 100)];
    originalPriceLabel.attributedText = originalPrice;
    [originalPriceLabel sizeToFit];
    [self.view addSubview:originalPriceLabel];
}

#pragma mark - Custom Accessors

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        _priceLabel.textColor = [UIColor redColor];
    }
    return _priceLabel;
}

- (UILabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.font = [UIFont systemFontOfSize:10.0f];
        _originalPriceLabel.textColor = [UIColor grayColor];
    }
    return _originalPriceLabel;
}

- (UILabel *)discountLabel {
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.font = [UIFont systemFontOfSize:18.0f];
        _discountLabel.textColor = [UIColor grayColor];
    }
    return _discountLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.font = [UIFont systemFontOfSize:18.0f];
        _totalPriceLabel.textColor = [UIColor grayColor];
    }
    return _totalPriceLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont systemFontOfSize:18.0f];
        _amountLabel.textColor = [UIColor grayColor];
    }
    return _amountLabel;
}

@end
