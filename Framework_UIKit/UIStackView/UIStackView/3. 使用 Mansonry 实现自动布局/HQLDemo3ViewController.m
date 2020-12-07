//
//  HQLDemo3ViewController.m
//  UIStackView
//
//  Created by Qilin Hu on 2020/5/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLDemo3ViewController.h"

// Frameworks
#import <Masonry.h>
#import <YYKit.h>
#import <Mantle.h>

// Model
#import "HQLMainPageNavBtnModel.h"

@interface HQLDemo3ViewController ()

@property (nonatomic, strong) UIView *masonryView; // 容器视图
@property (nonatomic, copy) NSArray<HQLMainPageNavBtnModel *> *navButtonModelArray;

@end

@implementation HQLDemo3ViewController


#pragma mark - Controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:63/100.0f alpha:1.0];
    [self addSubViews];
}


#pragma mark - Custom Accessors

- (UIView *)masonryView {
    if (!_masonryView) {
        _masonryView = [[UIView alloc] init];
        _masonryView.backgroundColor = [UIColor whiteColor];
    }
    return _masonryView;
}

// 从 mainPageNavBtn.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray *)navButtonModelArray {
    if (!_navButtonModelArray) {

        // 1.构造 mainPageNavBtn.plist 文件 URL 路径
        NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        NSURL *url = [bundleURL URLByAppendingPathComponent:@"mainPageNavBtn.plist"];
        
        // 2.读取 mainPageNavBtn.plist 文件，并存放进 jsonArray 数组
        NSArray *jsonArray;
        if (@available(iOS 11.0, *)) {
            NSError *readFileError = nil;
            jsonArray = [NSArray arrayWithContentsOfURL:url error:&readFileError];
            if (!jsonArray) {
                NSLog(@"%@, NSPropertyList File read error:\n%@", @(__PRETTY_FUNCTION__), readFileError.localizedDescription);
                return nil;
            }
        } else {
            jsonArray = [NSArray arrayWithContentsOfURL:url];
            if (!jsonArray || jsonArray.count == 0) {
                NSLog(@"%@, NSPropertyList File read error.", @(__PRETTY_FUNCTION__));
                return nil;
            }
        }
        
         // 3.将 jsonArray 数组中的 JSON 数据转换成 HQLMainPageNavBtnModel 模型
        NSError *decodeError = nil;
        _navButtonModelArray = [MTLJSONAdapter modelsOfClass:HQLMainPageNavBtnModel.class
                                               fromJSONArray:jsonArray
                                                       error:&decodeError];
        if (!_navButtonModelArray) {
            NSLog(@"%@, jsonArray decode error:\n%@", @(__PRETTY_FUNCTION__), decodeError.localizedDescription);
            return nil;
        }
    }
    return _navButtonModelArray;
}

#pragma mark - Private

- (void)addSubViews {
    // 添加容器视图
    [self.view addSubview:self.masonryView];
    [self.masonryView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view.mas_top).with.offset(64);
        }
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(CGFloatPixelRound((kScreenWidth - 10*5)/4) + 10*2);
    }];
    
    // 容器视图中添加子视图
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithDisplayP3Red:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        [views addObject:view];
        [self.masonryView addSubview:view];
    }
    
    // MARK: 让所有子视图均匀以「固定间隔」均匀分布
    [views mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                       withFixedSpacing:10
                            leadSpacing:10
                            tailSpacing:10];
    
    __weak __typeof(self)weakSelf = self;
    [views mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.top.and.height.equalTo(weakSelf.masonryView);
        make.centerY.equalTo(weakSelf.masonryView);
        make.height.mas_equalTo(CGFloatPixelRound((kScreenWidth - 10*5)/4));
    }];
}


// 示例代码，未使用！！！
// 通过 Masonry 在页面中添加首页 5 个导航按钮
- (void)add5NavButtonBelowActivityContainerView:(UIView *)activityContainerView {
    // 1.添加容器视图
    UIView *navBtnContainerView = [[UIView alloc] init];
    navBtnContainerView.backgroundColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];
    [self.view addSubview:navBtnContainerView];
    [navBtnContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(activityContainerView);
        make.top.equalTo(activityContainerView.mas_bottom);
        make.height.mas_equalTo(95);
    }];
    
    // 2.容器视图中添加子视图
    NSMutableArray *buttonsArray = [NSMutableArray arrayWithCapacity:5];
    // 遍历数据源模型，添加按钮
    [self.navButtonModelArray enumerateObjectsUsingBlock:^(HQLMainPageNavBtnModel * _Nonnull buttonModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 2.1 添加按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 69, 95);
        button.tag = buttonModel.tag.integerValue;
        // 标题
        NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:13],
            NSForegroundColorAttributeName:[UIColor blackColor]
                                     };
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:buttonModel.title
                                                                    attributes:attributes];
        [button setAttributedTitle:title forState:UIControlStateNormal];
        // 图片 60*60
        [button setImage:[UIImage imageNamed:buttonModel.image] forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        // 调整按钮上下布局
        // [button jk_setImagePosition:LXMImagePositionTop spacing:0];
        
//        CGFloat imageWidth = button.imageView.image.size.width;
//        CGFloat imageHeight = button.imageView.image.size.height;
//        CGFloat labelWidth = [button.titleLabel.text sizeWithAttributes:attributes].width;
//        CGFloat labelHeight = [button.titleLabel.text sizeWithAttributes:attributes].height;
//
//        CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
//        CGFloat imageOffsetY = imageHeight / 2; //image中心移动的y距离
//        CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
//        CGFloat labelOffsetY = labelHeight / 2; //label中心移动的y距离
//
//        button.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
//        button.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);

        // Target-Action
        [button addTarget:self action:@selector(navButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [navBtnContainerView addSubview:button];
        
        // 2.2 将按钮添加到 buttonsArray 数组
        [buttonsArray addObject:button];
    }];
    
    // 3.布局按钮，让所有子视图均匀以「固定间隔」均匀分布
    [buttonsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                              withFixedSpacing:5
                                   leadSpacing:5
                                   tailSpacing:5];

    [buttonsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(navBtnContainerView);
//        make.width.mas_equalTo(CGFloatPixelRound((kScreenWidth - 5*4)/4));
//        make.height.mas_equalTo(CGFloatPixelRound((kScreenWidth - 5*4)/4));
        make.top.and.bottom.equalTo(navBtnContainerView);
    }];
}

#pragma mark - Actions

- (void)navButtonDidClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1001) {
        // 找商场
        
    } else if (button.tag == 1002) {
        // 找品牌
        
    } else if (button.tag == 1003) {
        // 奢品专柜
           
    } else if (button.tag == 1004) {
        // 去领券
        
    } else if (button.tag == 1005) {
        // 嗨会员
        
    }
}

@end
