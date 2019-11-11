//
//  HQLItemCell.h
//  HQLHomepwner
//
//  Created by ToninTech on 2017/5/18.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQLItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (copy, nonatomic) void(^actionBlock)(void);
@end
