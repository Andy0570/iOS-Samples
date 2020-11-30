//
//  HQLCodeResignView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCodeResignView.h"
#import <Masonry.h>
#import "HQLCodeView.h"
#import "NSString+HQLNormalRegex.h"

@implementation UITextField (ForbiddenSelect)

/*
 该函数控制是否允许 选择 全选 剪切 复制粘贴等功能，可以针对不同功能进行限制
 返回YES表示允许对应的功能，返回NO则表示不允许对应的功能
 直接返回NO则表示不允许任何编辑
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

@end

@interface HQLCodeResignView () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSArray<HQLCodeView *> *codeViews; // 展示验证码内容的 codeView 数组
@property (nonatomic, assign) NSInteger currentIndex; // 当前输入的 codeView 索引
@property (nonatomic, assign) NSInteger codeBits;  // 验证码位数

@end

@implementation HQLCodeResignView

- (instancetype)initWithCodeBits:(NSInteger)codeBits {
    if (self = [super init]) {
        self.backgroundColor = UIColor.whiteColor;
        BOOL isCodeBitsZero = (codeBits < 1);
        self.codeBits = (isCodeBitsZero ? 4 : codeBits);
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    for (NSInteger i = 0; i < self.codeBits; i++) {
        HQLCodeView *codeView = self.codeViews[i];
        codeView.tag = i;
        [self addSubview:codeView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设定每个数字之间的间距为数字 view 宽度的一半，总宽度就是 bits + (bits - 1) * 0.5;
    CGFloat codeViewWidth = self.bounds.size.width / (self.codeBits * 1.5 - 0.5);
    for (NSInteger i = 0; i < self.codeBits; i++) {
        HQLCodeView *codeView = self.codeViews[i];
        [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat left = codeViewWidth * 1.5 * i;
            make.left.mas_equalTo(self).mas_offset(left);
            make.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(codeViewWidth);
        }];
    }
}

#pragma mark - Custom Accessors

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = UIColor.clearColor;
        _textField.textColor = UIColor.clearColor;
        _textField.tintColor = UIColor.clearColor; // 设置光标的颜色
        _textField.keyboardType = UIKeyboardTypeNumberPad; // 数字键盘
        _textField.returnKeyType = UIReturnKeyDone; // 完成
        _textField.delegate = self;
    }
    return _textField;
}

- (NSArray<HQLCodeView *> *)codeViews {
    if (!_codeViews) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.codeBits];
        for (NSInteger i = 0; i < self.codeBits; i ++) {
            HQLCodeView *codeView = [[HQLCodeView alloc] init];
            [array addObject:codeView];
        }
        _codeViews = array.copy;
    }
    return _codeViews;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 完成，则收回键盘
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    // 删除操作
    if ([string isEqualToString:@""]) {
        // 待输入的下标为 0 时，执行删除操作时，下标不变，否则下标 -1
        if (self.currentIndex == 0) {
            self.codeViews[self.currentIndex].text = string;
        } else {
            self.codeViews[--self.currentIndex].text = string;
            if (self.cancelHandler) {
                NSString *content = [textField.text substringToIndex:self.currentIndex];
                self.cancelHandler(content);
            }
        }
        return YES;
    }
    
    // 判断输入的是否是纯数字
    BOOL isPureNumber = [string hql_validateByRegex:@"^\\d$"];
    if (!isPureNumber) { return NO; }
    
    // 如果输入的内容超过了验证码的长度，则输入无效
    if ((textField.text.length + string.length) >  self.codeBits) {
        return NO;
    }
    
    // 输入的数字，则当前待输入的下标对应的 view 中添加该数字，并且下标 + 1
    self.codeViews[self.currentIndex++].text = string;
    // 如果当前待输入的下标等于 codeBits 时，表示已经输入了对应位数的验证码，执行完成操作
    NSString *content = [NSString stringWithFormat:@"%@%@",textField.text, string];
    if (self.currentIndex == self.codeBits && self.completionHandler) {
        self.completionHandler(content);
    } else {
        if (self.cancelHandler) {
            self.cancelHandler(content);
        }
    }
    
    return YES;
}

@end
