//
//  ColorViewController.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "ColorViewController.h"

// Framework
#import <Tangram/TangramView.h>
#import <Tangram/TangramFixLayout.h>
#import <Tangram/TangramDragableLayout.h>
#import <Tangram/TangramSingleAndDoubleLayout.h>
#import <Tangram/TangramWaterFlowLayout.h>
#import <Tangram/TangramStickyLayout.h>

// View
#import "DemoItem.h"
#import "DemoLayout.h"

// Model
#import "DemoItemModel.h"
#import "DemoFixModel.h"

#define TESTLAYOUT_NUMBER 20
#define TESTCOLUMN 3
#define TESTROW 4

@interface ColorViewController () <TangramViewDatasource, UIScrollViewDelegate>
@property (nonatomic, assign) NSUInteger totalIndex;
@end

@implementation ColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalIndex = 0;
    
    TangramView *tangramView = [[TangramView alloc] initWithFrame:self.view.bounds];
    tangramView.dataSource = self;
    tangramView.delegate = self;
    tangramView.backgroundColor = [UIColor lightGrayColor];
    // 在垂直 StickyLayout 和 FixLayout 布局中的额外偏移量
    tangramView.fixExtraOffset = 88.0f;
    [self.view addSubview:tangramView];
    
    [tangramView reloadData];
}

#pragma mark - <TangramViewDatasource>

// 返回 layout 个数
- (NSUInteger)numberOfLayoutsInTangramView:(TangramView *)view
{
    return TESTLAYOUT_NUMBER;
}

// 返回某一个 layout 中 itemModel 的个数
- (NSUInteger)numberOfItemsInTangramView:(TangramView *)view forLayout:(UIView<TangramLayoutProtocol> *)layout
{
    if ([layout isKindOfClass:[TangramFixLayout class]]) {
        return 1;
    }
    if ([layout isKindOfClass:[TangramSingleAndDoubleLayout class]]) {
        return 4;
    }
    if ([layout isKindOfClass:[TangramWaterFlowLayout class]]) {
        return 10;
    }
    if ([layout isKindOfClass:[TangramStickyLayout class]]) {
        return 1;
    }
    return 4;
}

//返回 layout 的实例
// Layout 不做复用，复用的是 Item
- (UIView <TangramLayoutProtocol> *)layoutInTangramView:(TangramView *)view atIndex:(NSUInteger)index {
    if (index == 0) {
        // 固定布局
        TangramDragableLayout *fixLayout = [[TangramDragableLayout alloc] init];
        //fixLayout.margin = @[@100,@0,@0,@0];
        fixLayout.alignType = TopRight;
        fixLayout.offsetX = 100;
        fixLayout.offsetY = 100;
        return fixLayout;
    }
    if (index == 1) {
        // 一拖N布局
        TangramSingleAndDoubleLayout *layout = [[TangramSingleAndDoubleLayout alloc] init];
        layout.rows = @[@40, @60];
        return layout;
    }
    if (index == 3) {
        // 吸顶布局
        TangramStickyLayout *layout = [[TangramStickyLayout alloc] init];
        layout.stickyBottom = NO;
        layout.extraOffset = 88.0f;
        return layout;
    }
    if (index == 6) {
        // 瀑布流布局
        TangramWaterFlowLayout *layout = [[TangramWaterFlowLayout alloc] init];
        return layout;
    }
    
    // 普通流式布局
    DemoLayout *layout = [[DemoLayout alloc] init];
    // top, right, bottom, left
    layout.margin = @[@10, @20, @20, @20];
    //layout.aspectRatio = @"5";
    //控制列数，行数根据Item个数自己算
    //在Tangram的FlowLayout里面，行数默认是1
    layout.numberOfColumns = index % 5 + 1;
    layout.hGap = 3;
    layout.vGap = 5;
    layout.index = index;
    layout.backgroundColor = [self randomColor];
    return layout;
}

// 返回 layout 中指定 index 的 itemModel 实例
- (NSObject<TangramItemModelProtocol> *)itemModelInTangramView:(TangramView *)view forLayout:(UIView<TangramLayoutProtocol> *)layout atIndex:(NSUInteger)index
{
    if ([layout isKindOfClass:[TangramDragableLayout class]] || [layout isKindOfClass:[TangramStickyLayout class]]) {
        DemoFixModel *fixModel = [[DemoFixModel alloc]init];
        return fixModel;
    }
    DemoItemModel *model = [[DemoItemModel alloc] init];
    model.indexInLayout = index;
    [model setItemFrame:CGRectMake(model.itemFrame.origin.x,model.itemFrame.origin.y, model.itemFrame.size.width, 150)];
    if ([layout isKindOfClass:[TangramWaterFlowLayout class]]) {
        [model setItemFrame:CGRectMake(model.itemFrame.origin.x,model.itemFrame.origin.y, model.itemFrame.size.width, (arc4random() % 120) + 30)];
    }
    return model;
}

// 根据 Model 生成 View
- (UIView *)itemInTangramView:(TangramView *)view withModel:(NSObject<TangramItemModelProtocol> *)model forLayout:(UIView<TangramLayoutProtocol> *)layout atIndex:(NSUInteger)index {
    
    // 首先查找是否有可以复用的 Item，是否可以复用是根据它的 reuseIdentifier 决定的
    DemoItem *item = (DemoItem *)[view dequeueReusableItemWithIdentifier:model.reuseIdentifier];
    if (!item) {
        item = [[DemoItem alloc] initWithFrame:CGRectZero reuseIdentifier:model.reuseIdentifier];
    }
    item.backgroundColor = [self randomColor];
    
    UILabel *testLabel = [item viewWithTag:1001];
    if (!testLabel) {
        testLabel = [[UILabel alloc]init];
        testLabel.frame =CGRectMake(2, 2, 30,30);
        testLabel.textColor = [UIColor whiteColor];
        testLabel.tag = 1001;
        [item addSubview:testLabel];
    }
    testLabel.text = [NSString stringWithFormat:@"%ld",index];
    item.clipsToBounds = YES;
    return item;
}

#pragma mark - UIScrollViewDelegate


#pragma mark - Private

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
