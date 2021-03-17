//
//  ReuseViewController.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "ReuseViewController.h"
#import <LazyScroll/LazyScroll.h>
#import <TMUtils/TMUtils.h>

// 自定义视图
@interface LazyScrollViewCustomView : UILabel <TMLazyItemViewProtocol>

// 标记该视图被重用的次数
@property (nonatomic, assign) NSUInteger reuseTimes;

@end

@implementation LazyScrollViewCustomView

// TMLazyItemViewProtocol
- (void)mui_prepareForReuse {
    self.reuseTimes++;
}

@end

//****************************************************************

@interface ReuseViewController () <TMLazyScrollViewDataSource> {
    NSMutableArray *_rectArray;
    NSMutableArray *_colorArray;
}

@end

@implementation ReuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Reuse";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // MARK: 1. 创建 LazyScrollView
    TMLazyScrollView *scrollView = [[TMLazyScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.dataSource = self;
    scrollView.autoAddSubview = YES;
    [self.view addSubview:scrollView];
    
    // 这是用于测试的 frame 数组
    // lazyScrollView 必须在渲染之前知道每一个 item 视图的 frame
    _rectArray = [[NSMutableArray alloc] init];
    CGFloat maxY = 0, currentY = 50;
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    // 创建包含10个元素的双列布局
    for (int i = 0; i < 10; i++) {
        [self addRect:CGRectMake((i % 2) * (viewWidth - 20 + 3) / 2 + 10, i /2 * 80 + currentY, (viewWidth - 20 - 3) / 2, 80 - 3) andUpdateMaxY:&maxY];
    }
    // 创建包含10个元素的单列布局。
    currentY = maxY + 10;
    for (int i = 0; i < 10; i++) {
        [self addRect:CGRectMake(10, i * 80 + currentY, viewWidth - 20, 80 - 3) andUpdateMaxY:&maxY];
    }
    // 创建包含10个元素的双列布局。
    currentY = maxY + 10;
    for (int i = 0; i < 10; i++) {
        [self addRect:CGRectMake((i % 2) * (viewWidth - 20 + 3) / 2 + 10, i / 2 * 80 + currentY, (viewWidth - 20 - 3) / 2, 80 - 3) andUpdateMaxY:&maxY];
    }
    
    // 创建颜色数组
    // 颜色的顺序类似于彩虹效果
    _colorArray = [NSMutableArray arrayWithCapacity:_rectArray.count];
    CGFloat hue = 0;
    for (int i = 0; i < _rectArray.count; i++) {
        [_colorArray addObject:[UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1]];
        hue += 0.04;
        if (hue >= 1) {
            hue = 0;
        }
    }
    
    // MARK: 3. reload LazyScrollView
    scrollView.contentSize = CGSizeMake(viewWidth, maxY + 10);
    [scrollView reloadData];
    
    // 提示文本
    // 初始化时已经预留高度 currentY = 50;
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewWidth - 20, 30)];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.numberOfLines = 0;
    tipLabel.text = @"item 视图的颜色应从红色到蓝色。它们可以重复使用。品红色不应出现。";
    [scrollView addSubview:tipLabel];
}

#pragma mark - <TMLazyScrollViewDataSource>

// MARK: 2. 实现数据源方法

/**
 * 返回 ScrollView 中 item 的个数
 *
 * @discussion 与 UITableView 的 'tableView:numberOfRowsInSection:' 类似
 */
- (NSUInteger)numberOfItemsInScrollView:(TMLazyScrollView *)scrollView
{
    return _rectArray.count;
}

/**
 * 根据 index 返回 TMLazyItemModel
 *
 * @discussion 与 UITableView 的 'tableView:heightForRowAtIndexPath:' 类似
 * 管理当前 item 视图的 muiID 以实现高性能。
 */
- (TMLazyItemModel *)scrollView:(TMLazyScrollView *)scrollView itemModelAtIndex:(NSUInteger)index
{
    CGRect rect = [(NSValue *)[_rectArray objectAtIndex:index] CGRectValue];
    TMLazyItemModel *rectModel = [[TMLazyItemModel alloc] init];
    rectModel.absRect = rect;
    // item 视图在 LazyScrollView 中的唯一标识符
    rectModel.muiID = [NSString stringWithFormat:@"%zd", index];
    return rectModel;
}

/**
 * 返回下标所对应的 view
 *
 * @discussion 与 UITableView 的 'tableView:cellForRowAtIndexPath:' 类似
 * 它将在 item 模型中使用 muiID 而不是 index 索引。
 */
- (UIView *)scrollView:(TMLazyScrollView *)scrollView itemByMuiID:(NSString *)muiID
{
    // 首先查找可重用的视图，没有再创建新视图
    LazyScrollViewCustomView *label = (LazyScrollViewCustomView *)[scrollView dequeueReusableItemWithIdentifier:@"testView"];
    NSInteger index = [muiID integerValue];
    if (!label) {
        NSLog(@"create a new label");
        label = [LazyScrollViewCustomView new];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.reuseIdentifier = @"testView";
        label.backgroundColor = [_colorArray tm_safeObjectAtIndex:index];
    }
    // 向对应的视图设置 frame
    label.frame = [(NSValue *)[_rectArray objectAtIndex:index] CGRectValue];
    if (label.reuseTimes > 0) {
        label.text = [NSString stringWithFormat:@"%zd\nlast index: %@\nreuse times: %zd", index, label.muiID, label.reuseTimes];
    } else {
        label.text = [NSString stringWithFormat:@"%zd", index];
    }
    return label;
}

#pragma mark - Private

- (void)addRect:(CGRect)newRect andUpdateMaxY:(CGFloat *)maxY
{
    if (CGRectGetMaxY(newRect) > *maxY) {
        *maxY = CGRectGetMaxY(newRect);
    }
    [_rectArray addObject:[NSValue valueWithCGRect:newRect]];
}
@end
