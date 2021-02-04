//
//  HQLGovermentTableViewCell+ConfigureModel.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/12.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLGovermentTableViewCell+ConfigureModel.h"
#import "HQLGovermentModel.h"

@implementation HQLGovermentTableViewCell (ConfigureModel)

- (void)hql_configureForModel:(ListData *)list {
    self.nameLabel.text = list.name;
    self.addrLabel.text = list.addr;
    self.telLabel.text = list.tel;
}

@end
