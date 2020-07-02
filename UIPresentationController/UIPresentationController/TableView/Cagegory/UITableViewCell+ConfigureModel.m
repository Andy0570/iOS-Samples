//
//  UITableViewCell+ConfigureModel.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "UITableViewCell+ConfigureModel.h"

@implementation UITableViewCell (ConfigureModel)

- (void)hql_configureForModel:(id<HQLTableViewCellConfigureDelegate>)model {
    if (model.imageName && (model.imageName.length != 0)) {
        self.imageView.image = [UIImage imageNamed:model.imageName];
    }
    self.textLabel.text  = model.titleLabelText;
    self.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)hql_configureForKeyValueModel:(id<HQLTableViewCellKeyValueConfigureDelegate>)model {
    self.textLabel.text       = model.titleLabelText;
    self.detailTextLabel.text = model.detailLabelText;
}

@end
