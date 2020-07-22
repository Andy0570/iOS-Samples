//
//  HQLCityTableViewCell.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCityTableViewCell.h"

@interface HQLCityTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation HQLCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCityName:(NSString *)cityName {
    _cityName = cityName;
    
    self.titleLabel.text = cityName;
}

@end
