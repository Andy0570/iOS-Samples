//
//  HQLGovermentTableViewCell+ConfigureModel.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/12.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLGovermentTableViewCell.h"
@class ListData;

NS_ASSUME_NONNULL_BEGIN

@interface HQLGovermentTableViewCell (ConfigureModel)

- (void)hql_configureForModel:(ListData *)list;

@end

NS_ASSUME_NONNULL_END
