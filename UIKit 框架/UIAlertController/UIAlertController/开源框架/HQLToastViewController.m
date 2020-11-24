//
//  HQLToastViewController.m
//  UIAlertController
//
//  Created by Qilin Hu on 2020/11/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLToastViewController.h"
#import <UIView+Toast.h>

static NSString * const ZOToastSwitchCellId = @"ZOToastSwitchCellId";
static NSString * const ZOToastDemoCellId = @"ZOToastDemoCellId";

@interface HQLToastViewController ()

@property (nonatomic, assign, getter=isShowingActivity) BOOL showingActivity;
@property (nonatomic, strong) UISwitch *tapToDismissSwitch;
@property (nonatomic, strong) UISwitch *queueSwitch;

@end

@implementation HQLToastViewController

#pragma mark - Initialize

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Toast";
        self.showingActivity = NO;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:ZOToastDemoCellId];
}

#pragma mark - Events

- (void)handleTapToDismissToggled {
    // 设置支持点击即隐藏，默认为 YES
    [CSToastManager setTapToDismissEnabled:![CSToastManager isTapToDismissEnabled]];
}

- (void)handleQueueToggled {
    // 开启队列显示，默认为 NO
    [CSToastManager setQueueEnabled:![CSToastManager isQueueEnabled]];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 11;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"设置";
    } else {
        return @"示例";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZOToastSwitchCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZOToastSwitchCellId];
            self.tapToDismissSwitch = [[UISwitch alloc] init];
            _tapToDismissSwitch.onTintColor = [UIColor colorWithRed:239.0 / 255.0 green:108.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
            [_tapToDismissSwitch addTarget:self action:@selector(handleTapToDismissToggled) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = _tapToDismissSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        }
        cell.textLabel.text = @"Tap to Dismiss";
        [_tapToDismissSwitch setOn:[CSToastManager isTapToDismissEnabled]];
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZOToastSwitchCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZOToastSwitchCellId];
            self.queueSwitch = [[UISwitch alloc] init];
            _queueSwitch.onTintColor = [UIColor colorWithRed:239.0 / 255.0 green:108.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
            [_queueSwitch addTarget:self action:@selector(handleQueueToggled) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = _queueSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        }
        cell.textLabel.text = @"Queue Toast";
        [_queueSwitch setOn:[CSToastManager isQueueEnabled]];
        return cell;
    } else {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ZOToastDemoCellId forIndexPath:indexPath];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Make toast";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Make toast on top for 3 seconds";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Make toast with a title";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"Make toast with an image";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = @"Make toast with a title, image, and completion block";
        } else if (indexPath.row == 5) {
            cell.textLabel.text = @"Make toast with a custom style";
        } else if (indexPath.row == 6) {
            cell.textLabel.text = @"Show a custom view as toast";
        } else if (indexPath.row == 7) {
            cell.textLabel.text = @"Show an image as toast at point\n(110, 110)";
        } else if (indexPath.row == 8) {
            cell.textLabel.text = (self.isShowingActivity) ? @"Hide toast activity" : @"Show toast activity";
        } else if (indexPath.row == 9) {
            cell.textLabel.text = @"Hide toast";
        } else if (indexPath.row == 10) {
            cell.textLabel.text = @"Hide all toasts";
        }
        
        return cell;
    }
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { return; }
    
    if (indexPath.row == 0) {
        
        // MARK: 1.基本用法
        [self.navigationController.view makeToast:@"This is a piece of toast."];
        
    } else if (indexPath.row == 1) {
        
        // MARK: 2.指定位置和持续时间
        // duration：显示 Toast 的持续时间，默认显示 3.0 秒后自动消失。
        // position：显示 Toast 的位置，
        // 可选位置参数：CSToastPositionTop、CSToastPositionCenter、CSToastPositionBottom
        [self.navigationController.view makeToast:@"This is a piece of toast with a specific duration and position."
                                         duration:3.0
                                         position:CSToastPositionTop];
        
    } else if (indexPath.row == 2) {
        
        // MARK: 3.指定标题
        [self.navigationController.view makeToast:@"This is a piece of toast with a title"
                                         duration:2.0
                                         position:CSToastPositionTop
                                            title:@"Toast Title"
                                            image:nil
                                            style:nil
                                       completion:nil];
        
    } else if (indexPath.row == 3) {
        
        // MARK: 3.指定图片
        [self.navigationController.view makeToast:@"This is a piece of toast with an image"
                                         duration:2.0
                                         position:CSToastPositionCenter
                                            title:nil
                                            image:[UIImage imageNamed:@"toast"]
                                            style:nil
                                       completion:nil];
        
    } else if (indexPath.row == 4) {
        
        // MARK: 4.带所有可自定义配置选项的 Toast
        [self.navigationController.view makeToast:@"This is a piece of toast with a title, image, and completion block"
                                         duration:2.0
                                         position:CSToastPositionBottom
                                            title:@"Toast Title"
                                            image:[UIImage imageNamed:@"toast"]
                                            style:nil
                                       completion:^(BOOL didTap) {
                                           if (didTap) {
                                               NSLog(@"completion from tap");
                                           } else {
                                               NSLog(@"completion without tap");
                                           }
                                       }];
        
    } else if (indexPath.row == 5) {
        
        // MARK: 5.自定义样式
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageFont = [UIFont fontWithName:@"Zapfino" size:14.0];
        style.messageColor = UIColor.redColor;
        style.messageAlignment = NSTextAlignmentCenter;
        style.backgroundColor = UIColor.yellowColor;
        
        [self.navigationController.view makeToast:@"This is a piece of toast with a custom style"
                                         duration:3.0
                                         position:CSToastPositionBottom
                                            style:style];
        
    } else if (indexPath.row == 6) {
        
        // MARK: 6.自定义视图
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
        // autoresizing masks are respected on custom views
        customView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        customView.backgroundColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];
        
        [self.navigationController.view showToast:customView duration:2.0 position:CSToastPositionCenter completion:nil];
        
    } else if (indexPath.row == 7) {
        
        // MARK: 在 (110, 110) 的位置显示一张图片作为 Toast
        UIImageView *toastView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast"]];
        
        [self.navigationController.view showToast:toastView
                                         duration:2.0
                                         position:[NSValue valueWithCGPoint:CGPointMake(110, 110)] // 将 CGPoint 包装到 NSValue 中
                                       completion:nil];
        
    } else if (indexPath.row == 8) {
        
        // MARK: 显示加载活动指示器的 Toast，这个方法类似于 MBProgressHUD
        [self.navigationController.view makeToastActivity:CSToastPositionCenter];
        
        // 5s 后隐藏
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [self.navigationController.view hideToastActivity];
        });
        
    } else if (indexPath.row == 9) {
        
        // MARK: 隐藏 Toast
        [self.navigationController.view hideToast];
        
    } else if (indexPath.row == 10) {
        
        // MARK: 隐藏所有的 Toast
        [self.navigationController.view hideAllToasts];
        
    }
}

@end
