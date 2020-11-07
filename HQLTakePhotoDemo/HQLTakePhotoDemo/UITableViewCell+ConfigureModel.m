//
//  UITableViewCell+ConfigureModel.m
//  XuZhouSS
//
//  Created by ToninTech on 2017/6/7.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "UITableViewCell+ConfigureModel.h"
#import <YYKit/NSString+YYAdd.h>

@implementation UITableViewCell (ConfigureModel)

- (void)hql_configureForModel:(id<HQLTableViewCellConfigureDelegate>)model {
    if ([model respondsToSelector:@selector(imageName)]) {
        if ([model.imageName isKindOfClass:NSString.class] && [model.imageName isNotBlank]) {
            self.imageView.image = [UIImage imageNamed:model.imageName];
        }
    }
    if ([model respondsToSelector:@selector(titleLabelText)]) {
        self.textLabel.text  = model.titleLabelText;
    }
    self.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)hql_configureForKeyValueModel:(id<HQLTableViewCellConfigureDelegate>)model {
    if ([model respondsToSelector:@selector(titleLabelText)]) {
        self.textLabel.text  = model.titleLabelText;
    }
    if ([model respondsToSelector:@selector(detailLabelText)]) {
        self.detailTextLabel.text = model.detailLabelText;
    }
}

@end
