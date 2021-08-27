//
//  ReuseViewController.m
//  LazyScrollViewDemo
//
//  Copyright (c) 2015-2018 Alibaba. All rights reserved.
//

#import "ReuseViewController.h"
#import <LazyScroll/LazyScroll.h>
#import <TMUtils/TMUtils.h>

@interface LazyScrollViewCustomView : UILabel <TMLazyItemViewProtocol>

@property (nonatomic, assign) NSUInteger reuseTimes;

@end

@implementation LazyScrollViewCustomView

- (void)mui_prepareForReuse
{
    self.reuseTimes++;
}

@end

//****************************************************************

@interface ReuseViewController () <TMLazyScrollViewDataSource> {
    NSMutableArray * _rectArray;
    NSMutableArray * _colorArray;
}

@end

@implementation ReuseViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"Reuse";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // STEP 1: Create LazyScrollView
    TMLazyScrollView *scrollView = [[TMLazyScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.dataSource = self;
    /**
     如果设置为 YES，LazyScrollView 将自动将创建的Item视图添加到其子视图中。
     默认值为 NO。请只在第一次重新加载数据之前设置此值。
     */
    scrollView.autoAddSubview = YES;
    [self.view addSubview:scrollView];
    
    // Here is frame array for test.
    // LazyScrollView must know item view's frame before rending.
    _rectArray = [[NSMutableArray alloc] init];
    CGFloat maxY = 0, currentY = 50;
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    // Create a double column layout with 10 elements.
    for (int i = 0; i < 10; i++) {
        [self addRect:CGRectMake((i % 2) * (viewWidth - 20 + 3) / 2 + 10, i / 2 * 80 + currentY, (viewWidth - 20 - 3) / 2, 80 - 3) andUpdateMaxY:&maxY];
    }
    // Create a single column layout with 10 elements.
    currentY = maxY + 10;
    for (int i = 0; i < 10; i++) {
        [self addRect:CGRectMake(10, i * 80 + currentY, viewWidth - 20, 80 - 3) andUpdateMaxY:&maxY];
    }
    // Create a double column layout with 10 elements.
    currentY = maxY + 10;
    for (int i = 0; i < 10; i++) {
        [self addRect:CGRectMake((i % 2) * (viewWidth - 20 + 3) / 2 + 10, i / 2 * 80 + currentY, (viewWidth - 20 - 3) / 2, 80 - 3) andUpdateMaxY:&maxY];
    }
    
    // Create color array.
    // The color order is like rainbow.
    _colorArray = [NSMutableArray arrayWithCapacity:_rectArray.count];
    CGFloat hue = 0;
    for (int i = 0; i < _rectArray.count; i++) {
        [_colorArray addObject:[UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1]];
        hue += 0.04;
        if (hue >= 1) {
            hue = 0;
        }
    }
    
    // STEP 3: reload LazyScrollView
    scrollView.contentSize = CGSizeMake(viewWidth, maxY + 10);
    [scrollView reloadData];
    
    // A tip.
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewWidth - 20, 30)];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.numberOfLines = 0;
    // item 视图的颜色应该从红色渐变至蓝色。它们可以重复使用。品红色不应出现。
    tipLabel.text = @"Item views's color should be from red to blue. They are reused. Magenta should not be appeared.";
    [scrollView addSubview:tipLabel];
}

#pragma mark LazyScrollView

// STEP 2: implement datasource.
- (NSUInteger)numberOfItemsInScrollView:(TMLazyScrollView *)scrollView
{
    return _rectArray.count;
}

- (TMLazyItemModel *)scrollView:(TMLazyScrollView *)scrollView itemModelAtIndex:(NSUInteger)index
{
    CGRect rect = [(NSValue *)[_rectArray objectAtIndex:index] CGRectValue];
    TMLazyItemModel *rectModel = [[TMLazyItemModel alloc] init];
    rectModel.absRect = rect;
    rectModel.muiID = [NSString stringWithFormat:@"%zd", index];
    return rectModel;
}

- (UIView *)scrollView:(TMLazyScrollView *)scrollView itemByMuiID:(NSString *)muiID
{
    // Find view that is reuseable first.
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
    label.frame = [(NSValue *)[_rectArray objectAtIndex:index] CGRectValue];
    if (label.reuseTimes > 0) {
        label.text = [NSString stringWithFormat:@"%zd\nlast index: %@\nreuse times: %zd", index, label.muiID, label.reuseTimes];
    } else {
        label.text = [NSString stringWithFormat:@"%zd", index];
    }
    return label;
}

#pragma mark Private

- (void)addRect:(CGRect)newRect andUpdateMaxY:(CGFloat *)maxY
{
    if (CGRectGetMaxY(newRect) > *maxY) {
        *maxY = CGRectGetMaxY(newRect);
    }
    [_rectArray addObject:[NSValue valueWithCGRect:newRect]];
}

@end
