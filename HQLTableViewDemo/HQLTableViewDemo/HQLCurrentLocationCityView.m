//
//  HQLCurrentLocationCityView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCurrentLocationCityView.h"

// Framework
#import <INTULocationManager.h>
#import <YYKit.h>
#import <Masonry.h>

@interface HQLCurrentLocationCityView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *currentCityButton;

@end

@implementation HQLCurrentLocationCityView

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self startSingleLocationRequest];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self startSingleLocationRequest];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.currentCityButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(15);
        make.centerY.mas_equalTo(self);
    }];
    [self.currentCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.centerY.mas_equalTo(self);
    }];
}

#pragma mark - Custom Accessors

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"当前城市：";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}

- (UIButton *)currentCityButton {
    if (!_currentCityButton) {
        _currentCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _currentCityButton.enabled = YES;
        
        // 设置按钮标题、颜色、字体
        NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:16.0],
            NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]
        };
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"无锡市"
                                                                               attributes:attributes];
        [_currentCityButton setAttributedTitle:attributedString forState:UIControlStateNormal];
        
        [_currentCityButton addTarget:self action:@selector(currentCityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currentCityButton;
}

#pragma mark - Private

/// 获取设备当前 GPS 位置信息
- (void)startSingleLocationRequest {
    __weak __typeof(self)weakSelf = self;
    INTULocationManager *locationManager = [INTULocationManager sharedInstance];
    [locationManager requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:10.0 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            // 反地理编码：GPS 坐标 -> 省份城市
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                CLPlacemark *currentPlacemark = placemarks.lastObject;
                
                NSString *city = nil;
                // 四个直辖市的城市信息无法通过 locality 属性获得
                if ([currentPlacemark.locality isNotBlank]) {
                    city = currentPlacemark.locality;
                } else {
                    city = currentPlacemark.administrativeArea;
                }
                
                [weakSelf setCurrentCityButtonAttributeTitle:city];
                weakSelf.currentCityButton.enabled = YES;
            }];
        } else if (status == INTULocationStatusServicesDenied) {
            [weakSelf setCurrentCityButtonAttributeTitle:@"无法定位"];
            weakSelf.currentCityButton.enabled = NO;
        }
    }];
}

- (void)setCurrentCityButtonAttributeTitle:(NSString *)title {
    // 设置按钮标题、颜色、字体
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:16.0],
        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]
    };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:title
                                                                           attributes:attributes];
    [self.currentCityButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}

#pragma mark - Actions

- (void)currentCityButtonAction:(UIButton *)sender {
    if (self.currentLocationCityButtonAction) {
        self.currentLocationCityButtonAction(sender.titleLabel.text);
    }
}

@end
