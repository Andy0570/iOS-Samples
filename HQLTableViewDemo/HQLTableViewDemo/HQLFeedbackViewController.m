//
//  HQLFeedbackViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/9.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLFeedbackViewController.h"

// Framework
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>
#import <Toast.h>
#import <Chameleon.h>
#import <JKCategories.h>
#import <Masonry.h>

// Model
#import "HQLFeedbackType.h"

@interface HQLFeedbackViewController () <TTGTextTagCollectionViewDelegate>

@property (nonatomic, strong) TTGTextTagCollectionView *tagCollectionView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, copy) NSArray <HQLFeedbackType *> *feedbackTypes;
@property (nonatomic, copy) HQLFeedbackType *selectedFeedbackType;

@end

@implementation HQLFeedbackViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];

    [self requestFeedbackTypeData];
}

#pragma mark - Custom Accessors

// 意见反馈类型标签
- (TTGTextTagCollectionView *)tagCollectionView {
    if (!_tagCollectionView) {
        _tagCollectionView = [[TTGTextTagCollectionView alloc] init];
        _tagCollectionView.delegate = self;
        _tagCollectionView.enableTagSelection = YES;
        _tagCollectionView.selectionLimit = 1;
        _tagCollectionView.alignment = TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine;
        
        TTGTextTagConfig *tagConfig = _tagCollectionView.defaultConfig;
        tagConfig.textFont = [UIFont systemFontOfSize:15.0f];
        tagConfig.textColor = HexColor(@"#999");
        tagConfig.selectedTextColor = [UIColor whiteColor];
        tagConfig.backgroundColor = HexColor(@"#f5f5f5");
        tagConfig.selectedBackgroundColor = [UIColor systemOrangeColor];
        
        // 取消阴影和边框
        tagConfig.shadowOpacity = 0;
        tagConfig.shadowOffset = CGSizeMake(0, 0);
        tagConfig.shadowColor = [UIColor clearColor];
        tagConfig.borderWidth = 1;
        tagConfig.selectedBorderWidth = 1;
        tagConfig.borderColor = HexColor(@"#f5f5f5");
        tagConfig.selectedBorderColor = [UIColor systemOrangeColor];
    }
    return _tagCollectionView;
}

// 意见反馈内容输入文本框
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:17.0f];
        _textView.textColor = HexColor(@"#999");
        // 通过 JKCategories 框架实现：限制最大输入字符数 200
        _textView.jk_maxLength = 200;
        // 通过 JKCategories 框架实现：显示占位符
        [_textView jk_addPlaceHolder:@"请输入具体反馈内容"];
        
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = HexColor(@"#eeeeee").CGColor;
    }
    return _textView;
}

// 提交按钮
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 设置按钮字体、颜色属性
        NSDictionary *normalAttributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17.0f],
            NSForegroundColorAttributeName : [UIColor whiteColor]
        };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"提交" attributes:normalAttributes];
        [_submitButton setAttributedTitle:normalTitle forState:UIControlStateNormal];
        
        NSDictionary *highlightedAttributes = @{
            NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
            NSForegroundColorAttributeName: [UIColor flatMintColor]
        };
        NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"提交" attributes:highlightedAttributes];
        [_submitButton setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
        
        // 按钮点击高亮效果，通过 UIColor 颜色设置背景图片
        [_submitButton setBackgroundImage:[UIImage jk_imageWithColor:[UIColor flatMintColor]]
                                 forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage jk_imageWithColor:HexColor(@"#F5F5F9")]
                                 forState:UIControlStateHighlighted];
        
        // 设置按钮圆角
        _submitButton.layer.cornerRadius = 10.0f;
        _submitButton.layer.masksToBounds = YES;
        
        [_submitButton addTarget:self
                          action:@selector(submitButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

#pragma mark - Actions

- (void)submitButtonAction:(id)sender {
    [self.submitButton jk_beginSubmitting:@"正在提交..."];
    
    // 模拟网络请求
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                            delayInSeconds *NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        [self.view makeToast:@"反馈成功~"];
        [self.submitButton jk_endSubmitting];
    });
}


#pragma mark - Private

// 从服务器动态获取意见反馈类型
- (void)requestFeedbackTypeData {
    
    // 构造模拟数据
    NSArray *jsonArray = @[
        @{
            @"feedbackId" : @1,
            @"name"       : @"白屏/卡顿/闪退"
        },
        @{
            @"feedbackId" : @2,
            @"name"       : @"拍摄/发布"
        },
        @{
            @"feedbackId" : @3,
            @"name"       : @"页面不刷新"
        },
        @{
            @"feedbackId" : @4,
            @"name"       : @"消息接收问题"
        },
        @{
            @"feedbackId" : @5,
            @"name"       : @"购买/支付问题"
        },
        @{
            @"feedbackId" : @6,
            @"name"       : @"商家/产品问题"
        },
        @{
            @"feedbackId" : @7,
            @"name"       : @"分享失败"
        },
        @{
            @"feedbackId" : @8,
            @"name"       : @"账号异常"
        }
    ];
    
    NSError *error = nil;
    self.feedbackTypes = [MTLJSONAdapter modelsOfClass:HQLFeedbackType.class fromJSONArray:jsonArray error:&error];
    if (self.feedbackTypes.count == 0) {
        [self.view makeToast:@"意见类型 JSON 解析失败！"];
        return;
    }
    
    [self.feedbackTypes enumerateObjectsUsingBlock:^(HQLFeedbackType *feedbackType, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 在标签上附加额外的数据
        TTGTextTagConfig *tagConfig = self.tagCollectionView.defaultConfig;
        tagConfig.extraData = feedbackType;

        [self.tagCollectionView addTag:feedbackType.name withConfig:tagConfig];
    }];
    
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.tagCollectionView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.submitButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请选择意见类型";
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    titleLabel.textColor = HexColor(@"#333");
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(20);
        make.left.mas_equalTo(self.view).with.offset(15);
    }];
    
    [self.tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.view).with.offset(15);
        make.right.mas_equalTo(self.view).with.offset(-15);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagCollectionView.mas_bottom).with.offset(20);
        make.left.mas_equalTo(self.view).with.offset(15);
        make.right.mas_equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(@180);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).with.offset(15);
        make.right.mas_equalTo(self.view).with.offset(-15);
        make.height.mas_equalTo(@45);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-40);
    }];
}


#pragma mark - <TTGTextTagCollectionViewDelegate>

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected
                    tagConfig:(TTGTextTagConfig *)config {
    
    // 获取当前选择的意见反馈类型
    if (selected) {
        self.selectedFeedbackType = (HQLFeedbackType *)config.extraData;
    } else {
        self.selectedFeedbackType = NULL;
    }
}

@end
