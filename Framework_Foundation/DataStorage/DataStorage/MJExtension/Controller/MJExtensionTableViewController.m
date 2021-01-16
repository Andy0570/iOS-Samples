//
//  MJExtensionTableViewController.m
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/16.
//

#import "MJExtensionTableViewController.h"

// Framework
#import <MJExtension.h>
#import <JKCategories/NSDate+JKFormatter.h>

// Model
#import "MJTableViewSection.h"

static NSString * const kPlistFileName = @"MJTableViewModel.plist";
static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface MJExtensionTableViewController ()
@property (nonatomic, strong) NSArray<MJTableViewSection *> *sections;
@end

@implementation MJExtensionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MJExtension 示例";
    [self setupDatas];
}

- (void)setupDatas {
    // 1.构造 MJTableViewModel.plist 文件 URL 路径
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSURL *plistURL = [bundleURL URLByAppendingPathComponent:kPlistFileName];
    
    // 2.读取 MJTableViewModel.plist 文件，并存放到 jsonArray 数组
    NSArray *jsonArray;
    if (@available(iOS 11.0, *)) {
        NSError *readFileError = nil;
        jsonArray = [NSArray arrayWithContentsOfURL:plistURL error:&readFileError];
        NSAssert1(jsonArray, @"NSPropertyList File read error:\n%@", readFileError);
    } else {
        jsonArray = [NSArray arrayWithContentsOfURL:plistURL];
        NSAssert(jsonArray, @"NSPropertyList File read error.");
    }
    
    // 3.将 jsonArray 数组中的 JSON 数据转换成 MJTableViewSection 模型
    NSArray *modelArray = [MJTableViewSection mj_objectArrayWithKeyValuesArray:jsonArray];
    // MARK: MJExtension 缺点：不支持自动打印输出实例的 description 描述信息
    NSLog(@"JSON Array -> Model Array:\n%@",modelArray);
    
    self.sections = modelArray;
    [self.tableView reloadData];
}

#pragma mark - Private

- (MJTableViewCell *)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(_sections.count > indexPath.section, @"index section out of Array Bounds.");
    MJTableViewSection *sectionModel = _sections[indexPath.section];
    NSArray *cells = sectionModel.cells;
    
    NSAssert(cells.count > indexPath.row, @"Index row out of Array Bounds.");
    return cells[indexPath.row];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sections[section].cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentifier];
    }
    
    MJTableViewCell *model = [self cellModelAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:model.imageName];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = [model.date jk_formatWithLocalTimeZone];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MJTableViewCell *model = [self cellModelAtIndexPath:indexPath];
    NSLog(@"select model:\n%@",model);
}

@end
