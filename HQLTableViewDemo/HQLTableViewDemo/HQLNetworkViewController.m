//
//  HQLNetworkViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/12.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLNetworkViewController.h"

// 第三方框架
#import <Chameleon.h>
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>
#import <AFNetworking.h>
#import <MBProgressHUD.h>

// model
#import "HQLGovermentModel.h"

// Controller
#import "HQLGovermentTableViewController.h"

// 聚合数据 - 上海市政数据
static NSString *const AppKey = @"5718abc3837ecb471c5d5b1ef1e35130";
static NSString *const URL_String = @"https://op.juhe.cn/shanghai/police";

@interface HQLNetworkViewController ()

@property(nonatomic, strong) UIButton *requestButton;

@end

@implementation HQLNetworkViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"AFNetworking";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加按钮
    [self.view addSubview:self.requestButton];
    [self.requestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(24);
        make.right.equalTo(self.view).with.offset(-24);
        make.height.mas_equalTo(52);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-20);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view).with.offset(-20);
        }
    }];
}

#pragma mark - Custom Accessors

- (UIButton *)requestButton {
    if (!_requestButton) {
        _requestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // 设置圆角按钮
        _requestButton.layer.cornerRadius = 5.f;
        _requestButton.layer.masksToBounds = YES;
        // 标题
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:18],
                                     NSForegroundColorAttributeName:[UIColor whiteColor]
                                     };
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"发起POST请求"
                                                                    attributes:attributes];
        [_requestButton setAttributedTitle:title forState:UIControlStateNormal];
        // 背景颜色
        [_requestButton setBackgroundImage:[UIImage imageWithColor:HexColor(@"#108EE9")]
                                  forState:UIControlStateNormal];
        [_requestButton setBackgroundImage:[UIImage imageWithColor:HexColor(@"#1284D6")]
                                  forState:UIControlStateHighlighted];
        [_requestButton addTarget:self
                           action:@selector(requestButtonDidClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _requestButton;
}


#pragma mark - IBActions

- (void)requestButtonDidClicked:(id)sender {
    [self requestDataFromServer];
}


#pragma mark - Private

// 发起 POST 请求
- (void)requestDataFromServer {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // 1.创建 AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.构建请求参数
    NSDictionary *parameters = @{
                                 @"key":AppKey,
                                 @"dtype":@"json"
                                 };

    // 3.创建任务
    [manager POST:URL_String parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        // 进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        
        // 处理数据
        HQLGovermentModel *resultModel = [HQLGovermentModel modelWithJSON:responseObject];
        NSLog(@"resultModel:\n%@",resultModel);
        
        // 推入下一个视图控制器
        HQLGovermentTableViewController *govermentTableViewController = [[HQLGovermentTableViewController alloc] initWithGovermentModel:resultModel];
        [self.navigationController pushViewController:govermentTableViewController animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        
        
        NSLog(@"%@",error.localizedDescription);
    }];
}

@end
