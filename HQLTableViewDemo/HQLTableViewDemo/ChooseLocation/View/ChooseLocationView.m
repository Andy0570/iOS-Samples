//
//  ChooseLocationView.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "ChooseLocationView.h"

// View
#import "AddressView.h"
#import "AddressTableViewCell.h"

// Model
#import "AddressItem.h"

// Others
#import "CitiesDataTool.h"
#import "UIView+Frame.h"

#define HYScreenW [UIScreen mainScreen].bounds.size.width

static const CGFloat kHYTopViewHeight = 40;   // 顶部标题视图的高度
static const CGFloat kHYTopTabbarHeight = 30; // 地址标签栏的高度

@interface ChooseLocationView () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) AddressView *topTabbar;
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) UIView *underLine;
@property (nonatomic, strong) NSArray *shengDataSouce;    // 省级别数据源
@property (nonatomic, strong) NSArray *cityDataSouce;     // 市
@property (nonatomic, strong) NSArray *districtDataSouce; // 区
@property (nonatomic, strong) NSMutableArray *topTabbarItemsArray; // 存放按钮的容器
@property (nonatomic, strong) NSMutableArray *tableViewsArray;     // 存放 tableView 的容器
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation ChooseLocationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Private

- (void)setupSubviews{
    // 标题栏容器视图
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kHYTopViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    // 标题栏
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"所在地区";
    titleLabel.centerY = topView.height * 0.5;
    titleLabel.centerX = topView.width * 0.5;
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    // 分割线1
    UIView * separateLine = [self separateLine];
    separateLine.top = topView.height - separateLine.height;
    [topView addSubview: separateLine];

    // 地址标签栏视图
    AddressView * topTabbar = [[AddressView alloc] initWithFrame:CGRectMake(0, topView.height, self.frame.size.width, kHYTopViewHeight)];
    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    [self addTopBarItem];
    
    // 分割线2
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.top = topTabbar.height - separateLine.height;
    [_topTabbar layoutIfNeeded];
    
    // 橙色指示条
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    underLine.height = 2.0f;
    UIButton * btn = self.topTabbarItemsArray.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.top = separateLine1.top - underLine.height;
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    _underLine.backgroundColor = [UIColor orangeColor];
    
    // 选择器容器视图
    UIScrollView * contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - kHYTopViewHeight - kHYTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(HYScreenW, 0);
    [self addSubview:contentView];
    
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.delegate = self;
    [self addTableView];
}

- (void)addTopBarItem{
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    // 正常按钮字体颜色，橙色
    [topBarItem setTitleColor:[UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1]
                     forState:UIControlStateNormal];
    // 选中后按钮字体颜色，橙色
    [topBarItem setTitleColor:[UIColor orangeColor]
                     forState:UIControlStateSelected];
    [topBarItem sizeToFit];
    topBarItem.centerY = _topTabbar.height * 0.5;
    [topBarItem addTarget:self
                   action:@selector(topBarItemClick:)
         forControlEvents:UIControlEventTouchUpInside];
    // 将按钮添加到容器中
    [self.topTabbarItemsArray addObject:topBarItem];
    // 将按钮添加到 AddressView 子视图上
    [_topTabbar addSubview:topBarItem];
}

// 分割线2
- (UIView *)separateLine{
    UIView * separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
    separateLine.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    return separateLine;
}

- (void)addTableView{

    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViewsArray.count * HYScreenW, 0, HYScreenW, _contentView.height)];
    [_contentView addSubview:tabbleView];
    [self.tableViewsArray addObject:tabbleView];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [tabbleView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil]
     forCellReuseIdentifier:@"AddressTableViewCell"];
}

#pragma mark - Custom Accessors

- (NSMutableArray *)topTabbarItemsArray{
    if (!_topTabbarItemsArray) {
        _topTabbarItemsArray = [NSMutableArray array];
    }
    return _topTabbarItemsArray;
}

- (NSMutableArray *)tableViewsArray{
    if (!_tableViewsArray) {
        _tableViewsArray = [NSMutableArray array];
    }
    return _tableViewsArray;
}

// 省级别数据源
- (NSArray *)shengDataSouce{
    if (!_shengDataSouce) {
        _shengDataSouce = [[CitiesDataTool sharedManager] queryAllProvince];
    }
    return _shengDataSouce;
}


#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.tableViewsArray indexOfObject:tableView] == 0){
        return self.shengDataSouce.count;
    }else if ([self.tableViewsArray indexOfObject:tableView] == 1){
        return self.cityDataSouce.count;
    }else if ([self.tableViewsArray indexOfObject:tableView] == 2){
        return self.districtDataSouce.count;
    }
    return self.shengDataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"
                                                                  forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 将数据源赋值给所属的 AddressTableViewCell 的 item 属性
    AddressItem *item;
    //省级别
    if([self.tableViewsArray indexOfObject:tableView] == 0){
        item = self.shengDataSouce[indexPath.row];
    //市级别
    }else if ([self.tableViewsArray indexOfObject:tableView] == 1){
        item = self.cityDataSouce[indexPath.row];
    //县级别
    }else if ([self.tableViewsArray indexOfObject:tableView] == 2){
        item = self.districtDataSouce[indexPath.row];
    }
    cell.item = item;
    return cell;
}

#pragma mark - TableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.tableViewsArray indexOfObject:tableView] == 0){

        //1.1 获取下一级别的数据源(市级别,如果是直辖市时,下级则为区级别)
        AddressItem * provinceItem = self.shengDataSouce[indexPath.row];
        self.cityDataSouce = [[CitiesDataTool sharedManager] queryAllRecordWithShengID:[provinceItem.code substringWithRange:(NSRange){0,2}]];
        if(self.cityDataSouce.count == 0){
            for (int i = 0; i < self.tableViewsArray.count && self.tableViewsArray.count != 1; i++) {
                [self removeLastItem];
            }
            [self setUpAddress:provinceItem.name];
            return indexPath;
        }
        //1.1 判断是否是第一次选择,不是,则重新选择省,切换省.
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];

        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            
            for (int i = 0; i < self.tableViewsArray.count && self.tableViewsArray.count != 1; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:provinceItem.name];
            return indexPath;
            
        }else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0){
            
            for (int i = 0; i < self.tableViewsArray.count && self.tableViewsArray.count != 1 ; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:provinceItem.name];
            return indexPath;
        }

        //之前未选中省，第一次选择省
        [self addTopBarItem];
        [self addTableView];
        AddressItem * item = self.shengDataSouce[indexPath.row];
        [self scrollToNextItem:item.name ];
        
    }else if ([self.tableViewsArray indexOfObject:tableView] == 1){
        
        AddressItem * cityItem = self.cityDataSouce[indexPath.row];
        self.districtDataSouce = [[CitiesDataTool sharedManager] queryAllRecordWithShengID:cityItem.sheng cityID:cityItem.di];
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        
        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            
            for (int i = 0; i < self.tableViewsArray.count - 1; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:cityItem.name];
            return indexPath;

        }else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0){
        
            [self scrollToNextItem:cityItem.name];
            return indexPath;
        }
        
        [self addTopBarItem];
        [self addTableView];
        AddressItem * item = self.cityDataSouce[indexPath.row];
        [self scrollToNextItem:item.name];
        
    }else if ([self.tableViewsArray indexOfObject:tableView] == 2){
        
        AddressItem * item = self.districtDataSouce[indexPath.row];
        [self setUpAddress:item.name];
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressItem * item;
    if([self.tableViewsArray indexOfObject:tableView] == 0){
       item = self.shengDataSouce[indexPath.row];
    }else if ([self.tableViewsArray indexOfObject:tableView] == 1){
       item = self.cityDataSouce[indexPath.row];
    }else if ([self.tableViewsArray indexOfObject:tableView] == 2){
       item = self.districtDataSouce[indexPath.row];
    }
    item.isSelected = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressItem * item;
    if([self.tableViewsArray indexOfObject:tableView] == 0){
        item = self.shengDataSouce[indexPath.row];
    }else if ([self.tableViewsArray indexOfObject:tableView] == 1){
        item = self.cityDataSouce[indexPath.row];
    }else if ([self.tableViewsArray indexOfObject:tableView] == 2){
        item = self.districtDataSouce[indexPath.row];
    }
    item.isSelected = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}



#pragma mark - private 

//点击按钮，下面的指示条自动滚动到对应位置
- (void)topBarItemClick:(UIButton *)btn{
    
    NSInteger index = [self.topTabbarItemsArray indexOfObject:btn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * HYScreenW, 0);
        [self changeUnderLineFrame:btn];
    }];
}

// 调整指示条位置，将指示条与最后一个按钮对齐
- (void)changeUnderLineFrame:(UIButton  *)btn{
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    _underLine.left = btn.left;
    _underLine.width = btn.width;
}

// 完成地址选择,执行 chooseFinish 代码块
- (void)setUpAddress:(NSString *)address{

    NSInteger index = self.contentView.contentOffset.x / HYScreenW;
    
    UIButton * btn = self.topTabbarItemsArray[index];
    [btn setTitle:address forState:UIControlStateNormal];
    [btn sizeToFit];
    
    [_topTabbar layoutIfNeeded]; // 自动重新布局调整按钮的位置
    [self changeUnderLineFrame:btn];
    NSMutableString * addressStr = [[NSMutableString alloc] init];
    for (UIButton * btn  in self.topTabbarItemsArray) {
        if ([btn.currentTitle isEqualToString:@"县"] || [btn.currentTitle isEqualToString:@"市辖区"] ) {
            continue;
        }
        [addressStr appendString:btn.currentTitle];
        [addressStr appendString:@" "];
    }
    self.address = addressStr;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        if (self.chooseFinish) {
            self.chooseFinish();
        }
    });
}

//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem{

    [self.tableViewsArray.lastObject performSelector:@selector(removeFromSuperview)
                                          withObject:nil
                                          withObject:nil];
    [self.tableViewsArray removeLastObject];
    
    [self.topTabbarItemsArray.lastObject performSelector:@selector(removeFromSuperview)
                                              withObject:nil
                                              withObject:nil];
    [self.topTabbarItemsArray removeLastObject];
}

// 滚动到下级界面,并重新设置顶部按钮条上对应按钮的 title
- (void)scrollToNextItem:(NSString *)preTitle{
    
    NSInteger index = self.contentView.contentOffset.x / HYScreenW;
    UIButton * btn = self.topTabbarItemsArray[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.contentSize = (CGSize){self.tableViewsArray.count * HYScreenW,0};
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + HYScreenW, offset.y);
        [self changeUnderLineFrame: [self.topTabbar.subviews lastObject]];
    }];
}


#pragma mark - <UIScrollView>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView != self.contentView) return;
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger index = scrollView.contentOffset.x / HYScreenW;
        UIButton * btn = weakSelf.topTabbarItemsArray[index];
        [weakSelf changeUnderLineFrame:btn];
    }];
}

#pragma mark - 开始就有地址时.

- (void)setAreaCode:(NSString *)areaCode{
    
    _areaCode = areaCode;
    //2.1 添加市级别,地区级别列表
    [self addTableView];
    [self addTableView];

    self.cityDataSouce = [[CitiesDataTool sharedManager] queryAllRecordWithShengID:[self.areaCode substringWithRange:(NSRange){0,2}]];
    self.districtDataSouce = [[CitiesDataTool sharedManager] queryAllRecordWithShengID:[self.areaCode substringWithRange:(NSRange){0,2}] cityID:[self.areaCode substringWithRange:(NSRange){2,2}]];//
  
    //2.3 添加底部对应按钮
    [self addTopBarItem];
    [self addTopBarItem];
    
    NSString * code = [self.areaCode stringByReplacingCharactersInRange:(NSRange){2,4} withString:@"0000"];
    NSString * provinceName = [[CitiesDataTool sharedManager] queryAllRecordWithAreaCode:code];
    UIButton * firstBtn = self.topTabbarItemsArray.firstObject;
    [firstBtn setTitle:provinceName forState:UIControlStateNormal];
    
    NSString * cityName = [[CitiesDataTool sharedManager] queryAllRecordWithAreaCode:[self.areaCode stringByReplacingCharactersInRange:(NSRange){4,2} withString:@"00"]];
    UIButton * midBtn = self.topTabbarItemsArray[1];
    [midBtn setTitle:cityName forState:UIControlStateNormal];
    
     NSString * districtName = [[CitiesDataTool sharedManager] queryAllRecordWithAreaCode:self.areaCode];
    UIButton * lastBtn = self.topTabbarItemsArray.lastObject;
    [lastBtn setTitle:districtName forState:UIControlStateNormal];
    [self.topTabbarItemsArray makeObjectsPerformSelector:@selector(sizeToFit)];
    [_topTabbar layoutIfNeeded];
    
    
    [self changeUnderLineFrame:lastBtn];
    
    //2.4 设置偏移量
    self.contentView.contentSize = (CGSize){self.tableViewsArray.count * HYScreenW,0};
    CGPoint offset = self.contentView.contentOffset;
    self.contentView.contentOffset = CGPointMake((self.tableViewsArray.count - 1) * HYScreenW, offset.y);

    [self setSelectedProvince:provinceName andCity:cityName andDistrict:districtName];
}

//初始化选中状态
- (void)setSelectedProvince:(NSString *)provinceName andCity:(NSString *)cityName andDistrict:(NSString *)districtName {
    
    for (AddressItem * item in self.shengDataSouce) {
        if ([item.name isEqualToString:provinceName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.shengDataSouce indexOfObject:item] inSection:0];
            UITableView * tableView  = self.tableViewsArray.firstObject;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
    
    for (int i = 0; i < self.cityDataSouce.count; i++) {
        AddressItem * item = self.cityDataSouce[i];
        
        if ([item.name isEqualToString:cityName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView * tableView  = self.tableViewsArray[1];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
    
    for (int i = 0; i <self.districtDataSouce.count; i++) {
        AddressItem * item = self.districtDataSouce[i];
        if ([item.name isEqualToString:districtName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView * tableView  = self.tableViewsArray[2];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
}

@end
