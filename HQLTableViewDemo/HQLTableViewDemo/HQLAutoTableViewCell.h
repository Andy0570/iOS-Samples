//
//  HQLAutoTableViewCell.h
//  HQLTableViewDemo
//
//  Created by ToninTech on 2017/1/13.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQLAutoTableViewCell : UITableViewCell

// 1.xib文件中的 cell 上的控件【自上而下】加好约束
@property (strong, nonatomic) IBOutlet UILabel *keyLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

@end
