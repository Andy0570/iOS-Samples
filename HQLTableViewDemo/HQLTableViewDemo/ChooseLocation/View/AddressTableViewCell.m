//
//  AddressTableViewCell.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "AddressItem.h"

@interface AddressTableViewCell ()

// 地址标签
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
// 勾选的图片
@property (weak, nonatomic) IBOutlet UIImageView *selectFlag;

@end

@implementation AddressTableViewCell

#pragma mark - Custom Accessors

// 设置 cell 的文本和字体颜色，根据选中情况判断是否需要隐藏 flag
- (void)setItem:(AddressItem *)item{
    _item = item;
    _addressLabel.text = item.name;
    _addressLabel.textColor = item.isSelected ? [UIColor orangeColor] : [UIColor blackColor] ;
    _selectFlag.hidden = !item.isSelected;
}

@end
