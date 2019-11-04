//
//  HQLSSCardTableViewCell+ConfigureModel.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/12/28.
//  Copyright © 2018 ToninTech. All rights reserved.
//

#import "HQLSSCardTableViewCell+ConfigureModel.h"
#import "HQLSSCardModel.h"
#import <YYKit.h>

@implementation HQLSSCardTableViewCell (ConfigureModel)

- (void)hql_configureForModel:(HQLSSCardModel *)model {
    // 身份证信息隐藏
    if ([model.idNumber isNotBlank] && (model.idNumber.length == 18)) {
        NSString *idNumberString = [model.idNumber stringByReplacingCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
        self.idNumberLabel.text = idNumberString;
    } else {
        self.idNumberLabel.text = model.idNumber;
    }
    
    // 姓名信息隐藏
    if ([model.name isNotBlank]) {
        NSString *nameString = [model.name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        self.nameLabel.text = nameString;
    } else {
        self.nameLabel.text = model.name;
    }
    
    // 主/副卡 标识
    self.cardTypeLabel.text = model.isMasterCard ? @"主卡" : @"副卡";
    
    // 主副卡是否正在使用中
    self.cardSelectedImageView.hidden = !model.isCardUsing;
}

@end
