//
//  MockViewController.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "MockViewController.h"
#import <Tangram/TangramView.h>
#import <Tangram/TangramDefaultDataSourceHelper.h>
#import <Tangram/TangramDefaultItemModelFactory.h>
#import <Tangram/TangramContext.h>
#import <Tangram/TangramEvent.h>
#import <TMUtils.h>

@interface MockViewController () <TangramViewDatasource>

@property (nonatomic, strong) TangramView *tangramView;
@property (nonatomic, strong) TangramBus *tangramBus;

@property (nonatomic, strong) NSMutableArray *layoutModelArray;
@property (nonatomic, strong) NSArray *layoutArray;
@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation MockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMockContent];
    [self registEvent];
    
    // MARK: 刷新视图
    [self.tangramView reloadData];
}

#pragma mark - Custom Accessors

// MARK: 创建 Tangram 实例
-(TangramView *)tangramView {
    if (!_tangramView) {
        _tangramView = [[TangramView alloc] init];
        _tangramView.frame = self.view.bounds;
        _tangramView.dataSource = self;
        _tangramView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tangramView];
    }
    return _tangramView;
}

- (TangramBus *)tangramBus {
    if (!_tangramBus) {
        _tangramBus = [[TangramBus alloc] init];
    }
    return _tangramBus;
}

-(NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc] init];
    }
    return _modelArray;
}

#pragma mark - Private

- (void)loadMockContent {
    // MARK: 注册 Tangram 组件
    [TangramDefaultItemModelFactory registElementType:@"image" className:@"TangramSingleImageElement"];
    [TangramDefaultItemModelFactory registElementType:@"text" className:@"TangramSimpleTextElement"];
    
    // MARK: 读取数据，使用 Helper 解析成 layout 实例
    // 获取数据
    NSString *mockDataString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TangramMock" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [mockDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.layoutModelArray = [[dict objectForKey:@"data"] objectForKey:@"cards"];
    
    // 使用 Helper 解析成 layout 实例
    self.layoutArray = [TangramDefaultDataSourceHelper layoutsWithArray:self.layoutModelArray tangramBus:self.tangramBus];
}

- (void)registEvent {
    [self.tangramBus registerAction:@"responseToClickEvent" ofExecuter:self onEventTopic:@"jumpAction"];
}

- (void)responseToClickEvent:(TangramContext *)context {
    NSString *action = [context.event.params tm_stringForKey:@"action"];
    NSLog(@"Click Action: %@",action);
}

#pragma mark - <TangramViewDatasource>

// 返回 layout 个数
- (NSUInteger)numberOfLayoutsInTangramView:(TangramView *)view
{
    return self.layoutArray.count;
}

//返回 layout 的实例
- (UIView<TangramLayoutProtocol> *)layoutInTangramView:(TangramView *)view atIndex:(NSUInteger)index
{
    return [self.layoutArray objectAtIndex:index];
}

// 返回某一个 layout 中 itemModel 的个数
- (NSUInteger)numberOfItemsInTangramView:(TangramView *)view forLayout:(UIView<TangramLayoutProtocol> *)layout
{
    return layout.itemModels.count;
}

// 返回 layout 中指定 index 的 itemModel 实例
- (NSObject<TangramItemModelProtocol> *)itemModelInTangramView:(TangramView *)view forLayout:(UIView<TangramLayoutProtocol> *)layout atIndex:(NSUInteger)index
{
    return [layout.itemModels objectAtIndex:index];
}

// 根据 Model 生成 View
// 以上的方法在调用 Tangram 的 reload 方法后就会执行，而这个方法是按需加载
- (UIView *)itemInTangramView:(TangramView *)view withModel:(NSObject<TangramItemModelProtocol> *)model forLayout:(UIView<TangramLayoutProtocol> *)layout atIndex:(NSUInteger)index
{
    UIView *reuseableView = [view dequeueReusableItemWithIdentifier:model.reuseIdentifier];
    
    if (reuseableView) {
        reuseableView =  [TangramDefaultDataSourceHelper refreshElement:reuseableView byModel:model layout:layout tangramBus:self.tangramBus];
    } else {
        reuseableView =  [TangramDefaultDataSourceHelper elementByModel:model layout:layout tangramBus:self.tangramBus];
    }
    return reuseableView;
}

@end
