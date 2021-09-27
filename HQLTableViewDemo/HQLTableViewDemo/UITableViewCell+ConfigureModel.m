//
//  UITableViewCell+ConfigureModel.m
//  iOS Project
//
//  Created by Qilin Hu on 2020/11/07.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "UITableViewCell+ConfigureModel.h"
#import <NSString+YYAdd.h>

@implementation UITableViewCell (ConfigureModel)

- (void)hql_configureForModel:(id<HQLTableViewCellConfigureDelegate>)model {
    if ([model respondsToSelector:@selector(imageName)]) {
        if ([model.imageName isKindOfClass:NSString.class] && [model.imageName isNotBlank]) {
            self.imageView.image = [UIImage imageNamed:model.imageName];
        }
    }
    if ([model respondsToSelector:@selector(titleLabelText)]) {
        self.textLabel.text = model.titleLabelText;
    }
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)hql_configureForKeyValueModel:(id<HQLTableViewCellConfigureDelegate>)model {
    if ([model respondsToSelector:@selector(titleLabelText)]) {
        self.textLabel.text = model.titleLabelText;
    }
    if ([model respondsToSelector:@selector(detailLabelText)]) {
        self.detailTextLabel.text = model.detailLabelText;
    }
}

@end
