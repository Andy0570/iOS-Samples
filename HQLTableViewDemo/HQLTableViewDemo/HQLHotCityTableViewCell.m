//
//  HQLHotCityTableViewCell.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLHotCityTableViewCell.h"
#import <Chameleon.h>
#import "HQLCity.h"


@implementation HQLHotCityTableViewCell

#pragma mark - Initialize

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Custom Accessors

- (void)setHotCities:(NSArray<HQLCity *> *)hotCities {
    _hotCities = hotCities;
    
    [self setupUI];
}

#pragma mark - Private

- (void)setupUI {
    // 算法实例：
    int margin = 0;
    int width = [UIScreen mainScreen].bounds.size.width / 3;
    int height = 48;
    
    [self.hotCities enumerateObjectsUsingBlock:^(HQLCity *currentCity, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSUInteger row = idx / 3;
        NSUInteger col = idx % 3;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(col*(width+margin), row*(height+margin), width, height);
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 1000 + idx;
        [button setTitle:currentCity.name forState:UIControlStateNormal];
        [button setTitleColor:HexColor(@"#333333") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }];
}

#pragma mark - Actions

- (void)cityButtonAction:(UIButton *)sender {
    HQLCity *currentCity = _hotCities[sender.tag - 1000];
    if (self.hotCityButtonAction) {
        self.hotCityButtonAction(currentCity.code, currentCity.name);
    }
}

#pragma mark - Override

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
