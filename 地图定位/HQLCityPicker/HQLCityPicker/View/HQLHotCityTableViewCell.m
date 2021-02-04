//
//  HQLHotCityTableViewCell.m
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/1/30.
//

#import "HQLHotCityTableViewCell.h"
#import "HQLProvince.h"

@implementation HQLHotCityTableViewCell

#pragma mark - Custom Accessors

- (void)setHotCities:(NSArray<HQLCity *> *)hotCities {
    _hotCities = hotCities;
    
    if (hotCities.count > 0) {
        [self setupHotCityButtons];
    }
}

#pragma mark - Private

// 遍历 hotCities 数组，创建4x3个按钮
- (void)setupHotCityButtons {
    CGFloat margin = 0;
    //像素对齐优化
    //CGFloat width = CGFloatPixelFloor([UIScreen mainScreen].bounds.size.width / 3);
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat height = 48.0f;
    
    [self.hotCities enumerateObjectsUsingBlock:^(HQLCity *city, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger row = idx / 3;
        NSUInteger col = idx % 3;
        CGRect buttonFrame = CGRectMake(col*(width+margin), row*(height+margin), width, height);
        [self addButtonWithFrame:buttonFrame title:city.name tag:idx];
    }];
}

- (void)addButtonWithFrame:(CGRect)frame title:(NSString *)title tag:(NSUInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor whiteColor];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
}

#pragma mark - Actions

- (void)cityButtonAction:(UIButton *)sender {
    HQLCity *currentCity = _hotCities[sender.tag];
    if (self.hotCityButtonAction) {
        self.hotCityButtonAction(currentCity);
    }
}

@end
