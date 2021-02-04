//
//  HQLGovermentTableViewController.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/12.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

// Model
#import "HQLGovermentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HQLGovermentTableViewController : UITableViewController

- (instancetype)initWithGovermentModel:(HQLGovermentModel *)govermentModel;

@end

NS_ASSUME_NONNULL_END
