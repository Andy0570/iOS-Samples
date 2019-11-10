//
//  HQLHyponsisViewController.m
//  HQLHypnoNerd
//
//  Created by ToninTech on 16/8/19.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLHypnosisView.h"
#import "HQLHyponsisViewController.h"

//  【lazy loading 延迟加载视图】
//  视图控制器不会在其被创建出来的那一刻马上创建并载入相应的视图，只有当应用需要将某个视图控制器的视图显示到屏幕上时，相应的视图控制器才会创建其视图。
//  也就是说，视图控制器刚被创建时，其view属性会被初始化为nil。之后，当应用需要将视图控制器的视图显示到屏幕上时，如果view属性是nil,就会自动调用 loadview 方法。

/**
 *  view 属性继承自 UIViewControl:
 *  @property(null_resettable, nonatomic,strong) UIView *view;
 *  如果视图还没有被设置，那么get方法会首先调用自身的 loadView 方法，如果重写了 setter 或 getter 方法，子类必须调用父类。
 */

//  ⚠️ 为了实现视图延迟加载，在 initWithNibName：bundle：中不应该访问view或View的任何子视图。凡是和view或view的子视图有关的代码，都应该在 viewDidLoad 方法中实现，避免加载不需要在屏幕上显示的视图

/**
 *  视图控制器可以通过两种方式创建视图层次结构：
 *  代码方式：覆盖 UIViewController 中的 loadView 方法
 *  文件方式：使用interface builder创建一个 nib 文件，然后加入所需的视图层次结构
 */

/*
 将 HQLHyponsisViewControl 类声明为遵守 <UITextFieldDelegate> 协议
 即可让编译器检查某个类是否实现了相关协议的必需方法。
 */
@interface HQLHyponsisViewController () <UITextFieldDelegate>

@property (nonatomic, strong) HQLHypnosisView *backgroundView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation HQLHyponsisViewController

#pragma mark - Lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // 设置标签页的标题
        self.tabBarItem.title = @"Hypontize";
        // 从图像文件创建一个 UIImage 对象
        // 在 Retina 显示屏上会加载 Hypno@2X.png 而不是 Hypno.png
        UIImage *i =[UIImage imageNamed:@"Hypon"];
        // 将UIImage对象赋给标签项的image属性
        self.tabBarItem.image = i;

    }
    return self;
}

// 覆盖该方法并使用代码方式设置视图控制器的 view 属性
- (void)loadView {
    [super loadView];
    
    // 将 HQLHypnosisView 对象赋值给视图控制器的 view 属性
    self.view = self.backgroundView;
    
    // 添加分段控件
    [self.view addSubview:self.segmentedControl];
    
    // 把 textFiled 添加到视图中
    [self.view addSubview:self.textField];
    
}

// 该方法会在视图控制器加载完视图后被调用
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"HQLHypnosisView loaded its view.");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors

- (HQLHypnosisView *)backgroundView {
    if (!_backgroundView) {
        // 创建一个 HQLHypnosisView 对象
        _backgroundView = [[HQLHypnosisView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _backgroundView;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Red",@"Green",@"Blue"]];
        CGRect segmentedFrame = CGRectMake(40, 100, self.view.frame.size.width - 80, 40);
        _segmentedControl.frame = segmentedFrame;
        // 默认选中下标为 0 的 Item
        _segmentedControl.selectedSegmentIndex = 0;
        
        [_segmentedControl addTarget:self
                             action:@selector(segmentedValueChanged:)
                   forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UITextField *)textField {
    if (!_textField) {
        
        // UITextFiled文本框，可以接受用户输入的文本
        
        // 初始化textFiled,并设置位置及大小
        CGRect textFiledRect = CGRectMake(40, 180, 240, 30);
        _textField = [[UITextField alloc] initWithFrame:textFiledRect];
        // 设置UITextFiled对象的边框样式
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        // 当输入框无内容时，设置占位符提示
        _textField.placeholder = @"Hypontize me";
        // 设置字体颜色
        _textField.textColor = [UIColor colorWithRed:0.217 green:0.130 blue:0.172 alpha:1];
        // 输入框中是否显示×号，用于清空输入框内容
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        // 再次编辑就清空
        _textField.clearsOnBeginEditing = YES;
        // 内容对齐方式
        _textField.textAlignment =  NSTextAlignmentCenter;
        // 文本自适应文本窗口大小.默认是保持原来大小,而让长文本滚动
        _textField.adjustsFontSizeToFitWidth = YES;
        // 设置键盘样式
        _textField.keyboardType = UIKeyboardTypeDefault;
        // 软键盘换行键默认显示值
        _textField.returnKeyType = UIReturnKeyDone;
        // 键盘外观
        _textField.keyboardAppearance = UIKeyboardAppearanceLight;
        // 换行键自动监测功能,如果将该属性设置为YES，UITextField对象会自动监测用户输入，并根据是否输入了文字启用/禁用换行键,如果文本内容长度为0，则禁用换行键，如果文本内容长度不为0，则启用换行键。
        _textField.enablesReturnKeyAutomatically = YES;
        
        // 最左侧加图片
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
        _textField.leftView = imageView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        
        // 设置委托
        // 通过设置委托，UITextField 对象会在发生事件时向委托发送相应的消息，由委托处理该事件。
        // 1. 将 HQLHyponsisViewControl 类声明为遵守 UITextFieldDelegate 协议
        // 2. 将 UITextField 对象的委托属性设置为 HQLHyponsisViewControl 自身
        _textField.delegate = self;
        
    }
    return _textField;
}

#pragma mark - IBActions

- (void)segmentedValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.backgroundView.circleColor = [UIColor redColor];
            break;
        case 1:
            self.backgroundView.circleColor = [UIColor greenColor];
            break;
        case 2:
            self.backgroundView.circleColor = [UIColor blueColor];
            break;
        default:
            break;
    }
    [self.backgroundView setNeedsDisplay];
}


#pragma mark - UITextFieldDelegate

/**
 *  委托方法
 *  对于编辑UITextField对象文本内容的事件，有以下两个对应的委托方法：
 *
 - (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
 
 还有一类带有返回值的委托方法，用于从委托中查询需要的信息
 - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
 
 - (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
 
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
 
 - (BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
 - (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.

 */

// 当“return”键被按下时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField;  {
    
    // 将字符传值textField ——> messageLabel
    [self drawHypnoticMessage:textField.text];
    // 文本清空
    textField.text = @"";
    // 放弃第一响应者,收起弹出的键盘
    [textField resignFirstResponder];

    return YES;
}

// 在屏幕随机位置绘制20个 UILabel 对象
- (void)drawHypnoticMessage:(NSString *)message {
    
    for (int i = 0; i < 20; i ++) {
        UILabel *messageLabel = [[UILabel alloc] init];
        // 设置UILabel对象的文字和颜色
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.text = message;
        // 根据需要显示的文字调整UILabel对象的大小
        [messageLabel sizeToFit];
        
        // 获取随机x坐标
        // 使UILabel对象的宽度不超出HQLHyponsisViewController的view的宽度
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;
        
        // 获取随机y坐标
        // 使UILabel对象的高度不超出HQLHyponsisViewController的view的高度
        int height = (int)(self.view.bounds.size.width - messageLabel.bounds.size.height);
        int y = 184 + arc4random() % height;
        
        // 设置UILabel对象的frame
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;
        
        // 将UILabel对象添加到HQLHyponsisViewController的view中
        [self.view addSubview:messageLabel];
        
        // 设置messageLabel透明度的起始值
        messageLabel.alpha = 0.0;
        // 让messageLabel的透明度由0.0变为1.0
        [UIView animateWithDuration:0.5
                         animations:^{
                             messageLabel.alpha = 1.0;
                         }];
        
        
        // 运行效果:水平方向和垂直方向的视差效果
        // 设置UILabel 对象的中心点坐标在每个方向上最多移动25点
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
    }
}

@end


