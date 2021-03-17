//
//  AsyncViewController.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "AsyncViewController.h"
#import <LazyScroll/LazyScroll.h>
#import <TMUtils/TMUtils.h>

@interface AsyncViewController () <TMLazyScrollViewDataSource> {
    NSMutableArray * _rectArray;
    NSMutableArray * _colorArray;
    TMLazyScrollView * _scrollView;
    
    BOOL enableDelay;
}

@end

@implementation AsyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Sync";
    
    _scrollView = [[TMLazyScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.dataSource = self;
    _scrollView.autoAddSubview = YES;
    [self.view addSubview:_scrollView];
    
    _rectArray = [[NSMutableArray alloc] init];
    CGFloat currentY = 10, maxY = 0;
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    for (int i = 0; i < 50; i++) {
        [self addRect:CGRectMake(10, i * 80 + currentY, 100, 80 - 3) andUpdateMaxY:&maxY];
        [self addRect:CGRectMake(115, i * 80 + currentY, 100, 80 - 3) andUpdateMaxY:&maxY];
        [self addRect:CGRectMake(220, i * 80 + currentY, 100, 80 - 3) andUpdateMaxY:&maxY];
    }
    
    _colorArray = [NSMutableArray arrayWithCapacity:_rectArray.count];
    CGFloat hue = 0;
    for (int i = 0; i < 20; i++) {
        [_colorArray addObject:[UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1]];
        hue += 0.05;
    }
    
    _scrollView.contentSize = CGSizeMake(viewWidth, maxY + 10);
    [_scrollView reloadData];
    enableDelay = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Switch" style:UIBarButtonItemStylePlain target:self action:@selector(switchAction)];
}

- (void)switchAction
{
    /**
     // 是否立即加载所有 item。默认值是 YES。
     // 如果设置为 NO，LazyScrollView 将尝试在多个 frame 中加载新的项目视图。
     @property (nonatomic, assign) BOOL loadAllItemsImmediately;
     */
    _scrollView.loadAllItemsImmediately = !_scrollView.loadAllItemsImmediately;
    if (_scrollView.loadAllItemsImmediately) {
        self.title = @"Sync";
    } else {
        self.title = @"Async";
    }
}

#pragma mark LazyScrollView

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
    UIView *view = (UIView *)[scrollView dequeueReusableItemWithIdentifier:@"testView"];
    NSInteger index = [muiID integerValue];
    if (!view) {
        view = [UIView new];
        view.reuseIdentifier = @"testView";
        view.backgroundColor = [_colorArray tm_safeObjectAtIndex:index % 20];
    }
    view.frame = [(NSValue *)[_rectArray objectAtIndex:index] CGRectValue];
    if (enableDelay) {
        // 手动添加延迟
        [NSThread sleepForTimeInterval:0.015];
    }
    return view;
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
