//
//  BEMCheckBoxViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/12/3.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "BEMCheckBoxViewController.h"
#import <BEMCheckBox/BEMCheckBox.h>
#import <Chameleon.h>
#import <Masonry.h>

@interface BEMCheckBoxViewController () <BEMCheckBoxDelegate>

@property (nonatomic, strong) BEMCheckBox *checkBox;
@property (nonatomic, strong) UILabel *checkBoxLabel;

@property (nonatomic, strong) BEMCheckBoxGroup *checkBoxGroup;
@property (nonatomic, strong) BEMCheckBox *checkBox1;
@property (nonatomic, strong) BEMCheckBox *checkBox2;

@end

@implementation BEMCheckBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.flatWhiteColor;
    
    [self.view addSubview:self.checkBox];
    [self.view addSubview:self.checkBoxLabel];

    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(20);
        make.left.equalTo(self.view).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    [self.checkBoxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkBox.mas_centerY);
        make.left.equalTo(self.checkBox.mas_right).with.offset(8);
    }];

    
//    // 选中单选框
//    self.checkBox.on = YES;
//    [self.checkBox setOn:YES animated:YES];
//
//    // 重新加载
//    [self.checkBox reload];
    
    
    [self addSubviews];
    [self setupBEMCheckBoxGroup];
    // 查看当前组按钮中哪一个复选框被选中
    // BEMCheckBox *selection = self.group.selectedCheckBox;
}

- (BEMCheckBox *)checkBox {
    if (!_checkBox) {
        _checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectZero]; //25*25
        // 外观属性
        // 矩形复选框
        _checkBox.boxType = BEMBoxTypeSquare;
        _checkBox.lineWidth = 1.0; // 复选标记和框的线宽，默认 2.0
        // 颜色样式
        _checkBox.tintColor    = [UIColor lightGrayColor]; // 复选框处于关闭时，框的颜色
        _checkBox.onTintColor  = HexColor(@"#108EE9");     // 复选框处于打开时，框的颜色
        _checkBox.onFillColor  = [UIColor clearColor];     // 复选框处于打开时，框内的填充色
        _checkBox.onCheckColor = HexColor(@"#108EE9");     // 复选框处于打开时，复选标记的颜色
        // 动画样式
        _checkBox.onAnimationType  = BEMAnimationTypeStroke;
        _checkBox.offAnimationType = BEMAnimationTypeStroke;
        _checkBox.animationDuration = 0.3; // 动画持续时间，默认 0.5s
        // 默认选中单选框
        _checkBox.on = YES;
        // _checkBox.enabled = NO;
        _checkBox.minimumTouchSize = CGSizeMake(25, 25); // 最小触摸大小
        
    }
    return _checkBox;
}

- (UILabel *)checkBoxLabel {
    if (!_checkBoxLabel) {
        _checkBoxLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
            NSForegroundColorAttributeName:[UIColor lightGrayColor]
        };
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"保持登录状态" attributes:attributes];
        [_checkBoxLabel setAttributedText:text];
        [_checkBoxLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _checkBoxLabel;
}

- (BEMCheckBox *)checkBox1 {
    if (!_checkBox1) {
        _checkBox1 = [[BEMCheckBox alloc] initWithFrame:CGRectZero];
        _checkBox1.onAnimationType = BEMAnimationTypeBounce;
        _checkBox1.offAnimationType = BEMAnimationTypeBounce;
        _checkBox1.animationDuration = 0.3;
        _checkBox1.delegate = self;
    }
    return _checkBox1;
}

- (BEMCheckBox *)checkBox2 {
    if (!_checkBox2) {
        _checkBox2 = [[BEMCheckBox alloc] initWithFrame:CGRectZero];
        _checkBox2.onAnimationType = BEMAnimationTypeBounce;
        _checkBox2.offAnimationType = BEMAnimationTypeBounce;
        _checkBox1.animationDuration = 0.3;
        _checkBox2.delegate = self;
    }
    return _checkBox2;
}

#pragma mark - Private

- (void)addSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.checkBox1];
    [self.view addSubview:self.checkBox2];
  
    UILabel *title = [[UILabel alloc] init];
    title.text = @"1.请选择支付方式";
    title.textColor = HexColor(@"#3E91FF");
    title.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.checkBox.mas_bottom).offset(40);
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
    }];
  
    [self.checkBox1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).with.offset(10);
        make.left.equalTo(title.mas_left).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    [self.checkBox2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.checkBox1.mas_bottom).with.offset(15);
        make.left.equalTo(self.checkBox1);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
}

- (void)setupBEMCheckBoxGroup {
    NSArray *checkBoxArray = @[self.checkBox1,self.checkBox2];
    self.checkBoxGroup = [BEMCheckBoxGroup groupWithCheckBoxes:checkBoxArray];
    self.checkBoxGroup.selectedCheckBox = self.checkBox1; // 可选择设置哪个复选框被预选
    self.checkBoxGroup.mustHaveSelection = YES;           // 定义组中是否必须有一个被选择
}

#pragma mark - <BEMCheckBoxDelegate>

// 每当复选框被点击时调用。此方法将在属性更新（on）之后，动画完成之前（如果有的话）被触发。
- (void)didTapCheckBox:(BEMCheckBox*)checkBox {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    [self.view endEditing:YES];
}

// 每次复选框完成动画时被调用以更新属性（on），并且动画完成后触发此方法。 如果没有动画启动，则不会被触发。
- (void)animationDidStopForCheckBox:(BEMCheckBox *)checkBox {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

@end
