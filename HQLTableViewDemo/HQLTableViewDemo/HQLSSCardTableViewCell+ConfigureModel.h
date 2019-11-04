//
//  HQLSSCardTableViewCell+ConfigureModel.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/12/28.
//  Copyright © 2018 ToninTech. All rights reserved.
//

#import "HQLSSCardTableViewCell.h"
@class HQLSSCardModel;

NS_ASSUME_NONNULL_BEGIN

@interface HQLSSCardTableViewCell (ConfigureModel)

- (void)hql_configureForModel:(HQLSSCardModel *)model;

@end

NS_ASSUME_NONNULL_END
