//
//  HQLEmptyDataSetExample4.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/1.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLEmptyDataSetExample4.h"

// Framework
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Chameleon.h>
#import <YYKit.h>

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLEmptyDataSetExample4 () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign, getter=isLoading) BOOL loading;

@end

@implementation HQLEmptyDataSetExample4

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

#pragma mark - Custom Accessors

// 设置当前页面的加载状态
- (void)setLoading:(BOOL)loading {
    
    // 如果当前页面的加载状态和之前一样，返回
    if (self.isLoading == loading) {
        return;
    }
    
    // 不一样，则刷新空白页面
    _loading = loading;
    [self.tableView reloadEmptyDataSet];
}

#pragma mark - Private

- (void)setupTableView {
    
    // DZNEmptyDataSet
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // 注册重用 cell（class 类型）
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    
    // 隐藏列表空白区域的分隔线
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

#pragma mark - <DZNEmptyDataSetSource>

// MARK: 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isLoading) {
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    } else {
        return [UIImage imageNamed:@"placeholder_foursquare"];
    }
}

// MARK: 空白页图片动画
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

// MARK: 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Nobody has liked or commented on your check-ins yet.";
  
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#cecbc6"],
        NSParagraphStyleAttributeName:paragraph
    };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// MARK: 空白页添加按钮，设置按钮文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    // 设置按钮标题
    NSString *buttonTitle = @"Add friends to get started!";
    UIColor *buttonColor = [UIColor colorWithHexString:(state == UIControlStateNormal) ? @"00aeef" : @"ffffff"];
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:14.0],
        NSForegroundColorAttributeName: buttonColor
    };
    return [[NSAttributedString alloc] initWithString:buttonTitle attributes:attributes];
}

// MARK: 空白页添加按钮，设置按钮背景颜色
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
   
    UIImage *image;
    if (state == UIControlStateNormal) {
        image = [UIImage imageNamed:@"button_background_foursquare_normal"];
    }
    if (state == UIControlStateHighlighted) {
        image = [UIImage imageNamed:@"button_background_foursquare_highlight"];
    }
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(0.0, 10, 0.0, 10);

    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

// MARK: 空白页背景颜色
- (nullable UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor colorWithHexString:@"#fcfcfa"];
}

// MARK: 设置各个视图元素之间的垂直间距，默认为 11pt
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 9.0;
}

#pragma mark - <DZNEmptyDataSetDelegate>

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // 处理空白页面按钮点击事件
    NSLog(@"处理空白页面按钮点击事件");
    
    self.loading = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loading = NO;
    });
    
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return self.isLoading;
}

@end
