//
//  HQLTagViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/8/27.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLTagViewController.h"
#import <TTGTextTagCollectionView.h>
#import <Masonry.h>

@interface HQLTagViewController ()

@property (nonatomic, strong) TTGTextTagCollectionView *tagCollectionView;

@end

@implementation HQLTagViewController

#pragma mark - Initialize

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTagCollectionView];
    [self configTagCollectionView];
}

- (void)setupTagCollectionView {
    [self.view addSubview:self.tagCollectionView];
    [self.tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(52);
    }];
}

#pragma mark - Custom Accessors

- (TTGTextTagCollectionView *)tagCollectionView {
    if (!_tagCollectionView) {
        _tagCollectionView = [[TTGTextTagCollectionView alloc] init];
        _tagCollectionView.enableTagSelection = NO;
        _tagCollectionView.scrollDirection = TTGTagCollectionScrollDirectionVertical;
        _tagCollectionView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
        _tagCollectionView.showsVerticalScrollIndicator = NO;
        _tagCollectionView.scrollView.scrollEnabled = NO;
        _tagCollectionView.contentInset = UIEdgeInsetsMake(10, 5, 10, 5);
    }
    return _tagCollectionView;
}

// 配置活动标签样式
- (void)configTagCollectionView {
    // FIXME: 等待后台 API 接口返回数据
    NSArray *temporyTags = @[@"店铺活动标签",@"店铺活动标签",@"店铺活动标签"];
    
    [temporyTags enumerateObjectsUsingBlock:^(NSString *tags, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 标签样式
        UIFont *textFont = [UIFont systemFontOfSize:14.0f];
        TTGTextTagStyle *style = [[TTGTextTagStyle alloc] init];
        style.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:249/255.0 alpha:1.0];
        style.extraSpace = CGSizeMake(10, 18);
        style.cornerRadius = 5;
        style.shadowOpacity = 0;
        style.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:249/255.0 alpha:1.0];
        style.borderWidth = 1;
        
        // 标签内容
        TTGTextTagStringContent *content = [[TTGTextTagStringContent alloc] initWithText:tags textFont:textFont textColor:[UIColor colorWithRed:250/255.0 green:81/255.0 blue:71/255.0 alpha:1.0]];
        
        // 初始化标签
        TTGTextTag *textTag = [TTGTextTag tagWithContent:content style:style];
        [self.tagCollectionView addTag:textTag];
    }];
    
    [self.tagCollectionView reload];
}

@end
