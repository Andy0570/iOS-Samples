//
//  HQLReminderViewController.m
//  HQLHypnoNerd
//
//  Created by ToninTech on 16/8/19.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLReminderViewController.h"

@interface HQLReminderViewController ()

// 声明一个 datePicker(日期选择器) 属性
// ⚠️ 此处将 datePicker 的插座变量声明为弱引用是一种编程约定。
// 当系统的可用内存偏少时，视图控制器会自动释放其视图并在之后需要显示时再创建。
// 因此，视图控制器应该使用弱引用特性的插座变量指向 view 的子视图，以便在释放 view 时同时释放 view 的所有子视图，从而避免内存泄漏
// 对象所有权：
// 视图控制器 ——> View ——> View 中的子视图
// 视图控制器 — —> （通过插座变量指向）View 中的子视图
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation HQLReminderViewController

// 该方法是 UIViewController 的指定初始化方法，指定 NIB 文件的文件名及其所在的程序包。
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // 获取tabBarItem属性所是向的UITabBarItem对象
        UITabBarItem *tbi = self.tabBarItem;
        //设置UITabBarItem对象的标题
        tbi.title = @"Reminder";
        //从图像文件创建一个UIImage对象
        UIImage *i =[UIImage imageNamed:@"Time"];
        //将UIImage对象赋给标签项的image属性
        tbi.image = i;
        
    }
    return self;
}

/* 
 * 访问 nib 文件中视图的方法：
 
 * viewDidLoad: 视图控制器加载完 nib 文件之后被调用。
 * viewWillAppear:  视图控制器的 view 添加到应用窗口之前被调用。
 
 * ⚠️ 区别：
 *  如果只需要在应用启动后设置一次视图对象，就选择 viewDidLoad；
 *  如果用户每次看到视图控制器view时都需要对其进行设置，则选择 viewWillAppear
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"HQLReminderViewController loaded its view.");
}

- (void)viewWillAppear:(BOOL)animated {
    
    // animated 参数用于设置：是否使用视图显示或消失的过渡动画
    [super viewWillAppear:animated];
    
    // minimumDate,可供选择的最小时间
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 实现本地通知
- (IBAction)addReminder:(id)sender {
    
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@",date);
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    
    // 创建 UILocalNotification 对象
    UILocalNotification *note = [[UILocalNotification alloc] init];
    // 设置显示内容
    note.alertBody = @"Hypnotize me!";
    // 设置提醒时间
    note.fireDate = date;
    
    // 使用 scheduleLocalNotification: 方法注册通知
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
    
    NSLog(@"addReminder run over");
}

@end
