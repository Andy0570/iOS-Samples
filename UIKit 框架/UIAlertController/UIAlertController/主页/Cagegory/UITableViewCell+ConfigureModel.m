//
//  UITableViewCell+ConfigureModel.m
//  XuZhouSS
//
//  Created by ToninTech on 2017/6/7.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "UITableViewCell+ConfigureModel.h"

@implementation UITableViewCell (ConfigureModel)

- (void)hql_configureForModel:(id<HQLTableViewCellConfigureDelegate>)model {
    self.imageView.image = [UIImage imageNamed:model.imageName];
    self.textLabel.text  = model.titleLabelText;
    self.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)hql_configureForKeyValueModel:(id<HQLTableViewCellKeyValueConfigureDelegate>)model {
    self.textLabel.text       = model.titleLabelText;
    self.detailTextLabel.text = model.detailLabelText;
}

@end
