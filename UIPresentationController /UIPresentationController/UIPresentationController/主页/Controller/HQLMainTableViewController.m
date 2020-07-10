//
//  HQLMainTableViewController.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLMainTableViewController.h"

// Frameworks
#import <Mantle.h>

// Controller
#import "HQLModalViewController.h"

#import "HQLFirstViewController.h"
#import "HQLSecondViewController.h"
#import "HQLThirdViewController.h"
#import "HQLShowPasswordViewController.h"

#import "AAPLCustomPresentationFirstViewController.h"
#import "AAPLCrossDissolveFirstViewController.h"

// Models
#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMainTableViewController ()

@property (nonatomic, strong) NSArray<HQLTableViewCellStyleDefaultModel *> *dataSourceArray;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;

@end

@implementation HQLMainTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    [self setupTableView];
}


#pragma mark - Custom Accessors

// 从 mainTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray<HQLTableViewCellStyleDefaultModel *> *)dataSourceArray {
    if (!_dataSourceArray) {

        // 1.构造 mainTableViewTitleModel.plist 文件 URL 路径
        NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        NSURL *url = [bundleURL URLByAppendingPathComponent:@"mainTableViewTitleModel.plist"];
        
        // 2.读取 mainTableViewTitleModel.plist 文件，并存放进 jsonArray 数组
        NSArray *jsonArray;
        if (@available(iOS 11.0, *)) {
            NSError *readFileError = nil;
            jsonArray = [NSArray arrayWithContentsOfURL:url error:&readFileError];
            NSAssert1(jsonArray, @"NSPropertyList File read error:\n%@", readFileError);
        } else {
            jsonArray = [NSArray arrayWithContentsOfURL:url];
            NSAssert(jsonArray, @"NSPropertyList File read error.");
        }
        
        // 3.将 jsonArray 数组中的 JSON 数据转换成 HQLTableViewCellGroupedModel 模型
        NSError *decodeError = nil;
        _dataSourceArray = [MTLJSONAdapter modelsOfClass:HQLTableViewCellGroupedModel.class
                                     fromJSONArray:jsonArray
                                             error:&decodeError];
        NSAssert1(_dataSourceArray, @"JSONArray decode error:\n%@", decodeError);
    }
    return _dataSourceArray;
}


#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLGroupedArrayDataSource alloc] initWithGroupsArray:self.dataSourceArray cellReuseIdentifier:cellReuseIdentifier configureBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section = %ld, row = %ld",(long)indexPath.section,indexPath.row);
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    [self presentModalViewControllerWithFullScreen];
                    break;
                }
                case 1: {
                    [self presentModalViewControllerWithPageSheet];
                    break;
                }
                case 2: {
                    [self presentModalViewControllerWithFormSheet];
                    break;
                }
                case 3: {
                    [self presentModalViewControllerWithCurrentContext];
                    break;
                }
                case 4: {
                    [self presentModalViewControllerWithCurrentCustom];
                    break;
                }
                case 5: {
                    [self presentModalViewControllerWithOverFullScreen];
                    break;
                }
                case 6: {
                    [self presentModalViewControllerWithOverCurrentContext];
                    break;
                }
                case 7: {
                    [self presentModalViewControllerWithPopover];
                    break;
                }
                case 8: {
                    [self presentModalViewControllerWithAutomatic];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    [self presentModalViewControllerWithCoverVertical];
                    break;
                }
                case 1: {
                    [self presentModalViewControllerWithCrossDissolve];
                    break;
                }
                case 2: {
                    [self presentModalViewControllerWithCrossDissolve];
                    break;
                }
                case 3: {
                    [self presentModalViewControllerWithPartialCurl];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    HQLFirstViewController *aFirstViewController = [[HQLFirstViewController alloc] init];
                    [self.navigationController pushViewController:aFirstViewController animated:YES];
                    break;
                }
                case 1: {
                    HQLSecondViewController *aSecondViewController = [[HQLSecondViewController alloc] init];
                    [self.navigationController pushViewController:aSecondViewController animated:YES];
                    break;
                }
                case 2: {
                    HQLThirdViewController *aSecondViewController = [[HQLThirdViewController alloc] init];
                    [self.navigationController pushViewController:aSecondViewController animated:YES];
                    break;
                }
                case 3: {
                    HQLShowPasswordViewController *vc = [[HQLShowPasswordViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
            
        case 3: {
            
            switch (indexPath.row) {
                case 0: {
                    // 通过加载 storyboard 的方式初始化视图控制器
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CrossDissolve" bundle:[NSBundle mainBundle]];
                    // 获取在 storyboard 中勾选并设置为 Initial View Controller 的视图控制器
                    id initialViewController = [storyboard instantiateInitialViewController];
                    [self.navigationController pushViewController:initialViewController animated:YES];

                    break;
                }
                case 1: {
                    // 通过加载 storyboard 的方式初始化视图控制器
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Swipe" bundle:[NSBundle mainBundle]];
                    // 获取在 storyboard 中勾选并设置为 Initial View Controller 的视图控制器
                    id initialViewController = [storyboard instantiateInitialViewController];
                    [self.navigationController pushViewController:initialViewController animated:YES];
                    break;
                }
                case 2: {
                    // 这个示例通过 NIB 文件的方式加载视图控制器
                    AAPLCustomPresentationFirstViewController *aFirstViewController = [[AAPLCustomPresentationFirstViewController alloc] init];
                    [self.navigationController pushViewController:aFirstViewController animated:YES];
                    break;
                }
                case 3: {
                    // 通过加载 storyboard 的方式初始化视图控制器
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdaptivePresentation" bundle:[NSBundle mainBundle]];
                    // 获取在 storyboard 中勾选并设置为 Initial View Controller 的视图控制器
                    id initialViewController = [storyboard instantiateInitialViewController];
                    [self.navigationController pushViewController:initialViewController animated:YES];
                    break;
                }
                case 4: {
                    // 通过加载 storyboard 的方式初始化视图控制器
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Checkerboard" bundle:[NSBundle mainBundle]];
                    // 获取在 storyboard 中勾选并设置为 Initial View Controller 的视图控制器
                    id initialViewController = [storyboard instantiateInitialViewController];
                    [self presentViewController:initialViewController animated:YES completion:NULL];
                    break;
                }
                case 5: {
                    // 通过加载 storyboard 的方式初始化视图控制器
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Slide" bundle:[NSBundle mainBundle]];
                    // 获取在 storyboard 中勾选并设置为 Initial View Controller 的视图控制器
                    id initialViewController = [storyboard instantiateInitialViewController];
                    [self presentViewController:initialViewController animated:YES completion:NULL];
                    break;
                }
                    
                default:
                    break;
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - 模态样式

/**
 模态样式属性 modalPresentationStyle 是一个枚举类型
 
 typedef NS_ENUM(NSInteger, UIModalPresentationStyle) {
     UIModalPresentationFullScreen = 0,
     UIModalPresentationPageSheet API_AVAILABLE(ios(3.2)) API_UNAVAILABLE(tvos),
     UIModalPresentationFormSheet API_AVAILABLE(ios(3.2)) API_UNAVAILABLE(tvos),
     UIModalPresentationCurrentContext API_AVAILABLE(ios(3.2)),
     UIModalPresentationCustom API_AVAILABLE(ios(7.0)),
     UIModalPresentationOverFullScreen API_AVAILABLE(ios(8.0)),
     UIModalPresentationOverCurrentContext API_AVAILABLE(ios(8.0)),
     UIModalPresentationPopover API_AVAILABLE(ios(8.0)) API_UNAVAILABLE(tvos),
     UIModalPresentationBlurOverFullScreen API_AVAILABLE(tvos(11.0)) API_UNAVAILABLE(ios) API_UNAVAILABLE(watchos),
     UIModalPresentationNone API_AVAILABLE(ios(7.0)) = -1,
     UIModalPresentationAutomatic API_AVAILABLE(ios(13.0)) = -2,
 };
 */

/**
 MARK: UIModalPresentationFullScreen 全屏样式
 
 使用这种模式时，presented VC 的宽高与屏幕相同，并且 UIKit 会直接使用 rootViewController 做为 presentation context，在此次 presentation 完成之后，UIKit 会将 presentation context 及其子 VC 都移出 UI 栈，这时候观察 VC 的层级关系，会发现 UIWindow 下只有 presented VC。
 */
- (void)presentModalViewControllerWithFullScreen {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：全屏
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}

/**
 MARK: UIModalPresentationPageSheet 页面纸张样式
 
 在常规型设备（大屏手机，例如 plus 系列以及 iPad 系列）的水平方向，presented VC 的高为当前屏幕的高度，宽为该设备竖直方向屏幕的宽度，其余部分用透明背景做填充。
 
 对于紧凑型设备（小屏手机）的水平方向及所有设备的竖直方向，其显示效果与 UIModalPresentationFullScreen 相同。
 */
- (void)presentModalViewControllerWithPageSheet {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：页面纸张
    viewController.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}

/**
 MARK: UIModalPresentationFormSheet 表单样式
 
 在常规型设备的水平方向，presented VC 的宽高均小于屏幕尺寸，其余部分用透明背景填充。
 
 对于紧凑型设备的水平方向及所有设备的竖直方向，其显示效果与 UIModalPresentationFullScreen 相同
 */
- (void)presentModalViewControllerWithFormSheet {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：表单
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}

/**
 MARK: UIModalPresentationCurrentContext 以当前文本为呈现视图
 
 使用这种方式 present VC 时，presented VC 的宽高取决于 presentation context 的宽高，并且 UIKit 会寻找属性 definesPresentationContext 为 YES 的 VC 作为 presentation context。
 当此次 presentation 完成之后，presentation context 及其子 VC 都将被暂时移出当前的 UI 栈。
 
 需要当前视图控制器设置：
 self.definesPresentationContext = YES
 */
- (void)presentModalViewControllerWithCurrentContext {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：以当前文本为 presenting view
    viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}

/**
 MARK: UIModalPresentationCustom 自定义模式
 
 需要实现 UIViewControllerTransitioningDelegate 的相关方法，并将 presented VC 的 transitioningDelegate 设置为实现了 UIViewControllerTransitioningDelegate 协议的对象。
 */
- (void)presentModalViewControllerWithCurrentCustom {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：自定义模式
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}

/**
 MARK: UIModalPresentationOverFullScreen 全屏样式2
 
 与 UIModalPresentationFullScreen 的唯一区别在于，UIWindow 下除了 presented VC，还有其他正常的 VC 层级关系。也就是说该模式下，UIKit 以 rootViewController 为 presentation context，但 presentation 完成之后不会将 rootViewController 移出当前的 UI 栈。
 
 
 !!!: 总结
 UIModalPresentationFullScreen 在此次 presentation 完成之后，UIKit 会将 presentation context 及其子 VC 都移出 UI 栈。
 
 UIModalPresentationOverFullScreen 在此次 presentation 完成之后，UIKit 不会将 rootViewController 移出当前的 UI 栈。
 */
- (void)presentModalViewControllerWithOverFullScreen {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：全屏样式2
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}

/**
 MARK: UIModalPresentationOverCurrentContext 基于当前文本样式 2
 
 寻找 presentation context 的方式与 UIModalPresentationCurrentContext 相同，
 
 所不同的是 presentation 完成之后，不会将 context 及其子 VC 移出当前 UI 栈。
 
 但是，这种方式只适用于 transition style 为 UIModalTransitionStyleCoverVertical 的情况 (UIKit 默认就是这种 transition style)。其他 transition style 下使用这种方式将会触发异常。
 */
- (void)presentModalViewControllerWithOverCurrentContext {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：基于当前文本样式 2
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}

/**
 MARK: UIModalPresentationPopover Popover 样式
 
 */
- (void)presentModalViewControllerWithPopover {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：Popover 样式
    viewController.modalPresentationStyle = UIModalPresentationPopover;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}

/**
 MARK: UIModalPresentationAutomatic 自动样式，默认
 
 */
- (void)presentModalViewControllerWithAutomatic {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：自动样式
    viewController.modalPresentationStyle = UIModalPresentationAutomatic;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}



#pragma mark - 转场样式

/**

转场样式

typedef NS_ENUM(NSInteger, UIModalTransitionStyle) {
    UIModalTransitionStyleCoverVertical = 0, // 从底部向上滑入
    UIModalTransitionStyleFlipHorizontal API_UNAVAILABLE(tvos), // 水平翻转
    UIModalTransitionStyleCrossDissolve, // 交叉溶解

    // 纸张翻页效果，模态样式必须为 UIModalPresentationFullScreen
    UIModalTransitionStylePartialCurl API_AVAILABLE(ios(3.2)) API_UNAVAILABLE(tvos),
};
*/

// MARK: 从底部向上滑入，默认样式
- (void)presentModalViewControllerWithCoverVertical {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：全屏
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    // 设置模态视图的转场样式：从底部向上滑入
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}

// MARK: 水平翻转
- (void)presentModalViewControllerWithFlipHorizontal {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：自动
    viewController.modalPresentationStyle = UIModalPresentationAutomatic;
    // 设置模态视图的转场样式：水平翻转
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}

// MARK: 交叉溶解
- (void)presentModalViewControllerWithCrossDissolve {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // 设置模态视图样式：全屏
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    // 设置模态视图的转场样式：交叉溶解
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}

// MARK: 纸张翻页效果
- (void)presentModalViewControllerWithPartialCurl {
    HQLModalViewController *viewController = [[HQLModalViewController alloc] init];
    
    // !!!: 设置纸张翻页效果时，模态样式必须为 UIModalPresentationFullScreen
    // 设置模态视图样式：全屏
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    // 设置模态视图的转场样式：纸张翻页效果
    viewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    [self presentViewController:viewController animated:YES completion:^{
        NSLog(@"模态视图控制器呈现完成后调用...");
    }];
}





@end
