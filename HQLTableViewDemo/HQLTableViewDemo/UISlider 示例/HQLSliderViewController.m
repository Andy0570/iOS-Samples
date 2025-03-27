//
//  HQLSliderViewController.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/3/26.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "HQLSliderViewController.h"

// Framework
#import <Masonry.h>
#import <YYKit.h>

// View
#import "HQLCustomSlider.h"

@interface HQLSliderViewController ()

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) YYLabel *valueLabel;

@property (nonatomic, strong) HQLCustomSlider *customSlider;
@end

@implementation HQLSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self.slider setValue:50.0 animated:YES];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(16);
        make.leading.equalTo(self.view.mas_leading).offset(16);
        make.trailing.equalTo(self.view.mas_trailing).offset(-16);
        make.height.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slider.mas_bottom).offset(16);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.customSlider];
    [self.customSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueLabel.mas_bottom).offset(16);
        make.leading.equalTo(self.view.mas_leading).offset(16);
        make.trailing.equalTo(self.view.mas_trailing).offset(-16);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - Actions

- (void)sliderValueChanged:(UISlider *)slider {
    NSLog(@"slider value = %f", slider.value);
    
    if (slider.tag == 100) {
        self.valueLabel.text = [NSString stringWithFormat:@"slider value = %.2f", slider.value];
        [self.valueLabel sizeToFit];
    } else {
        
    }
}

#pragma mark - Custom Accessors

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectZero];
        _slider.translatesAutoresizingMaskIntoConstraints = NO;
        _slider.minimumValue = 0.0;
        _slider.maximumValue = 100.0;
        _slider.continuous = NO; // 默认值为 YES，如果设置为 NO，则每次滑块停止移动后才触发事件
        
        _slider.minimumTrackTintColor = [UIColor systemBlueColor];
        _slider.maximumTrackTintColor = [UIColor systemGray2Color];
        _slider.thumbTintColor = [UIColor systemTealColor];
        
        // 设置 slider 轨道图片
        // _slider.setMinimumTrackImage(minTrackImage.resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)), forState: UIControlState.Normal)
        
        // 设置滑块划过部分的线条图案
        // [_slider setMinimumTrackImage:[UIImage imageNamed:@"lightbulb-regular"] forState:UIControlStateNormal];
        // 设置滑块未划过部分的线条图案
        // [_slider setMaximumTrackImage:[UIImage imageNamed:@"lightbulb-solid"] forState:UIControlStateNormal];
        
        // 设置 slider 左右两边的图片，需要自行缩放到合适尺寸
    //    CGSize imageSize = CGSizeMake(24, 24);
    //    _slider.minimumValueImage = [[UIImage imageNamed:@"lightbulb-regular"] imageByResizeToSize:imageSize contentMode:UIViewContentModeScaleAspectFit];
    //    _slider.maximumValueImage = [[UIImage imageNamed:@"lightbulb-solid"] imageByResizeToSize:imageSize contentMode:UIViewContentModeScaleAspectFit];
        
        // 设置滑块最左端显示的图片
        _slider.minimumValueImage = [UIImage imageNamed:@"minus-outline"];
        // 设置滑块最右端显示的图片
        _slider.maximumValueImage = [UIImage imageNamed:@"plus-outline"];
        
        _slider.tag = 100;
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (YYLabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        // 字体样式
        _valueLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightSemibold];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.textColor = [UIColor blackColor];
        
        _valueLabel.textContainerInset = UIEdgeInsetsMake(2, 5, 2, 5);
        _valueLabel.preferredMaxLayoutWidth = kScreenWidth - 32;
        
        // 优化设置圆角（推荐方法）
        // 设置 layer 的背景颜色，这样就可以避免离屏渲染问题
        _valueLabel.layer.backgroundColor = UIColorHex(#62C067).CGColor;
        _valueLabel.layer.cornerRadius = 5;
        // _valueLabel.layer.masksToBounds = YES;
    }
    return _valueLabel;
}

- (HQLCustomSlider *)customSlider {
    if (!_customSlider) {
        _customSlider = [[HQLCustomSlider alloc] initWithFrame:CGRectZero];
        _customSlider.translatesAutoresizingMaskIntoConstraints = NO;
        _customSlider.minimumValue = 0.0;
        _customSlider.maximumValue = 100.0;
        _customSlider.continuous = NO; // 默认值为 YES，如果设置为 NO，则每次滑块停止移动后才触发事件
        
        _customSlider.minimumTrackTintColor = [UIColor systemBlueColor];
        _customSlider.maximumTrackTintColor = [UIColor systemGray2Color];
        _customSlider.thumbTintColor = [UIColor systemBlueColor];
        
        _customSlider.tag = 200;
        [_customSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _customSlider;
}

@end
