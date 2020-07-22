//
//  HQLCurrentLocationCityView.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CurrentLocationCityButtonActionBlock)(NSString *cityName);

/// 当前定位城市
@interface HQLCurrentLocationCityView : UIView

@property (nonatomic, copy) CurrentLocationCityButtonActionBlock currentLocationCityButtonAction;

@end

NS_ASSUME_NONNULL_END
